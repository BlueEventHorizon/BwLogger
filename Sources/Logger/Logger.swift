//
//  Logger.swift
//  BwTools
//
//  Created by k2moons on 2017/08/18.
//  Copyright (c) 2017 k2moons. All rights reserved.
//

import Foundation

protocol LoggerDependencies {
    func log(_ formedMessage: String, original: String, level: Logger.Level)
    func isEnabled(_ level: Logger.Level) -> Bool
}

class DefaultLoggerDependencies: LoggerDependencies {
    public func log(_ formedMessage: String, original: String, level: Logger.Level) {
        print(formedMessage)
    }
    public func isEnabled(_ level: Logger.Level) -> Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
}

// =============================================================================
// MARK: - Logger
// =============================================================================

public final class Logger
{
    var dep: LoggerDependencies = DefaultLoggerDependencies()

    private var levels: [Level]?
    private var prefix: String = ""

    public init() {}
    public init(levels: [Level]? = nil, prefix: String = "") {
        self.levels = levels
        self.prefix = prefix
    }

    /// Format message and other metrics for log output.
    ///
    /// - Parameters:
    ///   - message: your main message
    ///   - postMessage: your message behind other metrics
    ///   - shifter: log starting position shifter by space
    ///   - level: log level
    ///   - instance: instance which has sent this log/message
    ///   - function: function name
    ///   - file: fine name
    ///   - line: line number
    /// - Returns: formatted strings for log
    private func formatter(_ message: String, postMessage: String = "", shifter: Int = 0, level: Level, instance: Any, function: String, file: String, line: Int) -> String {
        var shifterString: String = ""
        if shifter > 0 {
            shifterString = String(repeating: " ", count: shifter)
        }

        // Log Thread
        var threadName: String = "main"
        if !Thread.isMainThread {
            if let _threadName = Thread.current.name, !_threadName.isEmpty {
                threadName = _threadName
            } else if let _queueName = String(validatingUTF8: __dispatch_queue_get_label(nil)), !_queueName.isEmpty {
                threadName = _queueName
            } else {
                threadName = Thread.current.description
            }
        }

        // Log Date
        var result: String = "\(prefix)\(shifterString)\(level.presentation()) [\(Date().string(dateFormat: "yyyy-MM-dd HH:mm:ss"))]"
        if level.isEnabledThread() {
            result += " [\(threadName)]"
        }
        var sep1 = ""

        // Log File
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        var classNameLocal: String = ""

        // Log Message
        if !message.isEmpty {
            result += " \(message)"
            sep1 = " __"
        }

        // Log Class/Function
        if level.isEnabledFunctionName() {
            if let _ = instance as? AnyClass {
                classNameLocal = String(describing: type(of: self))
            } else if let stringObject = instance as? String {
                classNameLocal = stringObject.getSwiftFileName() ?? stringObject
            }

            if classNameLocal.isEmpty {
                result += "\(sep1) \(function)"
            } else {
                result += "\(sep1) \(classNameLocal):\(function)"
            }
        }

        // Post Message
        if !postMessage.isEmpty {
            result += " __" + " \(postMessage)"
        }

        // File/Line Information
        if level.isEnabledLineNumber() {
            result += " \(fileName):\(line)"
        }

        return result
    }

    // =============================================================================
    // MARK: - API
    // =============================================================================

    /// Output log
    ///
    /// - Parameters:
    ///   - original: original message
    ///   - postMessage: sub message added after
    ///   - shifter: if function is nested, tihs log will be shifted by this count
    ///   - level: log level
    ///   - instance: if you don't add instance object, file name will be used, but if you add instance object that has Identifiable protocol, you can see class name instead of file name.
    ///   - function: automatically added function name
    ///   - file: automatically added file name
    ///   - line: automatically added line number
    static private let semaphore  = DispatchSemaphore(value: 1)
    internal func log(_ original: String, postMessage: String = "", shifter: Int = 0, level: Level, instance: Any, function: String, file: String, line: Int) {
        Logger.semaphore.wait()
        defer {
            Logger.semaphore.signal()
        }

        guard dep.isEnabled(level) else { return }
        guard levels?.contains(level) ?? false || levels == nil else { return }

        let formedMessage = formatter(original, postMessage: postMessage, shifter: shifter, level: level, instance: instance, function: function, file: file, line: line)
        dep.log(formedMessage, original: original, level: level)

        if level == .fatal {
            assert(false, formedMessage)
        }
    }
}

// =============================================================================
// MARK: - Logger.Level
// =============================================================================

public extension Logger {
    enum Level: String, CaseIterable {
        case enter      // enter into method
        case exit       // exit from method
        case screen     // screen appeared
        case debug      // for debug
        case info       // for generic information
        case warn       // for warning
        case error      // for error
        case fatal      // for fatal error (assert)

        public func presentation() -> String {
            switch self {
            case .enter:    return "========>"
            case .exit:     return "<========"
            case .screen:   return "[⏩SCREN]"
            case .debug:    return "[🔸DEBUG]"
            case .info:     return "[🔹INFO ]"
            case .warn:     return "[⚠️WARN ]"
            case .error:    return "[❌ERROR]"
            case .fatal:    return "[❌FATAL]"
            }
        }

        // true: Add file name and line number at the end of log
        fileprivate func isEnabledLineNumber() -> Bool {
            switch self {
            case .enter:    return false
            case .exit:     return false
            case .info:     return false
            default:        return true
            }
        }

        fileprivate func isEnabledThread() -> Bool {
            switch self {
            case .info:     return false
            default:        return true
            }
        }

        fileprivate func isEnabledFunctionName() -> Bool {
            switch self {
            case .info, .screen:    return false
            default:                return true
            }
        }
    }
}

// =============================================================================
// MARK: - extension
// =============================================================================

public extension Logger {
    /// Method Entered Log
    ///
    /// - Parameters:
    ///   - instance: if you don't add instance object, file name will be used, but if you add instance object that has Identifiable protocol, you can see class name instead of file name.
    ///   - message: sub message
    ///   - shifter: if function is nested, tihs log will be shifted by this count
    ///   - function: automatically added function name
    ///   - file: automatically added file name
    ///   - line: automatically added line number
    func entered(_ instance: Any = #file, message: String = "", shifter: Int = 0, function: String = #function, file: String = #file, line: Int = #line) {
        self.log("", postMessage: message, shifter: shifter, level: .enter, instance: instance, function: function, file: file, line: line)
    }

    // Method Exit Log
    func exit(_ instance: Any = #file, message: String = "", shifter: Int = 0, function: String = #function, file: String = #file, line: Int = #line) {
        self.log("", postMessage: message, shifter: shifter, level: .exit, instance: instance, function: function, file: file, line: line)
    }

    func screen(_ message: String, instance: Any = #file, function: String = #function, file: String = #file, line: Int = #line) {
        self.log(message, level: .screen, instance: instance, function: function, file: file, line: line)
    }

    func debug(_ message: String, instance: Any = #file, function: String = #function, file: String = #file, line: Int = #line) {
        self.log(message, level: .debug, instance: instance, function: function, file: file, line: line)
    }

    func info(_ message: String, instance: Any = #file, function: String = #function, file: String = #file, line: Int = #line) {
        self.log(message, level: .info, instance: instance, function: function, file: file, line: line)
    }

    func warn(_ message: String, instance: Any = #file, function: String = #function, file: String = #file, line: Int = #line) {
        self.log(message, level: .warn, instance: instance, function: function, file: file, line: line)
    }

    func error(_ message: String, instance: Any = #file, function: String = #function, file: String = #file, line: Int = #line) {
        self.log(message, level: .error, instance: instance, function: function, file: file, line: line)
    }

    func fatal(_ message: String, instance: Any = #file, function: String = #function, file: String = #file, line: Int = #line) {
        self.log(message, level: .fatal, instance: instance, function: function, file: file, line: line)
    }
}

private extension String {
    
    func getSwiftFileName() -> String? {
        var fileName: String?
        guard self.hasSuffix(".swift") else { return fileName }
        let path: [String] = self.components(separatedBy: "/")
        if let last = path.last {
            let components: [String] = last.components(separatedBy: ".")
            fileName = components.first
        }
        return fileName
    }
}

private extension DateFormatter {
    // Standard formatter for current timezone.
    static let standard: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter
    }()
}

private extension Date {
    // Date → String
    func string(dateFormat: String) -> String {
        let formatter = DateFormatter.standard
        formatter.dateFormat = dateFormat
        return formatter.string(from: self)
    }
}

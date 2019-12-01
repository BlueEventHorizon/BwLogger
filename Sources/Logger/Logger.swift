//
//  Logger.swift
//  Logger
//
//  Created by k2moons on 2017/08/18.
//  Copyright (c) 2017 k2moons. All rights reserved.
//

import Foundation

public protocol LoggerDependency {
    func log(_ formedMessage: String, original: String, level: Logger.Level)
    func preFix(_ level: Logger.Level) -> String
    func isEnabled(_ level: Logger.Level) -> Bool
    func isEnabledThreadName(_ level: Logger.Level) -> Bool             // Thread Information
    func isEnabledClassAndMethodName(_ level: Logger.Level) -> Bool     // Class/Function Information
    func isEnabledFileAndLineNumber(_ level: Logger.Level) -> Bool      // File/Line Information
}

public extension LoggerDependency {
    func log(_ formedMessage: String, original: String, level: Logger.Level) {
        print(formedMessage)
    }
    func preFix(_ level: Logger.Level) -> String {
        switch level {
        case .enter:    return "========>"
        case .exit:     return "<========"

        case .debug:    return "[🔸DEBUG]"
        case .info:     return "[🔹INFO ]"
        case .warn:     return "[⚠️WARN ]"
        case .error:    return "[❌ERROR]"
        case .fatal:    return "[❌FATAL]"
        }
    }
    func isEnabled(_ level: Logger.Level) -> Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    func isEnabledThreadName(_ level: Logger.Level) -> Bool {
        switch level {
        case .info:     return false
        default:        return true
        }
    }
    func isEnabledClassAndMethodName(_ level: Logger.Level) -> Bool {
        switch level {
        case .info:     return false
        default:        return true
        }
    }
    // true: Add file name and line number at the end of log
    func isEnabledFileAndLineNumber(_ level: Logger.Level) -> Bool {
        return false
    }
}

public final class DefaultLoggerDependency: LoggerDependency {
    public init() { }
}

// =============================================================================
// MARK: - Logger
// =============================================================================

public final class Logger
{
    public var dep: LoggerDependency = DefaultLoggerDependency()

    private var levels: [Level]?

    public init() {}
    public init(levels: [Level]? = nil) {
        self.levels = levels
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
        // Space Shifter
        var shifterString: String = ""
        if shifter > 0 {
            shifterString = String(repeating: " ", count: shifter)
        }

        // Thread Information
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

        // Date
        var result: String = "\(shifterString)\(dep.preFix(level)) [\(Date().string(dateFormat: "yyyy-MM-dd HH:mm:ss"))]"
        if dep.isEnabledThreadName(level) {
            result += " [\(threadName)]"
        }
        var sep1 = ""

        // Log File
        let fileName = URL(fileURLWithPath: file).lastPathComponent

        // Message
        if !message.isEmpty {
            result += " \(message)"
            sep1 = " <<"
        }

        // Class/Function Information
        if dep.isEnabledClassAndMethodName(level) {
            let className = String(describing: type(of: instance))
            if className.isEmpty {
                result += "\(sep1) \(function)"
            } else {
                result += "\(sep1) \(className):\(function)"
            }
        }

        // Post Message
        if !postMessage.isEmpty {
            result += " __" + " \(postMessage)"
        }

        // File/Line Information
        if dep.isEnabledFileAndLineNumber(level) {
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
        case debug      // for debug
        case info       // for generic information
        case warn       // for warning
        case error      // for error
        case fatal      // for fatal error (assert)
        
        case enter      // enter into method
        case exit       // exit from method
    }
}

// =============================================================================
// MARK: - extension
// =============================================================================

public extension Logger {

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

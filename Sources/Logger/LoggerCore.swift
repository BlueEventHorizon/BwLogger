//
//  LoggerCore.swift
//  LoggerCore
//
//  Created by k2moons on 2017/08/18.
//  Copyright (c) 2017 k2moons. All rights reserved.
//

import Foundation

// MARK: - Global Instanse

public let log = LoggerCore(levels: nil)

// MARK: - LoggerDependency

public protocol LoggerDependency {
    func log(_ formedMessage: String, message: String, level: LoggerCore.Level)
    func preFix(_ level: LoggerCore.Level) -> String
    func isEnabled(_ level: LoggerCore.Level) -> Bool
    func getDateType(_ level: LoggerCore.Level) -> LoggerCore.TimeStampType
    func isEnabledThreadName(_ level: LoggerCore.Level) -> Bool                             // Thread Information
    func isEnabledClassAndMethodName(_ level: LoggerCore.Level) -> LoggerCore.DescriptionType   // Class/Function Information
    func isEnabledFileAndLineNumber(_ level: LoggerCore.Level) -> Bool                      // File/Line Information
    func sepalator() -> String
    func sepalator2() -> String
}

public extension LoggerDependency {
    func log(_ formedMessage: String, message: String, level: LoggerCore.Level) {
        print(formedMessage)
    }
    func preFix(_ level: LoggerCore.Level) -> String {
        switch level {
        case .enter:    return "➡️"
        case .exit:     return "⬅️"

        case .info:     return "🔹"
        case .debug:    return "🔸"
        case .warn:     return "⚠️"
        case .error:    return "❌"
        case .fatal:    return "🔥"
        }
    }
    func isEnabled(_ level: LoggerCore.Level) -> Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    func getDateType(_ level: LoggerCore.Level) -> LoggerCore.TimeStampType {
        switch level {
        case .enter:    return .none
        case .exit:     return .none
        case .info:     return .msec
        default:        return .msec
        }
    }
    func isEnabledThreadName(_ level: LoggerCore.Level) -> Bool {
        switch level {
        case .info:     return false
        default:        return true
        }
    }
    func isEnabledClassAndMethodName(_ level: LoggerCore.Level) -> LoggerCore.DescriptionType {
        switch level {
        case .enter, .exit: return .normal
        case .info:         return .none
        default:            return .detail
        }
    }
    // true: Add file name and line number at the end of log
    func isEnabledFileAndLineNumber(_ level: LoggerCore.Level) -> Bool {
        switch level {
        case .enter:    return false
        case .exit:     return false
        case .info:     return false
        default:        return true
        }
    }

    func sepalator() -> String {
        return " --"
    }

    func sepalator2() -> String {
        return " --"
    }
}

public final class DefaultLoggerDependencies: LoggerDependency {
    public init() { }
}

// MARK: - LoggerCore

public final class LoggerCore: LogHandler {

    public var metadata: Logger.Metadata
    
    public var logLevel: Logger.Level
    
    /// Output log
    ///
    /// - Parameters:
    ///   - message: original message
    ///   - postMessage: sub message added after
    ///   - shifter: if function is nested, tihs log will be shifted by this count
    ///   - level: log level
    ///   - instance: if you don't add instance object, file name will be used, but if you add instance object that has Identifiable protocol, you can see class name instead of file name.
    ///   - function: automatically added function name
    ///   - file: automatically added file name
    ///   - line: automatically added line number
    static private let semaphore  = DispatchSemaphore(value: 1)
    internal func log(_ message: String, postMessage: String = "", shifter: Int = 0, level: Level, instance: Any, function: String, file: String, line: Int) {
        LoggerCore.semaphore.wait()
        defer {
            LoggerCore.semaphore.signal()
        }

        guard dep.isEnabled(level) else { return }
        guard levels?.contains(level) ?? false || levels == nil else { return }

        let formedMessage = formatter(message, postMessage: postMessage, shifter: shifter, level: level, instance: instance, function: function, file: file, line: line)
        dep.log(formedMessage, message: message, level: level)

        if level == .fatal {
            assert(false, formedMessage)
        }
    }

    public func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?, file: String, function: String, line: UInt) {
        let formedMessage = formatter(message, postMessage: postMessage, shifter: shifter, level: level, instance: instance, function: function, file: file, line: line)
        dep.log(formedMessage, message: message, level: level)
    }
    
    public subscript(metadataKey _: String) -> Logger.Metadata.Value? {
        get {
            <#code#>
        }
        set {
            <#code#>
        }
    }
    
    public var dep: LoggerDependency = DefaultLoggerDependencies()

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
        var result: String = "\(shifterString)\(dep.preFix(level))"

        // Date
        switch dep.getDateType(level) {
        case .none:
            break
        case .sec:
            result = result + " [\(Date().string(dateFormat: "yyyy-MM-dd HH:mm:ss"))]"
        case .msec:
            result = result + " [\(Date().string(dateFormat: "yyyy-MM-dd HH:mm:ss.SSS"))]"
        }

        // Thread Information
        if dep.isEnabledThreadName(level) {
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
            result += " [\(threadName)]"
        }
        var sepalator = ""

        // File Name
        let fileName = URL(fileURLWithPath: file).lastPathComponent

        // Message
        if !message.isEmpty {
            result += " \(message)"
            sepalator = dep.sepalator()
        }

        // Class/Function Information
        let nameType = dep.isEnabledClassAndMethodName(level)
        if nameType != .none {
            let className = String(describing: instance)
            if className.isEmpty {
                result += "\(sepalator) \(fileName):\(function)"  // --> xxxxx.swift:function
            } else {
                switch nameType {
                case .normal:
                    result += "\(sepalator) \(String(describing: type(of: instance))):\(function)"
                case .detail:
                    result += "\(sepalator) \(className):\(function)"
                case .none:
                    break // never
                }
            }
        }

        // Post Message
        if !postMessage.isEmpty {
            result += dep.sepalator2() + " \(postMessage)"
        }

        // File/Line Information
        if dep.isEnabledFileAndLineNumber(level) {
            result += " \(fileName):\(line)"
        }

        return result
    }
}

// MARK: - LoggerCore.Level

public extension LoggerCore {
    enum Level: String, CaseIterable {
        case enter      // enter into method
        case exit       // exit from method

        case info       // for generic information
        case debug      // for debug
        case warn       // for warning
        case error      // for error
        case fatal      // for fatal error (assert)
    }
}

// MARK: - LoggerCore.TimeStampType

public extension LoggerCore {
    enum TimeStampType {
        case none
        case sec
        case msec
    }
}

// MARK: - LoggerCore.DescriptionType

public extension LoggerCore {
    enum DescriptionType {
        case none
        case normal
        case detail
    }
}

// MARK: - LoggerCore Standard API

public extension LoggerCore {

    /// Public Interface for LoggerCore
    ///
    /// - Parameters:
    ///   - message: sub message
    ///   - instance: if you don't add instance object, file name will be used, but if you add instance object that has Identifiable protocol, you can see class name instead of file name.
    ///   - function: automatically added function name
    ///   - file: automatically added file name
    ///   - line: automatically added line number
    func debug(_ message: String, instance: Any = "", function: String = #function, file: String = #file, line: Int = #line) {
        self.log(message, level: .debug, instance: instance, function: function, file: file, line: line)
    }

    func info(_ message: String, instance: Any = "", function: String = #function, file: String = #file, line: Int = #line) {
        self.log(message, level: .info, instance: instance, function: function, file: file, line: line)
    }

    func warn(_ message: String, instance: Any = "", function: String = #function, file: String = #file, line: Int = #line) {
        self.log(message, level: .warn, instance: instance, function: function, file: file, line: line)
    }

    func error(_ message: String, instance: Any = "", function: String = #function, file: String = #file, line: Int = #line) {
        self.log(message, level: .error, instance: instance, function: function, file: file, line: line)
    }

    func fatal(_ message: String, instance: Any = "", function: String = #function, file: String = #file, line: Int = #line) {
        self.log(message, level: .fatal, instance: instance, function: function, file: file, line: line)
    }
}

// MARK: - For entering into/exiting from method

public extension LoggerCore {
    func entered(_ instance: Any = "", message: String = "", shifter: Int = 0, function: String = #function, file: String = #file, line: Int = #line) {
        self.log("", postMessage: message, shifter: shifter, level: .enter, instance: instance, function: function, file: file, line: line)
    }

    func exit(_ instance: Any = "", message: String = "", shifter: Int = 0, function: String = #function, file: String = #file, line: Int = #line) {
        self.log("", postMessage: message, shifter: shifter, level: .exit, instance: instance, function: function, file: file, line: line)
    }
}

// MARK: - For deinit()

public extension LoggerCore {
    func dispose(_ obj: Any) {
        print("❎ \(String(describing: type(of: obj)))")
    }
}


//
//  Logger.swift
//  Logger
//
//  Created by k2moons on 2017/08/18.
//  Copyright (c) 2017 k2moons. All rights reserved.
//

import Foundation

// MARK: - Logger

// Global Logger Instanse
public let log = Logger()

public final class Logger {

    public private(set) var dep: LoggerDependency = DefaultLoggerDependencies()

    private var levels: [Level]?

    static private let semaphore  = DispatchSemaphore(value: 1)

    public init() {}
    public init(levels: [Level]? = nil) {

        self.levels = levels
    }

    public func setDependency(_ dependency: LoggerDependency) -> Logger {
        self.dep = dependency
        return self
    }

    /// Format message and other metrics for log output.
    /// - Parameters:
    ///   - level: log level
    ///   - message: your main message
    ///   - postfix: your message behind other metrics
    ///   - instance: instance which has sent this log/message
    ///   - file: fine name
    ///   - function: function name
    ///   - line: line number
    /// - Returns: formatted strings for log

    private func formatter(

        level: Level,
        message: String,
        postfix: String = "",
        instance: Any,
        file: String,
        function: String, line: Int

    ) -> String {

        // ----------------------
        // PreFix

        var string: String = "\(dep.preFix(level))"

        // ----------------------
        // Date

        let timestamp: String = Date().string(dateFormat: dep.getTimeStampType(level).style)

        if timestamp.isNotEmpty {
            string = "\(string) [\(timestamp)]"
        }

        // ----------------------
        // Thread

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
            string += " [\(threadName)]"
        }

        // ----------------------
        // Message

        var sepalator = ""

        if message.isNotEmpty {

            string  = "\(string) \(message)"
            sepalator = dep.sepalator()
        }

        // ----------------------
        // Class Name /Function Name

        let fileName = URL(fileURLWithPath: file).lastPathComponent
        let nameType = dep.isEnabledClassAndMethodName(level)

        if nameType != .none {

            let className = String(describing: instance)

            if className.isEmpty, let _fileName = fileName.components(separatedBy:".").first {

                string = "\(string) \(sepalator) \(_fileName):\(function)"

            } else {

                switch nameType {
                    case .normal:
                        string += "\(sepalator) \(String(describing: type(of: instance))):\(function)"
                    case .detail:
                        string += "\(sepalator) \(className):\(function)"
                    case .none:
                        break // never
                }
            }
        }

        // ----------------------
        // Postfix

        if postfix.isNotEmpty {

            string += dep.sepalator2() + " \(postfix)"

        }

        // ----------------------
        // File Name / Line Number

        if dep.isEnabledFileAndLineNumber(level) {

            string += " \(fileName):\(line)"

        }

        return string
    }

    public func isEnabled(with level: Level) -> Bool {

        guard dep.isEnabled(.notice) else { return false }

        guard levels?.contains(level) ?? false || levels == nil else { return false }

        return true
    }

    /// log
    /// - Parameters:
    ///   - level: log level
    ///   - message: main message
    ///   - postfix: postfix message
    ///   - instance: if you don't add instance object, file name will be used, but if you add instance object that has Identifiable protocol, you can see class name instead of file name.
    ///   - file: automatically added file name
    ///   - function: automatically added function name
    ///   - line: automatically added line number

    public func log(
        level: Level,
        message: String,
        postfix: String = "",
        instance: Any,
        file: String,
        function: String,
        line: Int
    ) {
        Logger.semaphore.wait()
        defer {
            Logger.semaphore.signal()
        }

        let formattedMessage = formatter(
            level: level,
            message: message,
            postfix: postfix,
            instance: instance,
            file: file,
            function: function,
            line: line)

        dep.log(level: level, message: message, formattedMessage: formattedMessage )

        if level == .fatal {
            assert(false, formattedMessage)
        }
    }
}

// MARK: - Logger.Level

public extension Logger {

    enum Level: String, Codable, CaseIterable {
        /// Appropriate for messages that contain information only when debugging a program.
        case trace

        /// Appropriate for messages that contain information normally of use only when
        /// debugging a program.
        case debug

        /// Appropriate for informational messages.
        case info

        /// Appropriate for conditions that are not error conditions, but that may require
        /// special handling.
        case notice

        /// Appropriate for messages that are not error conditions, but more severe than
        /// `.notice`.
        case warning

        /// Appropriate for error conditions.
        case error

        /// Appropriate for critical error conditions that usually require immediate
        /// attention.
        case fatal
    }
}

// MARK: - Logger.TimeStampType

public extension Logger {

    enum TimeStampType: String {

        case none
        case detail
        case simple
        case normal
        case full

        var style: String {

            switch self {
                case .none:
                    return ""
                case .detail:
                    return "HH:mm:ss.SSS"
                case .simple:
                    return "MM/dd HH:mm:ss.SSS"
                case .normal:
                    return "yyyy/MM/dd HH:mm:ss.SSS"
                case .full:
                    return "yyyy/MM/dd HH:mm:ss.SSS z"
            }
        }
    }
}

// MARK: - Logger.DescriptionType

public extension Logger {

    enum DescriptionType {

        case none
        case normal
        case detail
    }
}

// MARK: - Logger Standard API

public extension Logger {

    @inlinable
    func entered(_ instance: Any = "", message: String = "", shifter: Int = 0, function: String = #function, file: String = #file, line: Int = #line) {
        guard dep.isEnabled(.trace) else { return }

        self.log(level: .trace, message: "", postfix: message, instance: instance, file: file, function: function, line: line)
    }

    @inlinable
    func info(_ message: String, instance: Any = "", function: String = #function, file: String = #file, line: Int = #line) {
        guard dep.isEnabled(.info) else { return }

        self.log(level: .info, message: message, instance: instance, file: file, function: function, line: line)
    }

    @inlinable
    func debug(_ message: String, instance: Any = "", function: String = #function, file: String = #file, line: Int = #line) {
        guard dep.isEnabled(.debug) else { return }

        self.log(level: .debug, message: message, instance: instance, file: file, function: function, line: line)
    }

    @inlinable
    func notice(_ message: String, instance: Any = "", function: String = #function, file: String = #file, line: Int = #line) {
        guard dep.isEnabled(.notice) else { return }

        self.log(level: .notice, message: message, instance: instance, file: file, function: function, line: line)
    }

    @inlinable
    func warning(_ message: String, instance: Any = "", function: String = #function, file: String = #file, line: Int = #line) {
        guard dep.isEnabled(.warning) else { return }

        self.log(level: .warning, message: message, instance: instance, file: file, function: function, line: line)
    }

    @inlinable
    func error(_ message: String, instance: Any = "", function: String = #function, file: String = #file, line: Int = #line) {
        guard dep.isEnabled(.error) else { return }

        self.log(level: .error, message: message, instance: instance, file: file, function: function, line: line)
    }

    @inlinable
    func fatal(_ message: String, instance: Any = "", function: String = #function, file: String = #file, line: Int = #line) {
        guard dep.isEnabled(.fatal) else { return }

        self.log(level: .fatal, message: message, instance: instance, file: file, function: function, line: line)
    }
}

// MARK: - For deinit()

public extension Logger {

    func `deinit`(_ obj: Any) {

        print("[❎ deinit] \(String(describing: type(of: obj)))")
    }
}

// MARK: - LoggerDependency

public protocol LoggerDependency {
    func log(level: Logger.Level, message: String, formattedMessage: String)
    func preFix(_ level: Logger.Level) -> String
    func isEnabled(_ level: Logger.Level) -> Bool
    func getTimeStampType(_ level: Logger.Level) -> Logger.TimeStampType
    func isEnabledThreadName(_ level: Logger.Level) -> Bool                             // Thread Information
    func isEnabledClassAndMethodName(_ level: Logger.Level) -> Logger.DescriptionType   // Class/Function Information
    func isEnabledFileAndLineNumber(_ level: Logger.Level) -> Bool                      // File/Line Information
    func sepalator() -> String
    func sepalator2() -> String
}

public extension LoggerDependency {

    // Define output method
    func log(level: Logger.Level, message: String, formattedMessage: String) {

        print(formattedMessage)
    }

    func preFix(_ level: Logger.Level) -> String {

        switch level {

            case .trace:    return "===>"
            case .debug:    return "[🟡 DEBG]"
            case .info:     return "[🔵 INFO]"
            case .notice:   return "[🟢 NOTE]"
            case .warning:  return "⚠️⚠️⚠️"
            case .error:    return "❌❌❌"
            case .fatal:    return "🔥🔥🔥"
        }
    }

    func isEnabled(_ level: Logger.Level) -> Bool {

        #if DEBUG

        return true

        #else

        return false

        #endif
    }

    func getTimeStampType(_ level: Logger.Level) -> Logger.TimeStampType {

        #if DEBUG

        switch level {

            case .trace:    return .none
            case .debug:    return .detail
            case .info:     return .detail
            case .notice:   return .detail
            case .warning:  return .detail
            case .error:    return .detail
            case .fatal:    return .detail
        }

        #else

        switch level {

            case .trace:    return .none
            case .debug:    return .full
            case .info:     return .none
            case .notice:   return .full
            case .warning:  return .full
            case .error:    return .full
            case .fatal:    return .full
        }

        #endif
    }

    func isEnabledThreadName(_ level: Logger.Level) -> Bool {

        switch level {

            case .trace:    return false
            case .info:     return false
            default:        return true
        }
    }
    func isEnabledClassAndMethodName(_ level: Logger.Level) -> Logger.DescriptionType {

        switch level {

            case .trace:    return .normal
            case .info:     return .none
            default:        return .detail
        }
    }

    // true: Add file name and line number at the end of log
    func isEnabledFileAndLineNumber(_ level: Logger.Level) -> Bool {

        switch level {

            case .trace:    return false
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

// Default Logger Dependency
private final class DefaultLoggerDependencies: LoggerDependency {

    public init() { }
}

// MARK: - Private extension

#if LOGGER_PRIVATE_EXTENSION_ENABLED

extension String {
    fileprivate var isNotEmpty: Bool {
        return !self.isEmpty
    }
}

extension Date {
    // Date → String
    fileprivate func string(dateFormat: String) -> String {
        let formatter = DateFormatter.standard
        formatter.dateFormat = dateFormat
        return formatter.string(from: self)
    }
}

extension DateFormatter {
    // 現在タイムゾーンの標準フォーマッタ
    fileprivate static let standard: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter
    }()
}

#endif


//
//  Logger.swift
//  Logger
//
//  Created by k2moons on 2017/08/18.
//  Copyright (c) 2017 k2moons. All rights reserved.
//

import Foundation
import os

// MARK: - Logger

public final class Logger {
    public private(set) var dep: LoggerDependency = DefaultLoggerDependencies()

    public private(set) var levels: [Level]?

    private static let semaphore = DispatchSemaphore(value: 1)

    public static let `default`: Logger = Logger()

    public init() {}

    public init(_ dependency: LoggerDependency) {
        self.dep = dependency
    }

    public func setDependency(_ dependency: LoggerDependency) -> Logger {
        self.dep = dependency
        return self
    }

    public func setLevel(_ levels: [Level]) -> Logger {
        self.levels = levels
        return self
    }

    private func formatter(
        level: Level,
        message: String,
        instance: Any, // instance which has sent this log/message
        file: String,
        function: String,
        line: Int

    ) -> String {
        // ----------------------
        // PreFix

        var string: String = "\(dep.preFix(level))"

        // ----------------------
        // Date

        let timestampType = dep.getTimeStampType(level)
        if timestampType != .none {
            let timestamp: String = Date().string(dateFormat: timestampType.style)
            if timestamp.isNotEmpty {
                string = "\(string) [\(timestamp)]"
            }
        }

        // ----------------------
        // Thread

        if dep.isEnabledThreadName(level) {
            string += " [\(getThreadName())]"
        }

        // ----------------------
        // Message

        var classInfoSepalator = ""

        if message.isNotEmpty, level != .trace {
            string = "\(string) \(message)"
            classInfoSepalator = dep.classInfoSepalator()
        }

        // ----------------------
        // Class Name /Function Name

        let fileName = URL(fileURLWithPath: file).lastPathComponent
        let nameType = dep.isEnabledClassAndMethodName(level)

        if nameType != .none {
            let className = String(describing: instance)

            if className.isEmpty, let _fileName = fileName.components(separatedBy: ".").first {
                string = "\(string) \(classInfoSepalator) \(_fileName):\(function)"
            }
            else {
                switch nameType {
                    case .normal:
                        string += "\(classInfoSepalator) \(String(describing: type(of: instance))):\(function)"
                    case .detail:
                        string += "\(classInfoSepalator) \(className):\(function)"
                    case .none:
                        break // never
                }
            }
        }

        // ----------------------
        // Postfix

        if message.isNotEmpty, level == .trace {
            string += dep.postSepalator() + " \(message)"
        }

        // ----------------------
        // File Name / Line Number

        if dep.isEnabledFileAndLineNumber(level) {
            string += " \(fileName):\(line)"
        }

        return string
    }

    private func getThreadName() -> String {
        var threadName: String = "main"

        if !Thread.isMainThread {
            if let _threadName = Thread.current.name, !_threadName.isEmpty {
                threadName = _threadName
            }
            else if let _queueName = String(validatingUTF8: __dispatch_queue_get_label(nil)), !_queueName.isEmpty {
                threadName = _queueName
            }
            else {
                threadName = Thread.current.description
            }
        }

        return threadName
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
    ///   - instance: if you don't add instance message, file name will be used, but if you add instance message that has ClassIdentifiable protocol, you can see class name instead of file name.
    ///   - file: automatically added file name
    ///   - function: automatically added function name
    ///   - line: automatically added line number

    public func log(
        level: Level,
        message: Any,
        instance: Any,
        file: String,
        function: String,
        line: Int
    ) {
        Logger.semaphore.wait()
        defer {
            Logger.semaphore.signal()
        }

        let _message: String = (message as? String) ?? String(describing: message)

        let formattedMessage = formatter(
            level: level,
            message: _message,
            instance: instance,
            file: file,
            function: function,
            line: line
        )

        dep.log(level: level, message: _message, formattedMessage: formattedMessage)

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
    func entered(_ instance: Any = "", message: String = "", function: String = #function, file: String = #file, line: Int = #line) {
        guard dep.isEnabled(.trace) else { return }

        self.log(level: .trace, message: message, instance: instance, file: file, function: function, line: line)
    }

    @inlinable
    func info(_ message: Any, instance: Any = "", function: String = #function, file: String = #file, line: Int = #line) {
        guard dep.isEnabled(.info) else { return }

        self.log(level: .info, message: message, instance: instance, file: file, function: function, line: line)
    }

    @inlinable
    func debug(_ message: Any, instance: Any = "", function: String = #function, file: String = #file, line: Int = #line) {
        guard dep.isEnabled(.debug) else { return }

        self.log(level: .debug, message: message, instance: instance, file: file, function: function, line: line)
    }

    @inlinable
    func notice(_ message: Any, instance: Any = "", function: String = #function, file: String = #file, line: Int = #line) {
        guard dep.isEnabled(.notice) else { return }

        self.log(level: .notice, message: message, instance: instance, file: file, function: function, line: line)
    }

    @inlinable
    func warning(_ message: Any, instance: Any = "", function: String = #function, file: String = #file, line: Int = #line) {
        guard dep.isEnabled(.warning) else { return }

        self.log(level: .warning, message: message, instance: instance, file: file, function: function, line: line)
    }

    @inlinable
    func error(_ message: Any, instance: Any = "", function: String = #function, file: String = #file, line: Int = #line) {
        guard dep.isEnabled(.error) else { return }

        self.log(level: .error, message: message, instance: instance, file: file, function: function, line: line)
    }

    @inlinable
    func fatal(_ message: Any, instance: Any = "", function: String = #function, file: String = #file, line: Int = #line) {
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
    func isEnabledThreadName(_ level: Logger.Level) -> Bool // Thread Information
    func isEnabledClassAndMethodName(_ level: Logger.Level) -> Logger.DescriptionType // Class/Function Information
    func isEnabledFileAndLineNumber(_ level: Logger.Level) -> Bool // File/Line Information
    func classInfoSepalator() -> String
    func postSepalator() -> String
}

// MARK: - protocol extension LoggerDependency

public extension LoggerDependency {
    func log(level: Logger.Level, message: String, formattedMessage: String) {
        print(formattedMessage)
    }

    func preFix(_ level: Logger.Level) -> String {
        switch level {
            case .trace: return "===>"
            case .debug: return "[🟡 DEBG]"
            case .info: return "[🔵 INFO]"
            case .notice: return "[🟢 NOTE]"
            case .warning: return "⚠️⚠️⚠️"
            case .error: return "❌❌❌"
            case .fatal: return "🔥🔥🔥"
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
            case .trace: return .none
            case .debug: return .detail
            case .info: return .detail
            case .notice: return .detail
            case .warning: return .detail
            case .error: return .detail
            case .fatal: return .detail
        }

        #else

        switch level {
            case .trace: return .none
            case .debug: return .full
            case .info: return .none
            case .notice: return .full
            case .warning: return .full
            case .error: return .full
            case .fatal: return .full
        }

        #endif
    }

    func isEnabledThreadName(_ level: Logger.Level) -> Bool {
        switch level {
            case .trace: return false
            case .info: return false
            default: return true
        }
    }

    func isEnabledClassAndMethodName(_ level: Logger.Level) -> Logger.DescriptionType {
        switch level {
            case .trace: return .normal
            case .info: return .none
            default: return .detail
        }
    }

    // true: Add file name and line number at the end of log
    func isEnabledFileAndLineNumber(_ level: Logger.Level) -> Bool {
        switch level {
            case .trace: return false
            case .info: return false
            default: return true
        }
    }

    func classInfoSepalator() -> String {
        " --"
    }

    func postSepalator() -> String {
        " --"
    }
}

#if LOGGER_iOS14_ENABLED
@available(iOS 14.0, *)
class SystemLogger: LoggerDependency {
    private var oslog: os.Logger
    init(subsystem: String, category: String) {
        oslog = os.Logger(subsystem: subsystem, category: category)
    }

    func preFix(_ level: Logger.Level) -> String {
        ""
    }

    func getTimeStampType(_ level: Logger.Level) -> Logger.TimeStampType {
        .none
    }

    func log(level: Logger.Level, message: String, formattedMessage: String) {
        switch level {
            case .trace:
                oslog.log("\(formattedMessage)")
            case .debug:
                oslog.debug("\(formattedMessage)")
            case .info:
                oslog.info("\(formattedMessage)")
            case .notice:
                oslog.notice("\(formattedMessage)")
            case .warning:
                oslog.warning("\(formattedMessage)")
            case .error:
                oslog.error("\(formattedMessage)")
            case .fatal:
                oslog.critical("\(formattedMessage)")
        }
    }
}
#endif

class OsLogger: LoggerDependency {
    func getTimeStampType(_ level: Logger.Level) -> Logger.TimeStampType {
        .none
    }

    func log(level: Logger.Level, message: String, formattedMessage: String) {
        // https://developer.apple.com/documentation/os/logging
        // https://developer.apple.com/documentation/os/os_log

        os_log("%s", formattedMessage)
    }
}

// Default Logger Dependency
public final class DefaultLoggerDependencies: LoggerDependency {
    public init() {}
}

// MARK: - Private extension

#if LOGGER_PRIVATE_EXTENSION_ENABLED

extension String {
    fileprivate var isNotEmpty: Bool {
        !self.isEmpty
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


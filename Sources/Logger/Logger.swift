//
//  Logger.swift
//  Logger
//
//  Created by k2moons on 2017/08/18.
//  Copyright (c) 2017 k2moons. All rights reserved.
//

import Foundation
import os

//internal let glog = Logger()

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

    public var isDisabled: Bool {
        set {
            if newValue {
                self.levels = []
            }
            else {
                self.levels = nil
            }
        }
        get {
            guard let levels = self.levels else { return false }

            return (levels.count == 0)
        }
    }

    public var assertWhenFatal: Bool = true

    public func isEnabled(_ level: Level) -> Bool {
        guard levels?.contains(level) ?? false || levels == nil else { return false }

        return true
    }

    public func log(_ context: LogContext) {
        Logger.semaphore.wait()
        defer {
            Logger.semaphore.signal()
        }

        let preFix = dep.preFix(context.level)
        var formattedMessage = ""

        guard dep.log(context) else {
            if context.level == .fatal, assertWhenFatal {
                formattedMessage = "\(preFix) [\(context.timestamp())] [\(context.threadName())]\(context.addSpacer(" ", to: context.message)) -- \(context.methodName()) \(context.lineInfo())"
                assert(false, formattedMessage)
            }
            return
        }

        switch context.level {
            case .trace:
                formattedMessage = "\(preFix) \(context.methodName())\(context.addSpacer(" -- ", to: context.message))"
            case .debug:
                formattedMessage = "\(preFix) [\(context.timestamp())] [\(context.threadName())]\(context.addSpacer(" ", to: context.message)) -- \(context.methodName()) \(context.lineInfo())"
            case .info:
                formattedMessage = "\(preFix) [\(context.timestamp())]\(context.addSpacer(" ", to: context.message)) -- \(context.lineInfo())"
            case .notice:
                formattedMessage = "\(preFix) [\(context.timestamp())]\(context.addSpacer(" ", to: context.message)) -- \(context.methodName()) \(context.lineInfo())"
            case .warning:
                formattedMessage = "\(preFix) [\(context.timestamp())] [\(context.threadName())]\(context.addSpacer(" ", to: context.message)) -- \(context.methodName()) \(context.lineInfo())"
            case .error:
                formattedMessage = "\(preFix) [\(context.timestamp())] [\(context.threadName())]\(context.addSpacer(" ", to: context.message)) -- \(context.methodName()) \(context.lineInfo())"
            case .fatal:
                formattedMessage = "\(preFix) [\(context.timestamp())] [\(context.threadName())]\(context.addSpacer(" ", to: context.message)) -- \(context.methodName()) \(context.lineInfo())"
            case .deinit:
                formattedMessage = "\(preFix) [\(context.timestamp())]\(context.addSpacer(" -- ", to: context.message)) -- \(context.lineInfo())"
        }
        dep.log(formattedMessage)

        if context.level == .fatal, assertWhenFatal {
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

        case `deinit`
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

public extension Logger {
    @inlinable
    func entered(_ instance: Any = "", message: String = "", function: String = #function, file: String = #file, line: Int = #line) {
        guard isEnabled(.trace) else { return }

        let context = LogContext(level: .trace, message: message, instance: instance, function: function, file: file, line: line)
        log(context)
    }

    @inlinable
    func info(_ message: Any, instance: Any = "", function: String = #function, file: String = #file, line: Int = #line) {
        guard isEnabled(.info) else { return }

        let context = LogContext(level: .info, message: message, instance: instance, function: function, file: file, line: line)
        log(context)
    }

    @inlinable
    func debug(_ message: Any, instance: Any = "", function: String = #function, file: String = #file, line: Int = #line) {
        guard isEnabled(.debug) else { return }

        let context = LogContext(level: .debug, message: message, instance: instance, function: function, file: file, line: line)
        log(context)
    }

    @inlinable
    func notice(_ message: Any, instance: Any = "", function: String = #function, file: String = #file, line: Int = #line) {
        guard isEnabled(.notice) else { return }

        let context = LogContext(level: .notice, message: message, instance: instance, function: function, file: file, line: line)
        log(context)
    }

    @inlinable
    func warning(_ message: Any, instance: Any = "", function: String = #function, file: String = #file, line: Int = #line) {
        guard isEnabled(.warning) else { return }

        let context = LogContext(level: .warning, message: message, instance: instance, function: function, file: file, line: line)
        log(context)
    }

    @inlinable
    func error(_ message: Any, instance: Any = "", function: String = #function, file: String = #file, line: Int = #line) {
        guard isEnabled(.error) else { return }

        let context = LogContext(level: .error, message: message, instance: instance, function: function, file: file, line: line)
        log(context)
    }

    @inlinable
    func fatal(_ message: Any, instance: Any = "", function: String = #function, file: String = #file, line: Int = #line) {
        guard isEnabled(.fatal) else { return }

        let context = LogContext(level: .fatal, message: message, instance: instance, function: function, file: file, line: line)
        log(context)
    }

    @inlinable
    func `deinit`(_ instance: Any = "", message: Any = "", function: String = #function, file: String = #file, line: Int = #line) {
        guard isEnabled(.deinit) else { return }

        let context = LogContext(level: .deinit, message: message, instance: instance, function: function, file: file, line: line)
        log(context)
    }
}

// MARK: - LogContext

public struct LogContext {
    public let level: Logger.Level
    public let message: String
    public let instance: Any
    public let function: String
    public let file: String
    public let line: Int

    public init(
        level: Logger.Level,
        message: Any,
        instance: Any,
        function: String,
        file: String,
        line: Int

    ) {
        self.level = level
        self.message = (message as? String) ?? String(describing: message)
        self.instance = instance
        self.function = function
        self.file = file
        self.line = line
    }

    public func timestamp(_ timestampType: Logger.TimeStampType = .full) -> String {
        Date().string(dateFormat: timestampType.style)
    }

    public func threadName() -> String {
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

    public func methodName(_ descriptionType: Logger.DescriptionType = .normal) -> String {
        guard descriptionType != .none else { return "" }

        var methodName: String = ""
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        let className = String(describing: instance)

        if className.isEmpty, let _fileName = fileName.components(separatedBy: ".").first {
            methodName = "\(_fileName):\(function)"
        }
        else {
            switch descriptionType {
                case .normal:
                    methodName = "\(String(describing: type(of: instance))):\(function)"
                case .detail:
                    methodName = "\(className):\(function)"
                case .none:
                    break // never
            }
        }

        return methodName
    }

    public func lineInfo() -> String {
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        return "\(fileName):\(line)"
    }

    public func addSpacer(_ spacer: String, to string: String) -> String {
        guard string.isNotEmpty else { return "" }

        return "\(spacer)\(string)"
    }
}

// MARK: - LoggerDependency

public protocol LoggerDependency {
    // if return false, Logger does not execute log(_ message: String)
    func log(_ context: LogContext) -> Bool

    // prefix is used `func log(_ message: String)`
    func preFix(_ level: Logger.Level) -> String

    func log(_ message: String)
}

// MARK: - protocol extension LoggerDependency

public extension LoggerDependency {
    // if return false, Logger does not execute log(_ message: String)
    func log(_ context: LogContext) -> Bool {
        true
    }

    func preFix(_ level: Logger.Level) -> String {
        switch level {
            case .trace: return "===>"
            case .debug: return "[🟠 DEBG]"
            case .info: return "[🔵 INFO]"
            case .notice: return "[🟢 NOTE]"
            case .warning: return "[⚠️ WARN]"
            case .error: return "[❌ ERRR]"
            case .fatal: return "[🔥 FATAL]"
            case .deinit: return "[❎ DEINIT]"
        }
    }

    func log(_ message: String) {
        print(message)
    }
}

#if LOGGER_iOS14_ENABLED
@available(iOS 14.0, *)
public class SystemLogger: LoggerDependency {
    private var oslog: os.Logger

    public init(subsystem: String, category: String) {
        oslog = os.Logger(subsystem: subsystem, category: category)
    }

    public func preFix(_ level: Logger.Level) -> String {
        ""
    }

    public func log(_ message: String) {
        switch level {
            case .trace:
                oslog.log("\(message)")
            case .debug:
                oslog.debug("\(message)")
            case .info:
                oslog.info("\(message)")
            case .notice:
                oslog.notice("\(message)")
            case .warning:
                oslog.warning("\(message)")
            case .error:
                oslog.error("\(message)")
            case .fatal:
                oslog.critical("\(message)")
            case .deinit:
                oslog.critical("\(message)")
        }
    }
}
#endif

// https://developer.apple.com/documentation/os/logging
// https://developer.apple.com/documentation/os/os_log
public class OsLogger: LoggerDependency {
    public init() {}

    public func log(_ context: LogContext) -> Bool {
        var formattedMessage = ""
        switch context.level {
            case .trace:
                formattedMessage = "\("➡️") \(context.methodName())\(context.addSpacer(" -- ", to: context.message))"
            case .debug:
                formattedMessage = "\("🟠") [\(context.threadName())]\(context.message) -- \(context.lineInfo())"
            case .info:
                formattedMessage = "\("🔵")\(context.addSpacer(" ", to: context.message)) -- \(context.lineInfo())"
            case .notice:
                formattedMessage = "\("🟢")\(context.addSpacer(" ", to: context.message)) -- \(context.lineInfo())"
            case .warning:
                formattedMessage = "\("⚠️") [\(context.threadName())]\(context.addSpacer(" ", to: context.message)) -- \(context.lineInfo())"
            case .error:
                formattedMessage = "\("❌") [\(context.threadName())]\(context.addSpacer(" ", to: context.message)) -- \(context.lineInfo())"
            case .fatal:
                formattedMessage = "\("🔥") [\(context.threadName())]\(context.addSpacer(" ", to: context.message)) -- \(context.lineInfo())"
            case .deinit:
                formattedMessage = "\("❎ DEINIT")\(context.addSpacer(" ", to: context.message)) -- \(context.lineInfo())"
        }

        os_log("%s", formattedMessage)

        // if return false, Logger does not execute log(_ message: String)
        return false
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


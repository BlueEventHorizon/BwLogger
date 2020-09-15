//
//  Logger.swift
//  BwTools
//
//  Created by k2moons on 2017/08/18.
//  Copyright (c) 2017 k2moons. All rights reserved.
//

import Foundation

internal let log = Logger()

// MARK: - LoggerDependency

public protocol LoggerDependency {
    func log(_ context: LogContext)
}

// MARK: - Logger

public final class Logger {
    public private(set) var dep: LoggerDependency = PrintLogger()

    public private(set) var levels: [Level]?

    private static let semaphore = DispatchSemaphore(value: 1)

    public static let `default` = Logger()

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

    // true: all log never output, false: all log output
    public var isDisabled: Bool {
        get {
            guard let levels = self.levels else { return false }

            return (levels.count == 0)
        }
        set {
            if newValue {
                self.levels = []
            }
            else {
                self.levels = nil
            }
        }
    }

    public func isEnabled(_ level: Level) -> Bool {
        guard levels?.contains(level) ?? false || levels == nil else { return false }

        return true
    }

    public func log(_ context: LogContext) {
        Logger.semaphore.wait()
        defer {
            Logger.semaphore.signal()
        }

        dep.log(context)
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

public extension Logger {
    @inlinable
    func entered(_ instance: Any = "", message: Any = "", function: StaticString = #function, file: StaticString = #file, line: Int = #line) {
        guard isEnabled(.trace) else { return }

        let context = LogContext(level: .trace, message: message, instance: instance, function: function, file: file, line: line)
        log(context)
    }

    @inlinable
    func info(_ message: Any, instance: Any = "", function: StaticString = #function, file: StaticString = #file, line: Int = #line) {
        guard isEnabled(.info) else { return }

        let context = LogContext(level: .info, message: message, instance: instance, function: function, file: file, line: line)
        log(context)
    }

    @inlinable
    func debug(_ message: Any, instance: Any = "", function: StaticString = #function, file: StaticString = #file, line: Int = #line) {
        guard isEnabled(.debug) else { return }

        let context = LogContext(level: .debug, message: message, instance: instance, function: function, file: file, line: line)
        log(context)
    }

    @inlinable
    func notice(_ message: Any, instance: Any = "", function: StaticString = #function, file: StaticString = #file, line: Int = #line) {
        guard isEnabled(.notice) else { return }

        let context = LogContext(level: .notice, message: message, instance: instance, function: function, file: file, line: line)
        log(context)
    }

    @inlinable
    func warning(_ message: Any, instance: Any = "", function: StaticString = #function, file: StaticString = #file, line: Int = #line) {
        guard isEnabled(.warning) else { return }

        let context = LogContext(level: .warning, message: message, instance: instance, function: function, file: file, line: line)
        log(context)
    }

    @inlinable
    func error(_ message: Any, instance: Any = "", function: StaticString = #function, file: StaticString = #file, line: Int = #line) {
        guard isEnabled(.error) else { return }

        let context = LogContext(level: .error, message: message, instance: instance, function: function, file: file, line: line)
        log(context)
    }

    @inlinable
    func fatal(_ message: Any, instance: Any = "", function: StaticString = #function, file: StaticString = #file, line: Int = #line) {
        guard isEnabled(.fatal) else { return }

        let context = LogContext(level: .fatal, message: message, instance: instance, function: function, file: file, line: line)
        log(context)
    }

    @inlinable
    func `deinit`(_ instance: Any = "", message: Any = "", function: StaticString = #function, file: StaticString = #file, line: Int = #line) {
        guard isEnabled(.deinit) else { return }

        let context = LogContext(level: .deinit, message: message, instance: instance, function: function, file: file, line: line)
        log(context)
    }
}

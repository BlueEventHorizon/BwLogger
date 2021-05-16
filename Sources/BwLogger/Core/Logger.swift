//
//  Logger.swift
//  BwTools
//
//  Created by k2moons on 2017/08/18.
//  Copyright (c) 2017 k2moons. All rights reserved.
//

import Foundation

// MARK: - LogOutput

public protocol LogOutput {
    func log(_ context: LogInformation)
}

// MARK: - Logger

open class Logger {
    public enum Level: String, Codable, CaseIterable {
        case log = "log"
        case debug = "debug"
        case info = "info"
        case warning = "warning"
        case error = "error"
        case fault = "fault"
    }

    public static let `default` = Logger(PrintLogger())

    /// ログのアウトプット先
    public private(set) var output: LogOutput

    /// 出力可能なログレベルを保持する。niであれば全てを出力する。
    // swiftlint:disable:next discouraged_optional_collection
    public private(set) var levels: [Level]?

    public init(_ output: LogOutput) {
        self.output = output
    }

    @discardableResult
    public func setLevel(_ levels: [Level]) -> Logger {
        self.levels = levels
        return self
    }

    /// ログ出力する
    /// - Parameter context: ログの情報を保持する構造体
    public func log(_ context: LogInformation) {
        output.log(context)
    }

    /// ログ出力可否を返す
    /// - Parameter level: ログレベル
    /// - Returns: ログ出力可否
    public func isEnabled(_ level: Level) -> Bool {
        guard let levels = levels else { return true }
        guard levels.contains(level) else { return false }

        return true
    }

    @inlinable
    public func log(_ message: Any, instance: Any? = nil, function: StaticString = #function, file: StaticString = #file, line: Int = #line) {
        guard isEnabled(.log) else { return }

        let context = LogInformation(level: .log, prefix: "", message: message, instance: instance, function: function, file: file, line: line)
        log(context)
    }

    @inlinable
    public func info(_ message: Any, instance: Any? = nil, function: StaticString = #function, file: StaticString = #file, line: Int = #line) {
        guard isEnabled(.info) else { return }

        let context = LogInformation(level: .info, prefix: "🔵", message: message, instance: instance, function: function, file: file, line: line)
        log(context)
    }

    @inlinable
    public func debug(_ message: Any, instance: Any? = nil, function: StaticString = #function, file: StaticString = #file, line: Int = #line) {
        guard isEnabled(.debug) else { return }

        let context = LogInformation(level: .debug, prefix: "🛠", message: message, instance: instance, function: function, file: file, line: line)
        log(context)
    }

    @inlinable
    public func warning(_ message: Any, instance: Any? = nil, function: StaticString = #function, file: StaticString = #file, line: Int = #line) {
        guard isEnabled(.warning) else { return }

        let context = LogInformation(level: .warning, prefix: "⚠️", message: message, instance: instance, function: function, file: file, line: line)
        log(context)
    }

    @inlinable
    public func error(_ message: Any, instance: Any? = nil, function: StaticString = #function, file: StaticString = #file, line: Int = #line) {
        guard isEnabled(.error) else { return }

        let context = LogInformation(level: .error, prefix: "🚫", message: message, instance: instance, function: function, file: file, line: line)
        log(context)
    }

    @inlinable
    public func fault(_ message: Any, instance: Any? = nil, function: StaticString = #function, file: StaticString = #file, line: Int = #line) {
        guard isEnabled(.fault) else { return }

        let context = LogInformation(level: .fault, prefix: "🔥", message: message, instance: instance, function: function, file: file, line: line)
        log(context)
    }
}

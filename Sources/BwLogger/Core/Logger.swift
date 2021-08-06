//
//  Logger.swift
//  BwTools
//
//  Created by k2moons on 2017/08/18.
//  Copyright (c) 2017 k2moons. All rights reserved.
//

import Foundation

open class Logger {
    public enum Level: String, Codable, CaseIterable {
        case log
        case debug
        case info
        case warning
        case error
        case fault
    }

    public static let `default` = Logger(ConsoleLogger())

    /// ログのアウトプット先
    public private(set) var output: LogOutput

    /// 出力可能なログレベルを保持する。niであれば全てを出力する。
    // swiftlint:disable:next discouraged_optional_collection
    public private(set) var levels: [Level]?

    #if DEBUG
    public static let defaultLevels: [Level]? = nil
    #else
    public static let defaultLevels: [Level]? = []
    #endif
    
    public init(_ output: LogOutput, levels: [Level]? = Logger.defaultLevels) {
        self.output = output
        self.levels = levels
    }
    
    /// ログレベルを変更する
    /// - Parameter levels: ログレベル
    /// - Returns: Loggerインスタンス
    /// - Usage: Logger.default.setLevel([.warning, .error, .fault])
    public func setLevel(_ levels: [Level]?) -> Self {
        self.levels = levels
        
        return self
    }

    /// ログ出力する
    /// - Parameter information: ログの情報を保持する構造体
    public func log(_ information: LogInformation) {
        output.log(information)
    }

    /// ログ出力可否を返す
    /// - Parameter level: ログレベル
    /// - Returns: ログ出力可否
    public func isEnabled(_ level: Level) -> Bool {
        // 設定なしで全てを出力
        guard let levels = levels else { return true }

        // 設定に含まれていないと出力しない
        guard levels.contains(level) else { return false }

        return true
    }

    @inlinable
    public func log(_ message: Any, instance: Any? = nil, function: StaticString = #function, file: StaticString = #file, line: Int = #line) {
        guard isEnabled(.log) else { return }

        log(LogInformation(level: .log, message: message, function: function, file: file, line: line, instance: instance))
    }

    @inlinable
    public func info(_ message: Any, instance: Any? = nil, function: StaticString = #function, file: StaticString = #file, line: Int = #line) {
        guard isEnabled(.info) else { return }

        log(LogInformation(level: .info, message: message, function: function, file: file, line: line, instance: instance))
    }

    @inlinable
    public func debug(_ message: Any, instance: Any? = nil, function: StaticString = #function, file: StaticString = #file, line: Int = #line) {
        guard isEnabled(.debug) else { return }

        log(LogInformation(level: .debug, message: message, function: function, file: file, line: line, instance: instance))
    }

    @inlinable
    public func warning(_ message: Any, instance: Any? = nil, function: StaticString = #function, file: StaticString = #file, line: Int = #line) {
        guard isEnabled(.warning) else { return }

        log(LogInformation(level: .warning, message: message, function: function, file: file, line: line, instance: instance))
    }

    @inlinable
    public func error(_ message: Any, instance: Any? = nil, function: StaticString = #function, file: StaticString = #file, line: Int = #line) {
        guard isEnabled(.error) else { return }

        log(LogInformation(level: .error, message: message, function: function, file: file, line: line, instance: instance))
    }

    @inlinable
    public func fault(_ message: Any, instance: Any? = nil, function: StaticString = #function, file: StaticString = #file, line: Int = #line) {
        guard isEnabled(.fault) else { return }

        log(LogInformation(level: .fault, message: message, function: function, file: file, line: line, instance: instance))
    }
}

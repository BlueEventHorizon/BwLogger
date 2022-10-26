//
//  Logger.swift
//  BwLogger
//
//  Created by k2moons on 2017/08/18.
//  Copyright (c) 2017 k2moons. All rights reserved.
//

import Foundation

public final class Logger {
    public enum Level: String, Codable, CaseIterable {
        case log
        case debug
        case info
        case warning
        case error
        case fault
    }

    public static let `default` = Logger([OSLogger(subsystem: "com.beowulf-tech", category: "Logger")])

    private static let semaphore = DispatchSemaphore(value: 1)

    #if DEBUG
        public static let defaultLevels: [Level]? = [.log, .fault, .error, .warning, .debug, .info] // nil
    #else
        public static let defaultLevels: [Level]? = [.fault, .error]
    #endif

    // ------------------------------------------------------------------------------------------
    // MARK: - public private(set)
    // ------------------------------------------------------------------------------------------

    /// ログのアウトプット先
    public private(set) var outputs: [LogOutput]

    /// 出力可能なログレベルを保持する。niであれば全てを出力する。
    public private(set) var levels: [Level]?

    // ------------------------------------------------------------------------------------------
    // MARK: - Lifecycle
    // ------------------------------------------------------------------------------------------

    public init(_ outputs: [LogOutput], levels: [Level]? = Logger.defaultLevels) {
        self.outputs = outputs
        self.levels = levels
    }

    // ------------------------------------------------------------------------------------------
    // MARK: - Configuration
    // ------------------------------------------------------------------------------------------

    @discardableResult
    public func setLogOutput(_ outputs: [LogOutput]) -> Self {
        Logger.semaphore.wait()
        defer {
            Logger.semaphore.signal()
        }

        self.outputs = outputs

        return self
    }

    @discardableResult
    public func appendLogOutput(_ output: LogOutput) -> Self {
        Logger.semaphore.wait()
        defer {
            Logger.semaphore.signal()
        }

        outputs.append(output)

        return self
    }

    /// ログレベルを変更する
    /// - Parameter levels: ログレベル
    /// - Returns: Loggerインスタンス
    /// - Usage: Logger.default.setLevel([.warning, .error, .fault])
    @discardableResult
    public func setLevel(_ levels: [Level]?) -> Self {
        Logger.semaphore.wait()
        defer {
            Logger.semaphore.signal()
        }

        self.levels = levels

        return self
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

    // ------------------------------------------------------------------------------------------
    // MARK: - public func
    // ------------------------------------------------------------------------------------------

    /// ログ出力する
    /// - Parameter information: ログの情報を保持する構造体
    func log(with information: LogInformation) {
        Logger.semaphore.wait()
        defer {
            Logger.semaphore.signal()
        }

        for output in outputs {
            output.log(information)
        }
    }

    // ------------------------------------------------------------------------------------------
    // Loggerの呼び出し関数
    // messageにはStringだけでなく、CustomStringConvertible / TextOutputStreamable / CustomDebugStringConvertible等を渡すこともできます
    // instanceを渡すことで、正確なオブジェクト名が得られます。
    // ------------------------------------------------------------------------------------------

    /// 汎用
    public func log(_ message: Any, instance: Any? = nil, function: StaticString = #function, file: StaticString = #fileID, line: Int = #line) {
        guard isEnabled(.log) else { return }

        log(with: LogInformation(level: .log, message: message, function: function, file: file, line: line, instance: instance))
    }

    /// 情報表示
    public func info(_ message: Any, instance: Any? = nil, function: StaticString = #function, file: StaticString = #fileID, line: Int = #line) {
        guard isEnabled(.info) else { return }

        log(with: LogInformation(level: .info, message: message, function: function, file: file, line: line, instance: instance))
    }

    /// デバッグ情報
    public func debug(_ message: Any, instance: Any? = nil, function: StaticString = #function, file: StaticString = #fileID, line: Int = #line) {
        guard isEnabled(.debug) else { return }

        log(with: LogInformation(level: .debug, message: message, function: function, file: file, line: line, instance: instance))
    }

    /// 警告
    public func warning(_ message: Any, instance: Any? = nil, function: StaticString = #function, file: StaticString = #fileID, line: Int = #line) {
        guard isEnabled(.warning) else { return }

        log(with: LogInformation(level: .warning, message: message, function: function, file: file, line: line, instance: instance))
    }

    /// エラー
    public func error(_ message: Any, instance: Any? = nil, function: StaticString = #function, file: StaticString = #fileID, line: Int = #line) {
        guard isEnabled(.error) else { return }

        log(with: LogInformation(level: .error, message: message, function: function, file: file, line: line, instance: instance))
    }

    /// 致命的なエラー
    public func fault(_ message: Any, instance: Any? = nil, function: StaticString = #function, file: StaticString = #fileID, line: Int = #line) {
        guard isEnabled(.fault) else { return }

        log(with: LogInformation(level: .fault, message: message, function: function, file: file, line: line, instance: instance))

        assertionFailure("\(message)")
    }
}

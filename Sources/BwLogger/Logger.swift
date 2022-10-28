//
//  Logger.swift
//  BwLog
//
//  Created by k2moons on 2022/10/28.
//  Copyright (c) 2022 k2moons. All rights reserved.
//

import Foundation

// ------------------------------------------------------------------------------------------
// MARK: - LoggerProtocol
// ------------------------------------------------------------------------------------------

public protocol LoggerProtocol {
    func log(_ log: LogInformation)
}

// ------------------------------------------------------------------------------------------
// MARK: - BwLogger
// ------------------------------------------------------------------------------------------

public class Logger: LoggerProtocol {
    public enum Level: String, Codable, CaseIterable {
        case log
        case debug
        case info
        case warning
        case error
        case fault
    }
    
    // MARK: - Property

    private static let semaphore = DispatchSemaphore(value: 1)
    
    /// ログのアウトプット先
    public private(set) var outputs: [LogOutput] = []

    ///  ログの出力制御 （初期値：出力しない）
    public private(set) var levels: [Level]? = []

    // MARK: - Private Function

    func isEnabled(_ level: Level) -> Bool {
        // levels == nil : 全てを出力
        guard let levels = levels else { return true }

        // levels に含まれていれば出力する
        guard levels.contains(level) else { return false }

        return true
    }

    // MARK: - Public Function

    public init(_ outputs: [LogOutput], levels: [Level]? = nil) {
        self.outputs = outputs
        self.levels = levels
    }

    /// ログのアウトプット先設定
    @discardableResult
    public func setOutput(_ outputs: [LogOutput]) -> Self {
        Logger.semaphore.wait()
        defer { Logger.semaphore.signal() }

        self.outputs = outputs
        return self
    }

    /// 出力レベルの設定
    /// - Parameter levels: 出力するログレベルの配列
    /// - Returns: 自インスタンス
    @discardableResult
    public func setLevel(_ levels: [Level]?) -> Self {
        Logger.semaphore.wait()
        defer { Logger.semaphore.signal() }

        self.levels = levels

        return self
    }

    public func log(_ log: LogInformation) {
        guard isEnabled(log.level) else { return }

        outputs.forEach { output in
            output.log(log)
        }
    }

    @discardableResult
    public func setLogOutput(_ outputs: [LogOutput]) -> Self {
        setOutput(outputs)
    }
}

// ------------------------------------------------------------------------------------------
// MARK: - LogInformation
// ------------------------------------------------------------------------------------------

/// Logの基本情報を保持する構造体
public struct LogInformation: Codable {
    public let level: Logger.Level
    public let message: String
    public let date: Date
    public let objectName: String
    public let function: String
    public let file: String
    public let line: Int
    public let prefix: String?

    /// 初期化
    /// - Parameters:
    ///   - message: ログ内容（String以外にも、CustomStringConvertible / TextOutputStreamable / CustomDebugStringConvertibleも可）
    ///   - level: ログレベル
    ///   - function: 関数名（自動で付加）
    ///   - file: ファイル名（自動で付加）
    ///   - line: ファイル行（自動で付加）
    ///   - prefix: 先頭に追加する文字列（初期値は無し）
    ///   - instance: インスタンスを渡すと、ログに「クラス名:関数名」を出力
    public init(_ message: Any, level: Logger.Level = .log, function: StaticString = #function, file: StaticString = #fileID, line: Int = #line, prefix: String? = nil, instance: Any? = nil) {
        self.level = level
        self.prefix = prefix

        // メッセージのdescriptionを取り出す（よってCustomStringConvertible / TextOutputStreamable / CustomDebugStringConvertibleを持つclassであれば何でも良いことになる）
        self.message = (message as? String) ?? String(describing: message)
        date = Date()

        self.function = "\(function)"
        self.file = "\(file)"
        self.line = line

        if let instance = instance {
            objectName = "\(String(describing: type(of: instance))):\(function)"
        } else {
            objectName = "\(function)"
        }
    }

    /// タイムスタンプを生成
    public func timestamp(_ format: String = "yyyy/MM/dd HH:mm:ss.SSS z") -> String {
        DateFormatter.fixedFormatter(dateFormat: format, timeZone: .current).string(from: date)
    }

    /// スレッド名を取得する
    public var threadName: String {
        if Thread.isMainThread {
            return "main"
        }
        if let threadName = Thread.current.name, threadName.isNotEmpty {
            return threadName
        }
        if let threadName = String(validatingUTF8: __dispatch_queue_get_label(nil)), threadName.isNotEmpty {
            return threadName
        }
        return Thread.current.description
    }

    /// ファイル名を取得する
    public var fileName: String {
        URL(fileURLWithPath: "\(file)").lastPathComponent
    }
}

// ------------------------------------------------------------------------------------------
// MARK: - LogOutput
// ------------------------------------------------------------------------------------------

public protocol LogOutput {
    func log(_ information: LogInformation)
}

// ------------------------------------------------------------------------------------------
// MARK: - extension BwLogger
// ------------------------------------------------------------------------------------------

extension Logger {
    /// 汎用
    public func log(_ message: Any, instance: Any? = nil, function: StaticString = #function, file: StaticString = #fileID, line: Int = #line) {
        log(LogInformation(message, level: .log, function: function, file: file, line: line, instance: instance))
    }

    /// 情報表示
    public func info(_ message: Any, instance: Any? = nil, function: StaticString = #function, file: StaticString = #fileID, line: Int = #line) {
        log(LogInformation(message, level: .info, function: function, file: file, line: line, instance: instance))
    }

    /// デバッグ情報
    public func debug(_ message: Any, instance: Any? = nil, function: StaticString = #function, file: StaticString = #fileID, line: Int = #line) {
        log(LogInformation(message, level: .debug, function: function, file: file, line: line, instance: instance))
    }

    /// 警告
    public func warning(_ message: Any, instance: Any? = nil, function: StaticString = #function, file: StaticString = #fileID, line: Int = #line) {
        log(LogInformation(message, level: .warning, function: function, file: file, line: line, instance: instance))
    }

    /// エラー
    public func error(_ message: Any, instance: Any? = nil, function: StaticString = #function, file: StaticString = #fileID, line: Int = #line) {
        log(LogInformation(message, level: .error, function: function, file: file, line: line, instance: instance))
    }

    /// 致命的なエラー
    public func fault(_ message: Any, instance: Any? = nil, function: StaticString = #function, file: StaticString = #fileID, line: Int = #line) {
        log(LogInformation(message, level: .fault, function: function, file: file, line: line, instance: instance))
    }
}

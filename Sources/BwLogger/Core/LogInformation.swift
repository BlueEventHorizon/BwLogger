//
//  LogContext.swift
//  BwTools
//
//  Created by k_terada on 2020/09/15.
//  Copyright © 2020 k2moons. All rights reserved.
//

import Foundation

/// Logの基本情報を保持する構造体
public struct LogInformation {
    public let level: Logger.Level
    public let prefix: String

    public let message: String
    public let instance: Any?
    public let date: Date

    public let function: StaticString
    public let file: StaticString
    public let line: Int

    /// 初期化
    /// - Parameters:
    ///   - level: ログレベル
    ///   - prefix: 先頭のアイコン等
    ///   - message: メッセージ。オブジェクトでも構わない
    ///   - instance: 呼び出しているインスタンスを渡すと、ログに「クラス名:関数名」を出力する。
    ///   - function: 関数名
    ///   - file: ファイル名
    ///   - line: ファイル内の行数
    public init(level: Logger.Level, prefix: String, message: Any, instance: Any? = nil, function: StaticString, file: StaticString, line: Int) {
        self.level = level
        self.prefix = prefix

        // メッセージのdescriptionを取り出す（よってCustomStringConvertible/TextOutputStreamable/CustomDebugStringConvertibleを持つclassであれば何でも良いことになる）
        self.message = (message as? String) ?? String(describing: message)
        self.instance = instance
        self.date = Date()

        self.function = function
        self.file = file
        self.line = line
    }

    // タイムスタンプを生成
    public func timestamp(_ format: String = "yyyy/MM/dd HH:mm:ss.SSS z") -> String {
        self.date.string(dateFormat: format)
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

    /// 関数名を返す。
    /// instanceがインスタンス・オブジェクトの場合は、class名を取得する。
    public var methodName: String {
        guard let instance = self.instance else {
            return "\(function)"
        }

        // instanceがインスタンス・オブジェクトの場合は、class名を取得する。
        let result = "\(String(describing: type(of: instance))):\(function)"
        return result
    }

    public func addSpacer(_ spacer: String, to string: String) -> String {
        guard string.isNotEmpty else { return "" }

        return "\(spacer)\(string)"
    }
}

// MARK: - Private extension

#if LOGGER_PRIVATE_EXTENSION_ENABLED

    // swiftlint:disable strict_fileprivate

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
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.calendar = Calendar(identifier: .gregorian)
            return formatter
        }()
    }

    // swiftlint:enable strict_fileprivate

#endif

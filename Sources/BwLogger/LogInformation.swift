//
//  LogInformation.swift
//  BwLogger
//
//  Created by k2moons on 2020/09/15.
//  Copyright © 2020 k2moons. All rights reserved.
//

import Foundation

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
    ///   - level: ログレベル
    ///   - message: メッセージ。String以外にも、CustomStringConvertible / TextOutputStreamable / CustomDebugStringConvertibleも可
    ///   - function: 関数名
    ///   - file: ファイル名
    ///   - line: ファイル内の行数
    ///   - prefix: 先頭のアイコン等
    ///   - instance: 呼び出しているインスタンスを渡すと、ログに「クラス名:関数名」を出力する。
    public init(level: Logger.Level, message: Any, function: StaticString, file: StaticString, line: Int, prefix: String? = nil, instance: Any? = nil) {
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

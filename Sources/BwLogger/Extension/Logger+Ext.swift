//
//  Logger+Ext.swift
//  Logger
//
//  Created by k2moons on 2019/10/18.
//  Copyright © 2019 k2moons. All rights reserved.
//

import UIKit

extension Logger {
    // MARK: - 文字列への変換

    /// JSONによるレスポンスなどを文字列に変換して返却します。
    /// - Parameter jsonData: JSONデータ
    /// - Returns: JSON文字列
    public static func decodeJsonData(_ jsonData: Data?) -> String {
        if let jsonData = jsonData,
           let jsonObject = try? JSONSerialization.jsonObject(with: jsonData),
           let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: []),
           let result = String(data: data, encoding: .utf8) {
            return result
        }
        return ""
    }

    public static func point2String(_ point: CGPoint, format: String = "%.2f") -> String {
        return "x=" + String(format: format, point.x) + ", y=" + String(format: format, point.y)
    }

    public static func frame2String(_ frame: CGRect, format: String = "%.2f") -> String {
        return
            """
            x= \(String(format: format, frame.origin.x)),
            y= \(String(format: format, frame.origin.y)),
            w= \(String(format: format, frame.size.width)),
            h= \(String(format: format, frame.size.height))
            """
    }

    public static func url2String(_ url: URL) -> String {
        var result: String = "url : \(url.absoluteString)"

        if let scheme = url.scheme {
            result.append(", scheme : \(scheme)")
        }

        if let host = url.host {
            result.append(", host : \(host)")
        }

        if let port = url.port {
            result.append(", port : \(port)")
        }

        if let query = url.query {
            result.append(", query : \(query)")
        }

        return result
    }
}

// MARK: - Logger 追加エントリー

/// Loggerを拡張する構造体
public struct LogExtraInformation: CustomStringConvertible {
    let function: StaticString
    let message: Any?
    let prefix: String?

    public init(function: StaticString = #function, message: Any? = nil, prefix: String? = nil) {
        self.function = function
        self.message = message
        self.prefix = prefix
    }

    public var description: String {
        "\(prefix ?? "") \((message ?? "") as? String ?? "")"
    }
}

extension Logger {
    @inlinable
    public func entered(_ instance: Any? = nil, message: Any = "", function: StaticString = #function, file: StaticString = #file, line: Int = #line) {
        guard isEnabled(.log) else { return }

        // LogExtraInformationをmessageとして与えることで、descriptionを呼び出させ、これをログ出力する。
        // let extra = LogExtraInformation(prefix: "", message: message)

        log(LogInformation(level: .log, message: message, function: function, file: file, line: line, prefix: "➡️", instance: instance))
    }

    @inlinable
    public func `deinit`(_ instance: Any? = nil, message: Any = "", function: StaticString = #function, file: StaticString = #file, line: Int = #line) {
        guard isEnabled(.log) else { return }

        log(LogInformation(level: .log, message: message, function: function, file: file, line: line, prefix: "❎", instance: instance))
    }
}

//
//  Logger+Ext.swift
//  Logger
//
//  Created by k2moons on 2019/10/18.
//  Copyright © 2019 k2moons. All rights reserved.
//

import UIKit

public extension Logger {
    
// MARK: - 文字列への変換

    /// JSONによるレスポンスなどを文字列に変換して返却します。
    /// - Parameter jsonData: JSONデータ
    /// - Returns: JSON文字列
     static func decodeJsonData(_ jsonData: Data?) -> String {
        if let jsonData = jsonData,
           let jsonObject = try? JSONSerialization.jsonObject(with: jsonData),
           let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: []),
           let result = String(data: data, encoding: .utf8) {
            return result
        }
        return ""
    }

    static func point2String(_ point: CGPoint, format: String = "%.2f") -> String {
        return "x=" + String(format: format, point.x) + ", y=" + String(format: format, point.y)
    }

    static func frame2String(_ frame: CGRect, format: String = "%.2f") -> String {
        return "x= \(String(format: format, frame.origin.x)), y= \(String(format: format, frame.origin.y)), w= \(String(format: format, frame.size.width)), h= \(String(format: format, frame.size.height))"
    }

    static func url2String(_ url: URL) -> String {
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
    let prefix: String?
    let message: Any?

    public init(prefix: String? = nil, message: Any? = nil) {
        self.prefix = prefix
        self.message = message
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

        log(LogInformation(level: .log, prefix: "➡️", message: message, instance: instance, function: function, file: file, line: line))
    }

    @inlinable
    public func `deinit`(_ instance: Any? = nil, message: Any = "", function: StaticString = #function, file: StaticString = #file, line: Int = #line) {
        guard isEnabled(.log) else { return }

        log(LogInformation(level: .log, prefix: "❎", message: message, instance: instance, function: function, file: file, line: line))
    }
}

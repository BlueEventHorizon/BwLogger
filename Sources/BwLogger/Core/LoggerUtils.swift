//
//  File.swift
//  
//
//  Created by Katsuhiko Terada on 2021/05/19.
//

import Foundation

extension Logger {

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
}

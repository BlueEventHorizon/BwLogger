//
//  Logger+Extra.swift
//  BwTools
//
//  Created by k_terada on 2020/09/24.
//  Copyright © 2020 beowulf-tech. All rights reserved.
//

import Foundation

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

// MARK: - Logger extension

extension Logger {
    @inlinable
    public func entered(_ instance: Any = "", message: Any = "", function: StaticString = #function, file: StaticString = #file, line: Int = #line) {
        guard isEnabled(.log) else { return }

        // LoggerExtraContextをmessageとして与えることで、descriptionを呼び出させ、これをログ出力する。
        // let extra = LoggerExtraContext(prefix: "", message: message)

        let context = LogInformation(level: .log, prefix: "➡️", message: message, instance: instance, function: function, file: file, line: line)
        log(context)
    }

    @inlinable
    public func `deinit`(_ instance: Any = "", message: Any = "", function: StaticString = #function, file: StaticString = #file, line: Int = #line) {
        guard isEnabled(.log) else { return }

        let context = LogInformation(level: .log, prefix: "❎", message: message, instance: instance, function: function, file: file, line: line)
        log(context)
    }
}

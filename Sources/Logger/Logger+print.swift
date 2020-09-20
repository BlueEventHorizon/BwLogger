//
//  Logger+print.swift
//  BwTools
//
//  Created by k_terada on 2020/09/15.
//  Copyright © 2020 k2moons. All rights reserved.
//

import Foundation

public class PrintLogger: LoggerDependency {
    public func log(_ context: LogContext) {
        var preFix: String = ""

        switch context.level {
            case .trace: preFix = "➡️"
            case .debug: preFix = "[🛠 DEBG]"
            case .info: preFix = "[🔵 INFO]"
            case .notice: preFix = "[🟢 NOTE]"
            case .warning: preFix = "[⚠️ WARN]"
            case .error: preFix = "[🚫 ERRR]"
            case .fatal: preFix = "[🔥 FATAL]"
            case .deinit: preFix = "[❎ DEINIT]"
        }

        let formatted = preFix + context.buildMessage()
        print(formatted)
    }
}

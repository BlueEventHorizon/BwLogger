//
//  Logger+os_log.swift
//  BwTools
//
//  Created by k_terada on 2020/09/15.
//  Copyright © 2020 k2moons. All rights reserved.
//

import Foundation
import os

// https://developer.apple.com/documentation/os/logging
// https://developer.apple.com/documentation/os/os_log
public class OsLogger: LoggerDependency {
    public init() {}

    public func log(_ context: LogContext) {
        var formattedMessage = ""
        switch context.level {
            case .trace:
                formattedMessage = "\("➡️") \(context.methodName())\(context.addSpacer(" -- ", to: context.message))"
            case .debug:
                formattedMessage = "\("🟠") [\(context.threadName())]\(context.message) -- \(context.lineInfo())"
            case .info:
                formattedMessage = "\("🔵")\(context.addSpacer(" ", to: context.message)) -- \(context.lineInfo())"
            case .notice:
                formattedMessage = "\("🟢")\(context.addSpacer(" ", to: context.message)) -- \(context.lineInfo())"
            case .warning:
                formattedMessage = "\("⚠️") [\(context.threadName())]\(context.addSpacer(" ", to: context.message)) -- \(context.lineInfo())"
            case .error:
                formattedMessage = "\("🚫") [\(context.threadName())]\(context.addSpacer(" ", to: context.message)) -- \(context.lineInfo())"
            case .fatal:
                formattedMessage = "\("🔥") [\(context.threadName())]\(context.addSpacer(" ", to: context.message)) -- \(context.lineInfo())"
            case .deinit:
                formattedMessage = "\("❎ DEINIT")\(context.addSpacer(" ", to: context.message)) -- \(context.lineInfo())"
        }

        os_log("%s", formattedMessage)
    }
}

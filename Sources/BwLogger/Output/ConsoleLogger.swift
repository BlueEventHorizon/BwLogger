//
//  Logger+print.swift
//  BwTools
//
//  Created by k_terada on 2020/09/15.
//  Copyright © 2020 k2moons. All rights reserved.
//

import Foundation

public typealias PrintLogger = ConsoleLogger

public class ConsoleLogger: LogOutput {
    private static let semaphore = DispatchSemaphore(value: 1)

    public init() {}

    public func log(_ information: LogInformation) {
        ConsoleLogger.semaphore.wait()
        defer {
            ConsoleLogger.semaphore.signal()
        }

        let message = getStandardMessage(with: information)

        print(message)
    }
}

extension ConsoleLogger {
    public func prefix(for level: Logger.Level) -> String {
        switch level {
            case .log: return ""
            case .debug: return "🛠"
            case .info: return "🔵"
            case .warning: return "⚠️"
            case .error: return "🚫"
            case .fault: return "🔥"
        }
    }

    public func getStandardMessage(with information: LogInformation) -> String {
        let separator: String = information.message.isEmpty ? "" : " --"

        return information.level == .info ?
            "\(prefix(for: information.level))\(addSpacer(" ", before: information.message))\(separator) \(information.methodName)" :
            "\(prefix(for: information.level)) [\(information.timestamp())] [\(information.threadName)]\(addSpacer(" ", before: information.message))\(separator) \(information.methodName) \(information.fileName):\(information.line))"
    }
}

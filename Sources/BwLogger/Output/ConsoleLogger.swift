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
    public init() {}

    public func log(_ information: LogInformation) {
        let message = generateMessage(with: information)

        print(message)
    }
}

extension ConsoleLogger {
    // swiftlint:disable switch_case_on_newline
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
    // swiftlint:enable switch_case_on_newline
}

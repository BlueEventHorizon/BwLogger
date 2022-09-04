//
//  ExampleLogger.swift
//  BwCore
//
//  Created by k2moons on 2020/09/15.
//  Copyright © 2020 k2moons. All rights reserved.
//

import Foundation

public class ExampleLogger: LogOutput {
    public init() {}

    public func generateMessage(with info: LogInformation) -> String {
        let prefix = prefix(with: info)

        return info.level == .info ?
            "\(prefix)\(addSeparater(info.message)) [\(info.objectName)]" :
            "\(prefix)\(addSeparater(info.message)) [\(info.threadName)] [\(info.objectName)] \(info.fileName): \(info.line))"
    }
}

public extension ExampleLogger {
    func log(_ information: LogInformation) {
        let message = generateMessage(with: information)

        if information.level == .fault {
            assertionFailure(message)
        } else {
            print(message)
        }
    }
    
    func prefix(with info: LogInformation) -> String {
        if let prefix = info.prefix {
            return prefix
        }

        return "🔹 \(info.level.rawValue)"
    }
}

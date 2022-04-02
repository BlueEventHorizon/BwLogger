//
//  ConsoleLogger.swift
//  BwCore
//
//  Created by k2moons on 2020/09/15.
//  Copyright © 2020 k2moons. All rights reserved.
//

import Foundation

public typealias PrintLogger = ConsoleLogger

public class ConsoleLogger {
    public init() {}
}

extension ConsoleLogger: LogOutput {
    public func log(_ information: LogInformation) {
        let message = generateMessage(with: information)

        if information.level == .fault {
            assertionFailure(message)
        } else {
            print(message)
        }
    }
}

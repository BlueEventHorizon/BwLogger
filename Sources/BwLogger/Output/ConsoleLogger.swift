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

    
}

//
//  Logger+print.swift
//  BwTools
//
//  Created by k_terada on 2020/09/15.
//  Copyright © 2020 k2moons. All rights reserved.
//

import Foundation

public class PrintLogger: LogOutput {
    private static let semaphore = DispatchSemaphore(value: 1)

    public init() {}

    public func log(_ information: LogInformation) {
        PrintLogger.semaphore.wait()
        defer {
            PrintLogger.semaphore.signal()
        }

        let separator: String = information.message.isEmpty ? "" : " --"
        
        let message = information.level == .info ?
            "\(information.prefix)\(addSpacer(" ", before: information.message))\(separator) \(information.methodName)" :
            "\(information.prefix) [\(information.timestamp())] [\(information.threadName)]\(addSpacer(" ", before: information.message))\(separator) \(information.methodName) \(information.fileName):\(information.line))"

        print(message)
    }
}

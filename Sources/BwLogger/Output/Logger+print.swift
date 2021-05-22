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

    public func log(_ context: LogInformation) {
        PrintLogger.semaphore.wait()
        defer {
            PrintLogger.semaphore.signal()
        }

        let separator: String = context.message.isEmpty ? "" : " --"
        
        let message = context.level == .info ?
            "\(context.prefix)\(context.addSpacer(" ", to: context.message))\(separator) \(context.methodName)" :
            "\(context.prefix) [\(context.timestamp())] [\(context.threadName)]\(context.addSpacer(" ", to: context.message))\(separator) \(context.methodName) \(context.fileName):\(context.line))"

        print(message)
    }
}

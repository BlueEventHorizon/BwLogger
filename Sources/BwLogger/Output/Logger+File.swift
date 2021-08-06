//
//  FileLogger.swift
//  BwTools
//
//  Created by k_terada on 2020/07/16.
//  Copyright © 2020 k2moons. All rights reserved.
//

import BwLogger
import Foundation

public protocol FileLoggerDependency {
     func open()
     func close()
     func write(_ text: String)
}

public final class FileLogger: LogOutput {

    let dependency: FileLoggerDependency

    public init(dependency: FileLoggerDependency) {
        self.dependency = dependency
    }

    public func log(_ context: LogInformation) {
        let separator: String = context.message.isEmpty ? "" : " --"
        
        let message = context.level == .info ?
            "\(context.prefix)\(addSpacer(" ", before: context.message))\(separator) \(context.methodName)" :
            "\(context.prefix) [\(context.timestamp())] [\(context.threadName)]\(addSpacer(" ", before: context.message))\(separator) \(context.methodName) \(context.fileName):\(context.line))"

        dependency.open()
        dependency.write(message)
        dependency.close()
    }
}

//
//  FileLoggerDependency.swift
//  BwTools
//
//  Created by k_terada on 2020/07/16.
//  Copyright © 2020 k2moons. All rights reserved.
//

import Foundation

public final class FileLogger: LogOutput {
    let writer: TextFileWriter

    public init() {
        writer = TextFileWriter(name: "log.txt")
    }

    public func log(_ context: LogInformation) {
        let message = context.level == .info ?
            "\(context.prefix)\(context.addSpacer(" ", to: context.message)) -- \(context.fileName):\(context.line)" :
            "\(context.prefix) [\(context.timestamp())] [\(context.threadName)]\(context.addSpacer(" ", to: context.message)) -- \(context.methodName) \(context.fileName):\(context.line))"

        print(message)
        writer.open()
        writer.write(message)
        writer.close()
    }
}

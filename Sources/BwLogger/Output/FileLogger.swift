//
//  FileLogger.swift
//  BwTools
//
//  Created by k_terada on 2020/07/16.
//  Copyright © 2020 k2moons. All rights reserved.
//

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

    public func log(_ information: LogInformation) {
        let message = getStandardMessage(with: information)

        dependency.open()
        dependency.write(message)
        dependency.close()
    }
}

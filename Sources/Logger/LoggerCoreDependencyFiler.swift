//
//  LoggerDependencyFiler.swift
//  LoggerCore
//
//  Created by k2moons on 2019/12/01.
//  Copyright © 2019 k2moons. All rights reserved.
//

import Foundation

public class LoggerDependencyFiler: LoggerDependency {
    private static let filer = LoggerFiler()
    public init() {}
    public func log(_ formedMessage: String, original: String, level: LoggerCore.Level) {
        LoggerDependencyFiler.filer.open()
        LoggerDependencyFiler.filer.write(formedMessage)
        LoggerDependencyFiler.filer.close()
    }
}

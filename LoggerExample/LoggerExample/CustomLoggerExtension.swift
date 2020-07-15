//
//  MyLoggerDependency.swift
//  LoggerExample
//
//  Created by k_terada on 2020/04/16.
//  Copyright © 2020 Katsuhiko Terada. All rights reserved.
//

import Logger

class CustomLoggerExtension: LoggerDependency {
    
    public func log(_ formedMessage: String, original: String, level: Logger.Level) {
        print(formedMessage)
    }

    public func preFix(_ level: Logger.Level) -> String {

        return "[\(level.rawValue)]"
    }

    public func isEnabledClassAndMethodName(_ level: Logger.Level) -> Bool {
        return false
    }

    // true: Add file name and line number at the end of log
    public func isEnabledFileAndLineNumber(_ level: Logger.Level) -> Bool {
        switch level {
        case .info:     return false
        default:        return true
        }
    }

    func getTimeStampType(_ level: Logger.Level) -> Logger.TimeStampType {
        guard level == .info else {
            return DefaultLoggerDependencies().getTimeStampType(level)
        }
        return .none
    }
}

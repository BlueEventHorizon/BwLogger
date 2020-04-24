//
//  MyLoggerDependency.swift
//  LoggerExample
//
//  Created by k_terada on 2020/04/16.
//  Copyright © 2020 Katsuhiko Terada. All rights reserved.
//

import LoggerCore

class CustomLoggerExtension: LoggerDependency {
    public func log(_ formedMessage: String, original: String, level: LoggerCore.Level) {
        print(formedMessage)
    }
    public func preFix(_ level: LoggerCore.Level) -> String {
        switch level {
        case .enter:    return "❤️❤️❤️❤️"
        case .exit:     return "♠️♠️♠️♠️"

        case .error:    return "[🔥ERROR]"
        case .fatal:    return "[🔥FATAL]"
        default: return DefaultLoggerDependencies().preFix(level)
        }
    }
    public func isEnabledClassAndMethodName(_ level: LoggerCore.Level) -> Bool {
        return false
    }
    // true: Add file name and line number at the end of log
    public func isEnabledFileAndLineNumber(_ level: LoggerCore.Level) -> Bool {
        switch level {
        case .info:     return false
        default:        return true
        }
    }
}

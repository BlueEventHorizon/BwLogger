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
    
    public func prefix(with info: LogInformation) -> String {
        if let prefix = info.prefix {
            return prefix
        }

        switch info.level {
            case .log: return ""
            case .debug: return "#DEBUG"
            case .info: return "#INFOM"
            case .warning: return "#WARNG"
            case .error: return "#ERROR"
            case .fault: return "#🔥"
        }
    }
    
    public func generateMessage(with info: LogInformation) -> String {
        let prefix = prefix(with: info)
        return info.level == .info ?
            "\(prefix)\(addSeparater(info.message)) [\(info.objectName)]" :
            "\(prefix) [\(info.timestamp())]\(addSeparater(info.message)) [\(info.threadName)] [\(info.objectName)] \(info.fileName): \(info.line))"
    }
}

//
//  Logger+oslog.swift
//  BwTools
//
//  Created by k_terada on 2020/09/15.
//  Copyright © 2020 k2moons. All rights reserved.
//

import Foundation
import os

// swiftlint:disable prefixed_toplevel_constant
@available(iOS 14.0, *)
private let oslog = os.Logger(subsystem: ".app", category: "App")
// swiftlint:enable prefixed_toplevel_constant

// https://developer.apple.com/documentation/os/logging
// https://developer.apple.com/documentation/os/os_log
public class OsLogger: LogOutput {
    public init(subsystem: String = "com.beowulf-tech", category: String = "App") {}

    public func log(_ information: LogInformation) {
        let separator: String = information.message.isEmpty ? "" : " --"
        
        let message = information.level == .info ?
            "\(information.prefix)\(addSpacer(" ", before: information.message))\(separator) \(information.methodName)" :
            "\(information.prefix) [\(information.timestamp())] [\(information.threadName)]\(addSpacer(" ", before: information.message))\(separator) \(information.methodName) \(information.fileName):\(information.line))"

        if #available(iOS 14.0, *) {
            switch information.level {
                case .log:
                    oslog.log("\(message)")

                case .debug:
                    oslog.debug("\(message)")

                case .info:
                    oslog.info("\(message)")

                case .warning:
                    oslog.warning("\(message)")

                case .error:
                    oslog.error("\(message)")

                case .fault:
                    oslog.fault("\(message)")
            }
        } else {
            os_log("%s", message)
        }
    }
}

//
//  Logger+oslog.swift
//  BwTools
//
//  Created by k_terada on 2020/09/15.
//  Copyright © 2020 k2moons. All rights reserved.
//

import Foundation
import os

// #if LOGGER_iOS14_ENABLED

@available(iOS 14.0, *)
public class SystemLogger: LoggerDependency {
    private var oslog: os.Logger

    public init(subsystem: String, category: String) {
        oslog = os.Logger(subsystem: subsystem, category: category)
    }

    public func log(_ context: LogContext) {
        switch context.level {
            case .trace:
                oslog.log("\(context.message)")
            case .debug:
                oslog.debug("\(context.message)")
            case .info:
                oslog.info("\(context.message)")
            case .notice:
                oslog.notice("\(context.message)")
            case .warning:
                oslog.warning("\(context.message)")
            case .error:
                oslog.error("\(context.message)")
            case .fatal:
                oslog.critical("\(context.message)")
            case .deinit:
                oslog.log("\(context.message)")
        }
    }
}

// #endif

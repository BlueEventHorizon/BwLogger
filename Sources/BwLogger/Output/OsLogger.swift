//
//  OsLogger.swift
//  BwCore
//
//  Created by k2moons on 2020/09/15.
//  Copyright © 2020 k2moons. All rights reserved.
//

import Foundation
import os

// https://developer.apple.com/documentation/os/logging
// https://developer.apple.com/documentation/os/os_log

// OsLogger内に@availableを使っても直接宣言できない（ランタイムエラー）ためにWrapper Classを作って対応
@available(iOS 14.0, *)
private class Os14Wrapper {
    var log: os.Logger

    init(subsystem: String, category: String) {
        log = os.Logger(subsystem: subsystem, category: category)
    }

    init() {
        log = os.Logger()
    }
}

public class OsLogger {
    let subsystem: String
    let category: String

    @available(iOS 14.0, *)
    private lazy var os14: Os14Wrapper = {
        if subsystem.isEmpty, category.isEmpty {
            return Os14Wrapper()
        } else {
            return Os14Wrapper(subsystem: subsystem, category: category)
        }
    }()

    public init(subsystem: String, category: String) {
        self.subsystem = subsystem
        self.category = category
    }

    public init() {
        subsystem = "k2moons"
        category = "Logger"
    }

    private func generateMessage(with info: LogInformation) -> String {
        let prefix = prefix(with: info)

        return info.level == .info ?
            "\(prefix)\(addBlankBefore(info.message)) [\(info.objectName)]" :
            "\(prefix)\(addBlankBefore(info.message)) [\(info.threadName)] [\(info.objectName)] \(info.fileName): \(info.line))"
    }
}

extension OsLogger: LogOutput {
    public func log(_ information: LogInformation) {
        let message = generateMessage(with: information)

        if #available(iOS 14.0, *) {
            switch information.level {
                case .log:
                    os14.log.log("\(message)")

                case .debug:
                    os14.log.debug("\(message)")

                case .info:
                    os14.log.info("\(message)")

                case .warning:
                    os14.log.warning("\(message)")

                case .error:
                    os14.log.error("\(message)")

                case .fault:
                    os14.log.fault("\(message)")
            }
        } else {
            os_log("%@", message)
        }
    }
}

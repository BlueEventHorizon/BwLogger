//
//  Log.swift
//  LoggerApp
//
//  Created by Katsuhiko Terada on 2021/07/10.
//

import BwLogger
import Combine
import Foundation

let log = Logger(PublishedLogger.shared)

class PublishedLogger: ObservableObject, LogOutput {
    static let shared = PublishedLogger()

    @Published var logMessage: String = ""

    func log(_ information: LogInformation) {
        let message = getStandardMessage(with: information)

        logMessage = message
    }
}

extension LogOutput {
    public func prefix(for level: Logger.Level) -> String {
        switch level {
            case .log:
                return ""

            case .debug:
                return "✴️"

            case .info:
                return "✳️"

            case .warning:
                return "⚠️"

            case .error:
                return "🔥"

            case .fault:
                return "🔴"
        }
    }
}

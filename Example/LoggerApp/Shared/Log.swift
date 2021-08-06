//
//  Log.swift
//  LoggerApp
//
//  Created by Katsuhiko Terada on 2021/07/10.
//

import Foundation
import BwLogger
import Combine

let log = Logger(PublishedLogger.shared)

class PublishedLogger: ObservableObject, LogOutput {
    
    static let shared = PublishedLogger()
    
    @Published var logMessage: String = ""

    func log(_ context: LogInformation) {
        let separator: String = context.message.isEmpty ? "" : " --"
        
        let message = context.level == .info ?
            "\(context.prefix)\(addSpacer(" ", before: context.message))\(separator) \(context.methodName)" :
            "\(context.prefix) [\(context.timestamp())] [\(context.threadName)]\(addSpacer(" ", before: context.message))\(separator) \(context.methodName) \(context.fileName):\(context.line))"

        logMessage = message
    }
}

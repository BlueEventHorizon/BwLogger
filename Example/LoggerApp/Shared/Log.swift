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

    func log(_ information: LogInformation) {
        let separator: String = information.message.isEmpty ? "" : " --"
        
        let message = information.level == .info ?
            "\(information.prefix)\(addSpacer(" ", before: information.message))\(separator) \(information.methodName)" :
            "\(information.prefix) [\(information.timestamp())] [\(information.threadName)]\(addSpacer(" ", before: information.message))\(separator) \(information.methodName) \(information.fileName):\(information.line))"

        logMessage = message
    }
}

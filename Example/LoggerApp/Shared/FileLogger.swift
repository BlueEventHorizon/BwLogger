//
//  FileLogger.swift
//  BwTools
//
//  Created by k_terada on 2020/07/16.
//  Copyright © 2020 k2moons. All rights reserved.
//

import Foundation
import BwLogger

public final class FileLogger: LogOutput {
    private let writer: FileWriter

    public init() {
        writer = FileWriter(directoryType: .document, name: "log", sub: "logs")
    }

    public func log(_ information: LogInformation) {
        let message = generateMessage(with: information)
        writer.writeAtOnce(text: message)
    }
}

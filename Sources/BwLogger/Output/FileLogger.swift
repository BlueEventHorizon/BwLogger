//
//  FileLogger.swift
//  BwTools
//
//  Created by k_terada on 2020/07/16.
//  Copyright © 2020 k2moons. All rights reserved.
//

import Foundation

public final class FileLogger: LogOutput {
    
    let writer: FileWriter

    init() {
        writer = FileWriter(directoryType: .document, names: ["logs", "log"])
    }
    
    public func log(_ information: LogInformation) {
        let message = generateMessage(with: information)
        writer.writeAtOnce(text: message)
    }
}

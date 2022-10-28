//
//  Logger+ExtraLevel.swift
//  BwLogger
//
//  Created by k2moons on 2022/02/24.
//  Copyright © 2019 k2moons. All rights reserved.
//

import Foundation

public extension Logger {
    // instanceを渡すことで、正確なオブジェクト名が得られます。
    func entered(_ instance: Any? = nil, message: Any = "", function: StaticString = #function, file: StaticString = #fileID, line: Int = #line) {
        log(LogInformation(message, level: .log, function: function, file: file, line: line, prefix: "#ENTER", instance: instance))
    }

    // instanceを渡すことで、正確なオブジェクト名が得られます。
    func `deinit`(_ instance: Any? = nil, message: Any = "", function: StaticString = #function, file: StaticString = #fileID, line: Int = #line) {
        log(LogInformation(message, level: .log, function: function, file: file, line: line, prefix: "#DE-INITED", instance: instance))
    }

    func json(jsonData: Data, instance: Any? = nil, function: StaticString = #function, file: StaticString = #fileID, line: Int = #line) {
        let jsonString = Logger.decodeJsonData(jsonData)

        log(LogInformation(jsonString, level: .log, function: function, file: file, line: line, prefix: "#JSON", instance: instance))
    }
}

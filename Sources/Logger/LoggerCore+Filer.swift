//
//  LoggerCore+File.swift
//  LoggerCore
//
//  Created by k2moons on 2019/12/01.
//  Copyright © 2019 k2moons. All rights reserved.
//

import Foundation

public final class LoggerFiler {
    var fileURL: URL?
    var fileHandle: FileHandle?

    public init(_ name: String = "log.txt") {
        let docs: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        let url: URL = docs.appendingPathComponent(name)
        fileURL = url
        guard let _url = fileURL else { return }
        if !FileManager.default.fileExists( atPath: _url.path ) {
            FileManager.default.createFile(atPath: _url.path, contents: nil, attributes: nil)
        }
    }

    public func open() {
        guard let _url = fileURL else { return }
        do {
            fileHandle = try FileHandle(forWritingTo: _url)
            fileHandle?.seekToEndOfFile()
        } catch {
            print("\("🔥") couldn't write log file \(error).")
        }
    }

    public func close() {
        fileHandle?.closeFile()
        fileHandle = nil
    }

    public func write(_ text: String) {
        guard let _fileHandle = fileHandle, let data = (text+"\n").data(using: String.Encoding.utf8) else { return }
        _fileHandle.write(data)
    }
}


//
//  TextFileWriter.swift
//  BwTools
//
//  Created by k2moons on 2019/12/01.
//  Copyright © 2019 k2moons. All rights reserved.
//

import Foundation

public final class TextFileWriter {
    var fileURL: URL?
    var fileHandle: FileHandle?

    public init(name: String) {
        let docs: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        fileURL = docs.appendingPathComponent(name)

        guard let url = fileURL else { return }

        if !FileManager.default.fileExists(atPath: url.path) {
            FileManager.default.createFile(atPath: url.path, contents: nil, attributes: nil)
        }
    }

    public func open() {
        guard let url = fileURL else { return }
        do {
            fileHandle = try FileHandle(forWritingTo: url)
            fileHandle?.seekToEndOfFile()
        } catch {
            print("\("🔥") failed to write into \(url.absoluteString) by error: \(error).")
        }
    }

    public func close() {
        fileHandle?.closeFile()
        fileHandle = nil
    }

    public func write(_ text: String) {
        guard let fileHandle = fileHandle, let data = (text + "\n").data(using: .utf8) else { return }
        fileHandle.write(data)
    }
}

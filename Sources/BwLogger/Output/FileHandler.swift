//
//  File.swift
//  BwTools
//
//  Created by k2moons on 2021/12/03.
//  Copyright © 2020 k2moons. All rights reserved.
//

import Foundation

open class FileHandler {
    public enum DirectoryType {
        case document
        case home
        case temporary

        var url: URL {
            switch self {
                case .document:
                    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!

                case .home:
                    return FileManager.default.urls(for: .userDirectory, in: .localDomainMask).last!

                case .temporary:
                    return FileManager.default.temporaryDirectory
            }
        }
    }
    
    fileprivate let directory: URL
    fileprivate(set) var file: URL

    fileprivate var fileHandle: FileHandle?
    fileprivate let dispatchQueue: DispatchQueue

    public init(directory: URL, names: [String]) {
        self.directory = directory
        self.file = self.directory

        for name in names {
            self.file = self.file.appendingPathComponent(name)
        }

        self.dispatchQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier ?? "").\(UUID().uuidString)")
    }

    public init(directoryType: DirectoryType, names: [String]) {
        self.directory = directoryType.url
        self.file = self.directory
        
        for name in names {
            self.file = self.file.appendingPathComponent(name)
        }

        self.dispatchQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier ?? "").\(UUID().uuidString)")
    }
    
    public func list() -> [URL] {
        let list: [URL] = (try? FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: [])) ?? []

        for url in list {
            print("contents = \(url.absoluteString)")
        }

        return list
    }

    func close() {
        if #available(iOS 13.0, *) {
            try? fileHandle?.synchronize()
        }
        fileHandle?.closeFile()
        fileHandle = nil
    }

    func assertionFailure(_ error: Error, description: String) {
        Swift.assertionFailure("\("🔥")\(error) \(description) \(self.file.absoluteString)")
    }

    func remove() {
        dispatchQueue.async { [weak self] in
            guard let self = self else { return }

            do {
                try FileManager.default.removeItem(at: self.file)
            } catch {
                self.assertionFailure(error, description: "failed to removefile")
            }
        }
    }
}

public final class FileReader: FileHandler {
    public func open() {
        do {
            self.fileHandle = try FileHandle(forReadingFrom: self.file)
        } catch {
            assertionFailure(error, description: "failed to read open")
        }
    }

    public func readAtOnce(completion: ((Data?) -> Void)?) {
        dispatchQueue.async { [weak self] in
            guard let self = self else { return }

            let data: Data?

            self.open()

            if #available(iOS 13.4, *) {
                do {
                    data = try self.fileHandle?.readToEnd()
                } catch {
                    data = nil
                    
                    self.assertionFailure(error, description: "failed to read at once")
                }
            } else {
                data = self.fileHandle?.readDataToEndOfFile()
            }

            self.close()

            completion?(data)
        }
    }
}

public final class FileWriter: FileHandler {
    public func open() {
        if !FileManager.default.fileExists(atPath: self.file.path) {
            FileManager.default.createFile(atPath: self.file.path, contents: nil, attributes: nil)
        }

        do {
            self.fileHandle = try FileHandle(forWritingTo: self.file)
            if #available(iOS 13.4, *) {
                try self.fileHandle?.seekToEnd()
            } else {
                self.fileHandle?.seekToEndOfFile()
            }
        } catch {
            assertionFailure(error, description: "failed to write open")
        }
    }

    public func write(data: Data) {
        dispatchQueue.async { [weak self] in
            guard let self = self else { return }

            if #available(iOS 13.4, *) {
                do {
                    try self.fileHandle?.write(contentsOf: data)
                } catch {
                    self.assertionFailure(error, description: "failed to write")
                }
            } else {
                self.fileHandle?.write(data)
            }
        }
    }

    public func writeAtOnce(data: Data, completion: (() -> Void)?) {
        dispatchQueue.async { [weak self] in
            guard let self = self else { return }

            self.open()
            self.write(data: data)
            self.close()

            completion?()
        }
    }

    public func writeAtOnce(text: String, completion: (() -> Void)? = nil) {
        dispatchQueue.async { [weak self] in
            guard let self = self else { return }

            try? text.write(to: self.file, atomically: true, encoding: .utf8)

            completion?()
        }
    }
}
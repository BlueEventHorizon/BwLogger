//
//  Logger+Ext.swift
//  Logger
//
//  Created by k2moons on 2019/10/18.
//  Copyright © 2019 k2moons. All rights reserved.
//

import UIKit

public extension Logger {
    func pointString(_ point: CGPoint) -> String {
        return "x=" + String(describing: point.x) + ", y=" + String(describing: point.y)
    }

    func point(_ point: CGPoint, message: String = "", instance: Any = #file, function: String = #function, file: String = #file, line: Int = #line) {
        let msg = "\(pointString(point)) \(message)"
        self.log( level: .info, message: msg, instance: instance, file: file, function: function, line: line)
    }

    func frameString(_ frame: CGRect) -> String {
        return "x= \(String(describing: frame.origin.x)), y= \(String(describing: frame.origin.y)), w= \(String(describing: frame.size.width)), h= \(String(describing: frame.size.height))"
    }

    func frame(_ frame: CGRect, message: String = "", instance: Any = #file, function: String = #function, file: String = #file, line: Int = #line) {
        let msg = "\(frameString(frame)) \(message)"
        self.log(level: .info, message: msg, instance: instance, file: file, function: function, line: line)
    }

    func url(_ url: URL) {
        self.info("url : \(url.absoluteString)")

        if let _scheme = url.scheme {
            self.info("scheme : \(_scheme)")
        }
        if let _host = url.host {
            self.info("host : \(_host)")
        }
        if let _port = url.port {
            self.info("port : \(_port)")
        }
        if let _query = url.query {
            self.info("query : \(_query)")
        }
    }
}

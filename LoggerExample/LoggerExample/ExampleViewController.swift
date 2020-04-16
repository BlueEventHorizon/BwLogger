//
//  ExampleViewController.swift
//  LoggerExample
//
//  Created by k2moons on 2019/12/01.
//  Copyright © 2019 k2moons. All rights reserved.
//

import UIKit
import Logger

public let log = Logger(levels: nil)

class ExampleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        log.entered(self)
        DispatchQueue.global().async {
            log.debug("in DispatchQueue.global().async", instance: self)
        }
        log.error("xxxxx is failed")
        let _ = TestStruct()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        log.dep = MyLoggerDependency()
        log.entered()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        log.dep = LoggerDependencyFiler()
        log.entered()
    }
}

struct TestStruct {
    init() {
        log.entered(self)
        log.error("xxxxx is failed")
    }
}

class MyLoggerDependency: LoggerDependency {
    public func log(_ formedMessage: String, original: String, level: Logger.Level) {
        print(formedMessage)
    }
    public func preFix(_ level: Logger.Level) -> String {
        switch level {
        case .enter:    return "❤️❤️❤️❤️"
        case .exit:     return "♠️♠️♠️♠️"

        case .error:    return "[🔥ERROR]"
        case .fatal:    return "[🔥FATAL]"
        default: return DefaultLoggerDependencies().preFix(level)
        }
    }
    public func isEnabledClassAndMethodName(_ level: Logger.Level) -> Bool {
        return false
    }
    // true: Add file name and line number at the end of log
    public func isEnabledFileAndLineNumber(_ level: Logger.Level) -> Bool {
        switch level {
        case .info:     return false
        default:        return true
        }
    }
}

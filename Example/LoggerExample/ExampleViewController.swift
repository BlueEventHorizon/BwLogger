//
//  ExampleViewController.swift
//  LoggerExample
//
//  Created by k2moons on 2019/12/01.
//  Copyright © 2019 k2moons. All rights reserved.
//

import UIKit
import BwLogger

class ExampleViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        showLog(log: Logger(PrintLogger()), title: "Standard Logger")
        showLog(log: Logger(OsLogger()), title: "Logger with os_log")

        TestClass()
    }
    
    func showLog(log: Logger, title: String) {
        print("--------------------------------------------")
        print("\(title)")
        print("--------------------------------------------\n")

        log.info("----- メッセージあり（自インスタンス有無） ----")

        log.entered()
        log.entered(self)
        log.entered(message: "Hello World!")
        log.entered(self, message: "Hello World!")

        log.info("Hello World!")
        log.info("Hello World!", instance: self)

        log.debug("Hello World!")
        log.debug("Hello World!", instance: self)
        log.debug(CGSize(width: 500, height: 256))
        log.debug(CGSize(width: 500, height: 256), instance: self)

        log.warning(URL(string: "http://www.example.com")!)
        log.warning(URL(string: "http://www.example.com")!, instance: self)

        log.error("Hello World!")
        log.error("Hello World!", instance: self)

        log.deinit()
        log.deinit(self)

        log.info("----- メッセージなし ----")

        log.entered()
        log.info("")
        log.debug("")
        log.warning("")
        log.error("")
        log.deinit()

        print("\n")
    }
}

class TestClass {
    let log: Logger
    init() {
        log = Logger(PrintLogger())
        log.entered(self)
        log.error("log.error()", instance: self)
    }
    deinit {
        log.deinit()
    }
}



//
//  ExampleViewController.swift
//  LoggerExample
//
//  Created by k2moons on 2019/12/01.
//  Copyright © 2019 k2moons. All rights reserved.
//

import UIKit
import BwLogger

public let log = Logger.default

class ExampleViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        showLog(title: "Standard Logger")


        log.setDependency(OsLogger())
        showLog(title: "Logger with os_log")

    }
    
    func showLog(title: String) {
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

        log.notice("Hello World!")
        log.notice("Hello World!", instance: self)

        log.debug("Hello World!")
        log.debug("Hello World!", instance: self)
        log.debug(CGSize(width: 500, height: 256))
        log.debug(CGSize(width: 500, height: 256), instance: self)

        log.warning(URL(fileURLWithPath: "Hello World!"))
        log.warning(URL(fileURLWithPath: "Hello World!"), instance: self)

        log.error("Hello World!")
        log.error("Hello World!", instance: self)

        log.deinit()
        log.deinit(self)

        log.info("----- メッセージなし ----")

        log.entered()
        log.info("")
        log.notice("")
        log.debug("")
        log.warning("")
        log.error("")
        log.deinit()

        print("\n")
    }
}

class TestClass {
    init() {
        log.entered()
        log.error("log.error()")
    }
    deinit {
        log.deinit()
    }
}



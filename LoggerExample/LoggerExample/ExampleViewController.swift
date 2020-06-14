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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        showLogger(title: "Standard Logger")
        
        log.dep = CustomLoggerExtension()

        showLogger(title: "Cunstomized Logger")

    }
    
    func showLogger(title: String) {
        log.info("--------------------------------------------")
        log.info(title)
        log.info("--------------------------------------------")

        log.entered(self, message: "log.entered()")
        log.warning("log.warn()")

        DispatchQueue.global().async {
            log.debug("log.debug() in DispatchQueue.global().async", instance: self)
        }

        log.error("log.error()")

        let _ = TestStruct()
    }
}

struct TestStruct {
    init() {
        log.entered(self)
        log.error("log.error()")
    }
}



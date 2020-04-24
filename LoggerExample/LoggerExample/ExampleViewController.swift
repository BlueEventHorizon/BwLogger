//
//  ExampleViewController.swift
//  LoggerExample
//
//  Created by k2moons on 2019/12/01.
//  Copyright © 2019 k2moons. All rights reserved.
//

import UIKit
import LoggerCore

public let log = LoggerCore(levels: nil)

class ExampleViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        showLogger(title: "Normal LoggerCore")
        
        log.dep = CustomLoggerExtension()
        showLogger(title: "CustomLoggerExtension")
        
        log.dep = LoggerDependencyFiler()
        showLogger(title: "Output to file LoggerCore")
    }
    
    func showLogger(title: String) {
        log.info("--------------------------------------------")
        log.info(title)
        log.info("--------------------------------------------")
        log.entered(self, message: "log.entered()")
        log.warn("log.warn()")
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



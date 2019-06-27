//
//  ViewController.swift
//  EasyLogger
//
//  Created by Katsuhiko Terada on 2019/06/27.
//  Copyright © 2019 Katsuhiko Terada. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        logger.entered(self)
        super.viewDidLoad()
        
        
        logger.debug("example for debug log.")
        logger.info("example for info log.")
        logger.warn("example for warn log.")
        logger.error("example for error log.")
        
        // assert from your app
        //logger.fatal("example for fatal log.")
        
        DispatchQueue.global().async {
            logger.entered(self)
            logger.debug("example for debug log. in global queue")
            logger.info("example for info log. in global queue")
            logger.warn("example for warn log. in global queue")
            logger.error("example for error log. in global queue")
        }
    }
}


//
//  LoggerExtension.swift
//  Logger
//
//  Created by k2moons on 2019/09/16.
//  Copyright © 2019 k2moons. All rights reserved.
//

//import Foundation
//import UIKit
//
//// MARK: - LoggerDependencyForOutputFile
//
//public final class KeychainLoggerController: Identifiable {
//    private var isEnableArray: Dictionary<String, Bool> = [:]
//    private var accessGroup: String?
//    private var keychain: KeychainAccessService!
//
//    public init() {
//        configure()
//    }
//
//    private func configure() {
//        keychain = KeychainAccessService(service: KeychainLoggerController.classIdentifier)
//        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: UIApplication.willEnterForegroundNotification, object: nil)
//        reload()
//    }
//
//    private func getKey(_ level: Logger.Level) -> String {
//        return "\(level.rawValue).isEnabled"
//    }
//
//    @objc private func reload() {
//        isEnableArray.removeAll()
//        for level in Logger.Level.allCases {
//            isEnableArray[level.rawValue] = (keychain.get(key: getKey(level)) ?? "" == "1")
//        }
//    }
//}
//
//// LoggerDependency
//extension KeychainLoggerController {
//    public func isEnabled(_ level: Logger.Level) -> Bool {
//        return isEnableArray[level.rawValue] ?? false
//    }
//}
//
//// For anothor App for control
//extension KeychainLoggerController {
//    public func controll(_ level: Logger.Level, on: Bool) {
//        if on {
//            keychain.set(key: getKey(level), value: "1")
//        } else {
//            keychain.set(key: getKey(level), value: "0")
//        }
//    }
//}

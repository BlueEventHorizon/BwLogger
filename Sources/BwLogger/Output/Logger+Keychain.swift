//
//  LoggerControllerWithKeychain.swift
//  BwTools
//
//  Created by k2moons on 2019/09/16.
//  Copyright © 2019 k2moons. All rights reserved.
//

import Foundation
import UIKit

// MARK: - LoggerControllerWithKeychain

public final class LoggerControllerWithKeychain: ClassIdentifiable {
    private var isEnableArray: [String: Bool] = [:]
    private var accessGroup: String?
    private var keychain: KeychainAccessService!

    public init() {
        configure()
    }

    private func configure() {
        keychain = KeychainAccessService(service: LoggerControllerWithKeychain.classIdentifier)
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: UIApplication.willEnterForegroundNotification, object: nil)
        reload()
    }

    private func getKey(_ level: Logger.Level) -> String {
        "\(level.rawValue).isEnabled"
    }

    @objc
    private func reload() {
        isEnableArray.removeAll()
        for level in Logger.Level.allCases {
            isEnableArray[level.rawValue] = (keychain.get(key: getKey(level)) ?? "" == "1")
        }
    }

    public func isEnabled(_ level: Logger.Level) -> Bool {
        isEnableArray[level.rawValue] ?? false
    }

    public func controll(_ level: Logger.Level, on: Bool) {
        if on {
            keychain.set(key: getKey(level), value: "1")
        } else {
            keychain.set(key: getKey(level), value: "0")
        }
    }
}

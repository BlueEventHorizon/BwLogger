//
//  String+Empty.swift
//  BwCore
//
//  Created by k2moons on 2019/07/13.
//  Copyright © 2019 k2moons. All rights reserved.
//

import Foundation

extension String {
    public var isNotEmpty: Bool {
        !self.isEmpty
    }
}

extension Optional where Wrapped == String {
    public var isEmpty: Bool {
        switch self {
            case let .some(str):
                return str.isEmpty

            case .none:
                return true
        }
    }

    public var isNotEmpty: Bool {
        switch self {
            case let .some(str):
                return !str.isEmpty

            case .none:
                return false
        }
    }
}

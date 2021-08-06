//
//  LogOutput.swift
//  
//
//  Created by Katsuhiko Terada on 2021/08/06.
//

import Foundation

public protocol LogOutput {
    func log(_ information: LogInformation)
}

extension LogOutput {
    // stringが空でなければstringの前にspacerを追加する
    public func addSpacer(_ spacer: String, before string: String) -> String {
        guard string.isNotEmpty else { return "" }

        return "\(spacer)\(string)"
    }
}

#if LOGGER_PRIVATE_EXTENSION_ENABLED
    // swiftlint:disable strict_fileprivate

    extension String {
        fileprivate var isNotEmpty: Bool {
            !self.isEmpty
        }
    }

    // swiftlint:enable strict_fileprivate
#endif

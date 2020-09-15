//
//  LogContext.swift
//  BwTools
//
//  Created by k_terada on 2020/09/15.
//  Copyright © 2020 k2moons. All rights reserved.
//

import Foundation

public struct LogContext {
    public enum TimeStampType: String {
        case none
        case detail
        case simple
        case normal
        case full

        var style: String {
            switch self {
                case .none:
                    return ""
                case .detail:
                    return "HH:mm:ss.SSS"
                case .simple:
                    return "MM/dd HH:mm:ss.SSS"
                case .normal:
                    return "yyyy/MM/dd HH:mm:ss.SSS"
                case .full:
                    return "yyyy/MM/dd HH:mm:ss.SSS z"
            }
        }
    }

    public enum DescriptionType {
        case none
        case normal
        case detail
    }

    public let level: Logger.Level
    public let message: String
    public let instance: Any
    public let function: StaticString
    public let file: StaticString
    public let line: Int

    public init(
        level: Logger.Level,
        message: Any,
        instance: Any,
        function: StaticString,
        file: StaticString,
        line: Int

    ) {
        self.level = level
        self.message = (message as? String) ?? String(describing: message)
        self.instance = instance
        self.function = function
        self.file = file
        self.line = line
    }

    public func timestamp(_ timestampType: TimeStampType = .full) -> String {
        Date().string(dateFormat: timestampType.style)
    }

    public func threadName() -> String {
        var threadName: String = "main"

        if !Thread.isMainThread {
            if let _threadName = Thread.current.name, !_threadName.isEmpty {
                threadName = _threadName
            }
            else if let _queueName = String(validatingUTF8: __dispatch_queue_get_label(nil)), !_queueName.isEmpty {
                threadName = _queueName
            }
            else {
                threadName = Thread.current.description
            }
        }

        return threadName
    }

    public func methodName(_ descriptionType: DescriptionType = .normal) -> String {
        guard descriptionType != .none else { return "" }

        var methodName: String = ""
        let fileName = URL(fileURLWithPath: "\(file)").lastPathComponent
        let className = String(describing: instance)

        if className.isEmpty, let _fileName = fileName.components(separatedBy: ".").first {
            methodName = "\(_fileName):\(function)"
        }
        else {
            switch descriptionType {
                case .normal:
                    methodName = "\(String(describing: type(of: instance))):\(function)"
                case .detail:
                    methodName = "\(className):\(function)"
                case .none:
                    break // never
            }
        }

        return methodName
    }

    public func lineInfo() -> String {
        let fileName = URL(fileURLWithPath: "\(file)").lastPathComponent
        return "\(fileName):\(line)"
    }

    public func addSpacer(_ spacer: String, to string: String) -> String {
        guard string.isNotEmpty else { return "" }

        return "\(spacer)\(string)"
    }

    public func buildMessage() -> String {
        var formattedMessage = ""

        switch level {
            case .trace:
                formattedMessage = "\(methodName())\(addSpacer(" -- ", to: message))"
            case .debug:
                formattedMessage = "[\(timestamp())] [\(threadName())]\(addSpacer(" ", to: message)) -- \(methodName()) \(lineInfo())"
            case .info:
                formattedMessage = "[\(timestamp())]\(addSpacer(" ", to: message)) -- \(lineInfo())"
            case .notice:
                formattedMessage = "[\(timestamp())]\(addSpacer(" ", to: message)) -- \(methodName()) \(lineInfo())"
            case .warning:
                formattedMessage = "[\(timestamp())] [\(threadName())]\(addSpacer(" ", to: message)) -- \(methodName()) \(lineInfo())"
            case .error:
                formattedMessage = "[\(timestamp())] [\(threadName())]\(addSpacer(" ", to: message)) -- \(methodName()) \(lineInfo())"
            case .fatal:
                formattedMessage = "[\(timestamp())] [\(threadName())]\(addSpacer(" ", to: message)) -- \(methodName()) \(lineInfo())"
            case .deinit:
                formattedMessage = "[\(timestamp())] \(methodName())"
        }
        return formattedMessage
    }
}

// MARK: - Private extension

#if LOGGER_PRIVATE_EXTENSION_ENABLED

    extension String {
        fileprivate var isNotEmpty: Bool {
            !self.isEmpty
        }
    }

    extension Date {
        // Date → String
        fileprivate func string(dateFormat: String) -> String {
            let formatter = DateFormatter.standard
            formatter.dateFormat = dateFormat
            return formatter.string(from: self)
        }
    }

    extension DateFormatter {
        // 現在タイムゾーンの標準フォーマッタ
        fileprivate static let standard: DateFormatter = {
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.calendar = Calendar(identifier: .gregorian)
            return formatter
        }()
    }

#endif

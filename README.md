# Logger

**Simple and customizable Logging API package for Swift**

When Xcode < 12.0

  **Please choose 2.x.x**

Else

 **Please chosse 3.x.x**



APIs are

```swift

/// Appropriate for messages that contain information only when debugging a program.
func entered(_ instance: Any = "", message: String = "")

/// Appropriate for informational messages.
func info(_ message: Any, instance: Any = "")

/// Appropriate for messages that contain information normally of use only when
/// debugging a program.
func debug(_ message: Any, instance: Any = "")

/// Appropriate for conditions that are not error conditions, but that may require
/// special handling.
func notice(_ message: Any, instance: Any = "")

/// Appropriate for messages that are not error conditions, but more severe than
func warning(_ message: Any, instance: Any = "")

/// Appropriate for error conditions.
func error(_ message: Any, instance: Any = "")

/// Appropriate for critical error conditions that usually require immediate
/// attention.
func fatal(_ message: Any, instance: Any = "")

func `deinit`(_ instance: Any = "", message: Any = "")

```

#### Usage

```swift

// 1) import the logging API package
import Logger

// 2) create a logger
let log = Logger.default

// 3) use it
logger.degub("Hello World!")

```

#### Output

```
[🟠 DEBG] [2020/07/26 00:53:26.938 GMT+9] [main] Hello World! -- ExampleViewController:showLog(title:) ExampleViewController.swift:45
```

#### Customization

If you use declare below, Logger uses os_log provided Apple.

```swift

log.setDependency(OsLogger())

```

You could make dependency code implements LoggerDependency protocol for Logger like class OsLogger below

```swift

public class OsLogger: LoggerDependency {

    public init() {}

    public func log(_ context: LogContext) {

        var formattedMessage = ""

        switch context.level {
            case .trace:
                formattedMessage = "\("➡️") \(context.methodName())\(context.addSpacer(" -- ", to: context.message))"
            case .debug:
                formattedMessage = "\("🟠") [\(context.threadName())]\(context.message) -- \(context.lineInfo())"
            case .info:
                formattedMessage = "\("🔵")\(context.addSpacer(" ", to: context.message)) -- \(context.lineInfo())"
            case .notice:
                formattedMessage = "\("🟢")\(context.addSpacer(" ", to: context.message)) -- \(context.lineInfo())"
            case .warning:
                formattedMessage = "\("⚠️") [\(context.threadName())]\(context.addSpacer(" ", to: context.message)) -- \(context.lineInfo())"
            case .error:
                formattedMessage = "\("❌") [\(context.threadName())]\(context.addSpacer(" ", to: context.message)) -- \(context.lineInfo())"
            case .fatal:
                formattedMessage = "\("🔥") [\(context.threadName())]\(context.addSpacer(" ", to: context.message)) -- \(context.lineInfo())"
            case .deinit:
                formattedMessage = "\("❎ DEINIT")\(context.addSpacer(" ", to: context.message)) -- \(context.lineInfo())"
        }

        os_log("%s", formattedMessage)
    }
}

```

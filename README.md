# Logger

**Simple and customizable Logging API package for Swift**

You can customize and use BwLogger. You can inject by describing the output format and output destination.

The standard output destination is
1) print statement
2) For iOS14 or above, os.Logger
3) If it is less than iOS14, os_log
It has become.

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
import BwLogger

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

    public func log(_ information: LogInformation) {

        var formattedMessage = ""

        switch information.level {
            case .trace:
                formattedMessage = "\("➡️") \(information.methodName())\(information.addSpacer(" -- ", to: information.message))"
            case .debug:
                formattedMessage = "\("🟠") [\(information.threadName())]\(information.message) -- \(information.lineInfo())"
            case .info:
                formattedMessage = "\("🔵")\(information.addSpacer(" ", to: information.message)) -- \(information.lineInfo())"
            case .notice:
                formattedMessage = "\("🟢")\(information.addSpacer(" ", to: information.message)) -- \(information.lineInfo())"
            case .warning:
                formattedMessage = "\("⚠️") [\(information.threadName())]\(information.addSpacer(" ", to: information.message)) -- \(information.lineInfo())"
            case .error:
                formattedMessage = "\("❌") [\(information.threadName())]\(information.addSpacer(" ", to: information.message)) -- \(information.lineInfo())"
            case .fatal:
                formattedMessage = "\("🔥") [\(information.threadName())]\(information.addSpacer(" ", to: information.message)) -- \(information.lineInfo())"
            case .deinit:
                formattedMessage = "\("❎ DEINIT")\(information.addSpacer(" ", to: information.message)) -- \(information.lineInfo())"
        }

        os_log("%s", formattedMessage)
    }
}

```

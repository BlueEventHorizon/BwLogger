# Logger

**Simple and customizable Logging API package for Swift**

![](https://img.shields.io/badge/license-Apache%202-green.svg)
![](https://img.shields.io/badge/Platforms-iOS-blue)
![](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange)

You can customize and use BwLogger. You can inject by describing the output format and output destination.

The standard output destination is
1) print statement
2) For iOS14 or above, os.Logger
3) If it is less than iOS14, os_log
It has become.

log functions are below.

`message` is the message to be logged out.

`instance` is the auxiliary information for the log output. For example, if the log output side is "class" and "instance" is "self", the class name can be displayed in addition to the file name, line number, and function name when the log is output.
Passing `instance` is not required.

Use the default values for `function`, `file` and `line` without passing anything.

```swift

    public func log(_ message: Any, instance: Any? = nil, function: String = #function, file: String = #file, line: Int = #line)

    public func info(_ message: Any, instance: Any? = nil, function: String = #function, file: String = #file, line: Int = #line)

    public func debug(_ message: Any, instance: Any? = nil, function: String = #function, file: String = #file, line: Int = #line)

    public func warning(_ message: Any, instance: Any? = nil, function: String = #function, file: String = #file, line: Int = #line)

    public func error(_ message: Any, instance: Any? = nil, function: String = #function, file: String = #file, line: Int = #line)

    public func fault(_ message: Any, instance: Any? = nil, function: String = #function, file: String = #file, line: Int = #line)

```



#### Initialization and usage

```swift

// 1) import the logging API package
import BwLogger

// 2) create a logger and initialization
let log = Logger.default

or 

let log = Logger([OSLogger(subsystem: "com.xxxxxx.xxxx", category: "App")])

// 3) You can call the log function as follows
logger.degub("Hello World!")

```

#### Output (For Example)

BwLogger allows you to change the format at will, and the following is a case where the default formatter is used.

In the example below, the following information is output in order from the top: log type, date and time, thread name, message, class name, function name, file name, and number of lines.

```
[🟠 DEBG] [2020/07/26 00:53:26.938 GMT+9] [main] Hello World! -- ExampleViewController:showLog(title:) ExampleViewController.swift:45
```

#### Customization

You can freely customize the log output by defining a MyDefinedLogger that conforms to the LogOutput protocol as shown below.

```swift

public class MyDefinedLogger: LogOutput {
    public init() {}

    public func log(_ information: LogInformation) {
        let message = generateMessage(with: information)

        print(message)
    }

    public func prefix(for level: Logger.Level) -> String {
        switch level {
            case .log:      return ""
            case .debug:    return "MY DEBUG PREFIX"
            case .info:     return "MY INFORM PREFIX"
            case .warning:  return "MY WARNING PREFIX"
            case .error:    return "MY ERROR PREFIX"
            case .fault:    return "MY FAULT PREFIX"
        }
    }

    public func generateMessage(with info: LogInformation) -> String {
        "\(info.prefix) [\(info.timestamp())]\(addBlankBefore(info.message)) [\(info.threadName)] [\(info.objectName)] \(info.fileName): \(info.line))"
    }
}

let log = Logger([MyDefinedLogger(subsystem: "com.xxxxxx.xxxx", category: "App")])

```

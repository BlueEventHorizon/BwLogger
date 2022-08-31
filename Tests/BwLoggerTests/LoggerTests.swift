@testable import BwLogger
import XCTest

final class LoggerTests: XCTestCase {
    func testConsoleLogger() throws {
        let log = Logger([ConsoleLogger()])

        log.info("----- 通常Logger【開始】 ----")

        log.info("----- メッセージあり（自インスタンス有無） ----")

        log.entered()
        log.entered(self)
        log.entered(message: "Hello World!")
        log.entered(self, message: "Hello World!")

        log.info("Hello World!")
        log.info("Hello World!", instance: self)

        log.debug("Hello World!")
        log.debug("Hello World!", instance: self)
        log.debug(CGSize(width: 500, height: 256))
        log.debug(CGSize(width: 500, height: 256), instance: self)

        log.warning(URL(string: "http://www.example.com")!)
        log.warning(URL(string: "http://www.example.com")!, instance: self)

        log.error("Hello World!")
        log.error("Hello World!", instance: self)

        log.deinit()
        log.deinit(self)

        log.info("----- メッセージなし ----")

        log.entered()
        log.debug("")
        log.warning("")
        log.error("")
        log.deinit()

        log.info("----- 通常Logger【終了】 ----")
    }

    func testDisable() throws {
        let log = Logger([ConsoleLogger()])

        log.info("----- NO 自インスタンス 非表示テスト【開始】 ----")

        log.entered()
        log.entered(message: "XXXX")
        log.info("日本語も入れてみる")

        log.debug("hello world")
        log.debug(CGSize(width: 500, height: 256))
        log.warning(URL(string: "http://www.example.com"))
        log.warning(URL(fileURLWithPath: "http://www.example.com"))
        log.error("test error")
        log.deinit(self)

        log.info("----- NO 自インスタンス 非表示テスト【終了】 ----")
    }

    func testOsLogger() throws {
        let log = Logger([OSLogger()])

        log.info("----- NO 自インスタンス ----")

        log.entered()
        log.entered(message: "XXXX")
        log.info("日本語も入れてみる")

        log.debug("hello world")
        log.debug(CGSize(width: 500, height: 256))
        log.warning(URL(string: "http://www.example.com"))
        log.warning(URL(fileURLWithPath: "http://www.example.com"))
        log.error("test error")
        log.deinit(self)

        log.info("----- NO 引数 ----")

        log.entered()
        log.info("")
        log.debug("")
        log.warning("")
        log.error("")
        log.deinit()
    }
}

import XCTest
@testable import Logger

final class LoggerTests: XCTestCase {


    func testAll() throws {
        let log = Logger()

        log.info("----- 通常Logger【開始】 ----")

        log.info("----- メッセージあり（自インスタンス有無） ----")

        log.entered()
        log.entered(self)
        log.entered(message: "Hello World!")
        log.entered(self, message: "Hello World!")

        log.info("Hello World!")
        log.info("Hello World!", instance: self)

        log.notice("Hello World!")
        log.notice("Hello World!", instance: self)

        log.debug("Hello World!")
        log.debug("Hello World!", instance: self)
        log.debug(CGSize(width: 500, height: 256))
        log.debug(CGSize(width: 500, height: 256), instance: self)

        log.warning(URL(string: "Hello World!")!)
        log.warning(URL(fileURLWithPath: "Hello World!"))
        log.warning(URL(string: "Hello World!")!, instance: self)
        log.warning(URL(fileURLWithPath: "Hello World!"), instance: self)

        log.error("Hello World!")
        log.error("Hello World!", instance: self)

        log.deinit()
        log.deinit(self)

        log.info("----- メッセージなし ----")

        log.entered()
        log.info("")
        log.notice("")
        log.debug("")
        log.warning("")
        log.error("")
        log.deinit()

        log.info("----- 通常Logger【終了】 ----")
    }

    func testDisable() throws {
        let log = Logger()
        log.isDisabled = true

        log.info("----- NO 自インスタンス 非表示テスト【開始】 ----")

        log.entered()
        log.entered(message: "XXXX")
        log.info("日本語も入れてみる")
        log.notice("これは表示できますか")
        log.debug("hello world")
        log.debug(CGSize(width: 500, height: 256))
        log.warning(URL(string: "www.yahoo.co.jp"))
        log.warning(URL(fileURLWithPath: "www.yahoo.co.jp"))
        log.error("test error")
        log.deinit(self)

        log.info("----- NO 自インスタンス 非表示テスト【終了】 ----")
    }

    func testOsLogger() throws {
        let log = Logger(OsLogger())

        log.info("----- NO 自インスタンス ----")

        log.entered()
        log.entered(message: "XXXX")
        log.info("日本語も入れてみる")
        log.notice("これは表示できますか")
        log.debug("hello world")
        log.debug(CGSize(width: 500, height: 256))
        log.warning(URL(string: "www.yahoo.co.jp"))
        log.warning(URL(fileURLWithPath: "www.yahoo.co.jp"))
        log.error("test error")
        log.deinit(self)

        log.info("----- NO 引数 ----")

        log.entered()
        log.info("")
        log.notice("")
        log.debug("")
        log.warning("")
        log.error("")
        log.deinit()
    }
    
}

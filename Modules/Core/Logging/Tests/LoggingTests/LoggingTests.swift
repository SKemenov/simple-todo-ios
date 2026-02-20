import Testing
@testable import Logging
import Foundation

@Suite("Logging tests")
struct LoggingTests {

    @Test("Can log [CORE] submodule messages")
    func logCoreMessage() {
        Logger.core.log("test")
        #expect(true)
    }

    @Test("Can log [NETWORK] submodule messages")
    func logNetworkMessage() {
        Logger.network.log("test")
        #expect(true)
    }

    @Test("Can log [STORAGE] submodule messages")
    func logStorageMessage() {
        Logger.storage.log("test")
        #expect(true)
    }

    @Test("Can log [REPOS] submodule messages")
    func logRepoMessage() {
        Logger.repos.log("test")
        #expect(true)
    }

    @Test("Can log [USER_FLOW] submodule messages")
    func logUserFlowMessage() {
        Logger.userFlow.log("test")
        #expect(true)
    }
}

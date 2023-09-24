import XCTest
import Testing
@testable import SwiftTesting


// グローバルメソッドでもOK
@Test
func isHoge() {
    #expect(2 == 2)
}

struct SwiftTestingTests2 {
    @Test
    func isHoge() {
        #expect(2 == 2)
    }
    
    // @Testがないと評価されない
    func isFuga() {
        #expect(4 == 3)
    }
    
    // MainThreadでは動かない
    // XCTestは全てメインスレッドで動いてた
    @Test()
    func notMainThread() {
        #expect(!Thread.isMainThread)
    }
    
    // MainThreadで動かすには以下のようにする
    @Test @MainActor
    func thisIsMainThread1() {
        #expect(Thread.isMainThread)
    }
    
    @Test
    func thisIsMainThread2() {
        Task { @MainActor
            #expect(Thread.isMainThread)
        }
    }
}

import XCTest
import Testing
@testable import SwiftTesting


// グローバルメソッドでもOK
@Test
func isHoge() {
    #expect(2 == 2)
}

// structでもいける
//setUpがinitに当たる
struct MyTest1 {
    var isFuga: Bool
    
    // scyncとthrwsをつけるのは任意
    init() async throws {
        self.isFuga = true
    }
    
    @Test func isHoge() {
        #expect(true)
    }
}

// teardownを使う場合はdeinitを利用する
// ゆえにstructは使えずclassかactorを使う
// classを使う場合はfinalにする（required initでもコンパイルエラーにはならない）
final class MyClassTests {
    // required init() { }
    
    var isFuga: Bool
    
    init() async throws {
        isFuga = true
    }
    
    deinit {
        isFuga = false
    }
    
    @Test func isHoge() {
        #expect(true)
    }
}

// Apple的には（Swiftコンパイラが並行性の安全性をより良く強制することを可能にするので）classよりもactor（or struct）を押している
actor MyActorTests {
    init() { }
    deinit { }
    @Test func isHoge() { #expect(true) }
}

struct SwiftTestingTests2 {
    @Test func isHoge() {
        #expect(2 == 2)
    }
    
    // @Testがないと評価されない
    func isFuga() {
        #expect(4 == 3)
    }
    
    
    @Test func メソッドの最初にtestがなくてもOK() {
        #expect("string" == "string")
    }
    
    // asyncを利用してグローバルアクターに隔離可能
    // XCTestと同じだね
    @Test func isolatedToGlobalActor() async {
        func getTrue() async -> Bool {
            try! await Task.sleep(for: .seconds(0.1))
            return true
        }
        #expect(await getTrue())
    }
    
    // XCTestはデフォルトでメインアクター上の同期テストメソッドを実行していた
    // このライブラリは任意のタスク上で全てのテスト関数を実行する
    @Test() func notMainThread() {
        #expect(!Thread.isMainThread)
    }
    
    // MainThreadで動かすには以下のようにする
    @Test @MainActor func thisIsMainThread1() {
        #expect(Thread.isMainThread)
    }
    
    @Test func thisIsMainThread2() {
        Task { @MainActor
            #expect(Thread.isMainThread)
        }
    }
    
    @Test func thisIsMainThread3() async {
        await MainActor.run { #expect(Thread.isMainThread) }
    }
}



struct MyTest3 {
    // これまでは約40個あるXCTAssert()を使ってきた
    // これからは上記の代わりにexpect(_:_:)とrequire(_:_:)-6lagoの2つを利用する
    // 条件が満たされない場合にはrequire(_:_:)-6lagoがエラーをスローします。
    // nilCheckはこんな感じ
    @Test func nilCheck() throws {
        struct Hoge { var name: String? }
        
        let hoge = Hoge(name: "myName")
        try #require(hoge.name != nil) // 例外を投げる
        // #expect(hoge.name != nil) // 例外を投げない？
    }
    
    // XCTUnwrap()の代替としrequire(_:_:)-3wq2gを使用することができる
    @Test func unwrapName() throws {
        struct Hoge { var name: String? }
        
        let hoge = Hoge(name: "myName")
        let name = try #require(hoge.name)
        #expect(name == "myName")
    }
    
    // XCTFailの代替としてIssue.record()を利用可能
    @Test func issueRecordTest() throws {
        let someBoolValue = true
        guard someBoolValue else {
            Issue.record("someBoolValue is not true")
            return
        }
    }
}


// MARK: - 非同期テスト

struct MyValue {
    var num = 0
    
    
}

@MainActor
final class ViewModel {
    private var intValue = 0
    let handler: (Int) -> Void

    init(handler: @escaping (Int) -> Void) {
        self.handler = handler
    }

    func doSomething() async {
        await doSomethingAsync()
        handler(intValue)
    }

    private func doSomethingAsync() async {
        intValue = 999
    }
}

final class BeforeViewModelTests: XCTestCase {
    func testDoSomething() async throws {
        let exp = expectation(description: #function)
        let viewModel = await ViewModel() { intValue in
            XCTAssertEqual(intValue, 999)
            exp.fulfill()
        }

        await viewModel.doSomething()
        await fulfillment(of: [exp])
    }
    
    @MainActor func testDoSomething2() async throws {
        let exp = expectation(description: #function)
        let viewModel = ViewModel() { intValue in
            XCTAssertEqual(intValue, 999)
            exp.fulfill()
        }

        await viewModel.doSomething()
        await fulfillment(of: [exp])
    }
}

struct AfterViewModelTests {
    @Test func testDoSomething() async throws {
        await confirmation(#function) { confirmation in
            let viewModel = await ViewModel() { intValue in
                #expect(intValue == 999)
                confirmation.confirm()
            }
            
            // ここメソッドの中でTaskを呼ぶとdefreが先に呼ばれるので落ちる
            // confirm()ができるような設計にする必要がある
            await viewModel.doSomething()
        }
    }
}



// MARK: - XCTExpectFailure

// XCTExpectFailureは以下のいずれかに置き換えれる
// - withKnownIssue(_:isIntermittent:fileID:filePath:line:column:_:)-4txq1
// - withKnownIssue(_:isIntermittent:fileID:filePath:line:column:_:)-8ibg4

enum MyError: Error {
    case network
}

func throwError() throws {
    throw MyError.network
}

func throwErrorRandom() throws {
    if Bool.random() { throw MyError.network }
    return
}

class BeforeExpectFailure: XCTestCase {
    func testError() async {
        XCTExpectFailure("なぜかランダムにErrorが発生する😢", options: .nonStrict()) {
            do {
                try throwErrorRandom()
                XCTAssertEqual(100, 100)
            } catch let error { print(error) }
        }
    }
    
    // isEnabledは、既知の問題のマッチングをスキップするためにfalseにできる
    //  たとえば、特定の問題が特定の条件下でのみ発生する場合など
    // issueMatcherは、特定の問題のみを既知としてマークし、他の問題をテストの失敗として記録することを許可するクロージャに設定可能
    func testIsEnableAndIssueMatcher() async {
        let options = XCTExpectedFailure.Options()
        options.isStrict = false
        options.isEnabled = true
        options.issueMatcher = { issue in
            issue.type == .system
        }
        XCTExpectFailure("なぜかランダムにErrorが発生する😢", options: options) {
            do {
                try throwErrorRandom()
                XCTAssertEqual(100, 100)
            } catch let error { print(error) }
        }
    }
}

struct MyTest4 {
    @Test func error() async {
        withKnownIssue("なぜかランダムにErrorが発生する😢", isIntermittent: true) {
            try throwErrorRandom()
            XCTAssertEqual(100, 100)
        }
    }
    
    @Test func testIsEnableAndIssueMatcher() async {
        withKnownIssue("なぜかランダムにErrorが発生する😢", isIntermittent: true) {
            do {
                try throwErrorRandom()
                XCTAssertEqual(100, 100)
            } catch let error { print(error) }
        } when: {
            true 
        } matching: { issue in
            issue.error != nil
        }
    }
}

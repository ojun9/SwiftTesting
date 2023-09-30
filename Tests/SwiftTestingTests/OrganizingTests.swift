import XCTest
import Testing
@testable import SwiftTesting

/// # テストの整理

/// ## 概要

/// 大量のテスト関数を扱う際には、それらをテストスイートに整理することが役立つことがある。

/// テスト関数はいくつかの方法でテストスイートに追加することができる:

/// 0. 他のテスト関数と同じファイルに配置
/// 1. Swiftタイプ内に配置する（struct, actor, class）
/// 2. Swiftタイプ内に配置し、そのタイプに @Suite 属性を注釈する

/// @Suite 属性は、テストライブラリがタイプ内にテスト関数が含まれていることを認識するためには必要ではないが、追加することでテストスイートのIDEおよびコマンドラインでの外観をカスタマイズすることができる。
/// Trait/tags(_:)-yg0i or Trait/disabled(_:fileID:filePath:line:column:) がテストスイートに適用されると、スイート内に含まれるテストに自動で継承される。

/// テスト関数およびSwiftタイプが含む可能性のある任意の他のメンバーを含むことに加えて、テストスイートタイプはまた、それらの中にネストされた追加のテストスイートを含むこともできる。ネストされたテストスイートタイプを追加するには、外部のテストスイートタイプの範囲内で追加のタイプを宣言するだけでよい。

/// ## スイートの名前のカスタマイズ

// テストスイートの名前をカスタマイズするには、`@Suite` 属性に文字列リテラルを引数として提供する:

struct MyValue6 {
    var value: Int?
    
    mutating func setValue(int: Int) {
        value = int
    }
}

@Suite("MyValue6のテスト", .enabled(if: true == true)) struct MyValue6Tests {
    private var myValue: MyValue6!
    
    init() {
        myValue = .init(value: nil)
    }
    @Test func valueがnilである() {
        #expect(myValue.value == nil)
    }
    
    @Test mutating func valueがnilでない() {
        myValue.setValue(int: 23)
        #expect(myValue.value != nil)
    }
}

/// テスト関数の外観と動作をさらにカスタマイズするには、``Trait/tags(_:)-yg0i`` のような[traits](doc:Traits)を使用する。

/// ## テストスイートタイプのテスト関数

/// タイプがインスタンスメソッド（つまり、`static` または `class` キーワードのいずれもない）として宣言されたテスト関数を含む場合、テストライブラリは実行時にそのタイプのインスタンスを初期化し、そのインスタンスでテスト関数を呼び出す。
/// テストスイートタイプに複数のインスタンスメソッドとして宣言されたテスト関数が含まれている場合、それぞれがタイプの異なるインスタンスで呼び出される。

/// したがって、以下のテストスイートおよびテスト関数:


/// めも: であればdeinitは要らない

@Suite struct MyValue6TestsPart2 {
    private let myValue = MyValue6(value: 99)
    
    @Test func valueはnilじゃない() {
        #expect(myValue.value != nil)
    }
}

/// は、以下と同等である:
///

@Suite struct MyValue6TestsPart2_2 {
    private let myValue = MyValue6(value: 99)
    
    func valueはnilじゃない() {
        #expect(myValue.value != nil)
    }
    
    @Test static func static_valueはnilじゃない() {
        let instance = MyValue6TestsPart2_2()
        instance.valueはnilじゃない()
    }
}


/// ## テストスイートタイプに対する制約

/// タイプがテストスイートとして使用される場合、通常適用されないいくつかの制約を受ける。

/// ### 初期化子が必要かもしれない

/// インスタンスメソッドとして宣言されたテスト関数を含む場合、タイプのインスタンスをゼロ引数の初期化子で初期化できる必要がある。初期化子は次の組み合わせである可能性がある:

/// - 暗黙的または明示的
/// - 同期または非同期
/// - スローイングまたはノンスローイング
/// - `private`, `fileprivate`, `internal`, `package`, または `public`.

/// 例えば:


@Suite struct FoodTruckTests {
    var batteryLevel = 100
    
    @Test func foodTruckExists() {  } // ✅ OK: type has implicit init()
}

@Suite struct CashRegisterTests {
    private init(cashOnHand: Decimal = 0.0) async throws { }
    
    @Test func calculateSalesTax() { } // ✅ OK: type has callable init()
}

/// 引数が存在するのでアウト
//struct MenuTests {
//    var foods: [Int]
//    var prices: [Int: Decimal]
//    
//    init(foods: [Int], prices: [Int : Decimal]) {
//        self.foods = foods
//        self.prices = prices
//    }
//    
//    @Test static func specialOfTheDay() { } // ✅ OK: function is static
//    @Test func orderAllFoods() { } // ❌ ERROR: suite type requires init()
//}


/// この要件を満たさないテストスイートが提示されると、コンパイラはエラーを発行する。


/// ### テストスイートタイプは常に利用可能でなければならない

/// `@available`は実行時にテスト関数の利用可能性を制限するために適用できるが、テストスイートタイプ（およびそれを含む任意のタイプ）は `@available` 属性で注釈されてはいけない:


@Suite struct MyTests3 { } // ✅ OK: タイプは常に利用可能

/// @available(iOS 16.0, *) // ❌ ERROR: スイートタイプは常に利用可能でなければならない
@Suite struct MyTests4 { }

/// @available(iOS 16.0, *)
struct MyTests5 {
    // ❌ ERROR: スイートタイプの
    // 内包タイプも常に利用可能でなければならない
    @Suite struct someTests { }
}


/// この要件を満たさないテストスイートが提示されると、コンパイラはエラーを発行する。

/// - バグ: ``Suite(_:)``および``Suite(_:_:)``マクロの展開中にコンパイラは常に継承された利用可能性を表示しない。
/// テスト関数はサポートされていないシステムで実行されるとクラッシュする可能性がある。 ([110974351](rdar://110974351))

/// ### クラスはfinalでなければならない

/// テストライブラリは現在、テストスイートタイプ間での継承をサポートしていない。
/// クラスがテストスイートタイプとして使用される場合、他のクラスから継承できるが、`final`として宣言されなければならない:


/// @Suite final class FoodTruckTests { ... } // ✅ OK: クラスはfinalである
/// actor CashRegisterTests: NSObject { ... } // ✅ OK: actorsは暗黙的にfinalである
/// class MenuItemTests { ... } // ❌ ERROR: このクラスはfinalではない


/// - バグ: この要件の違反はコンパイル時に一貫して診断されず、問題が検出された場合に生成される診断は開発者にとって混乱する可能性がある。 ([105470382](rdar://105470382))

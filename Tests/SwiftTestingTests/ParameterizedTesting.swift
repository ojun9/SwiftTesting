import XCTest
import Testing


/// # パラメータ化されたテスト

/// 異なる入力で同じテストを複数回実行する。

/// ## 概要

/// いくつかのテストは多くの異なる入力に対して実行する必要がある。
/// たとえば、テストは列挙のすべてのケースを検証する必要があるかもしれない。
/// テストライブラリは、開発者がテスト中に反復する1つまたは複数のコレクションを指定でき、これらのコレクションの要素がテスト関数に転送されるようにする。

/// ## 値の配列を超えてパラメータ化する

/// 配列に含まれるテストする値に対してテストをn回実行したいというのは非常に一般的な要望である。
/// 次のテスト関数を考えてみよう:



enum MyFood: CaseIterable {
    case burger, iceCream, burrito
    
    func cook() async -> Bool {
        return true
    }
    
    func cook(count: Int) async -> Bool {
        return true
    }
}

@Test("All foods available")
func foodsAvailable1() async throws {
    for food: MyFood in [.burger, .iceCream, .burrito] {
        #expect(await food.cook())
    }
}


/// このテスト関数が配列内の値のいずれかで失敗すると、どの値が失敗したのか不明確になる可能性がある。
/// 代わりに、テスト関数は様々な入力で_parameterized over_されることができる:

@Test(
    "All foods available", 
    arguments: [MyFood.burger, .iceCream, .burrito]
)
func foodAvailable2(_ food: MyFood) async throws {
    #expect(await food.cook())
}


/// コレクションがパラメータ化のために`@Test`属性に渡されると、テストライブラリはコレクションの各要素をテスト関数に一度に1つずつ渡し、その要素をテスト関数の最初（および唯一）の引数として渡す。
/// そして、テストが1つまたは複数の入力で失敗すると、対応する診断はどの入力を調査する必要があるかを明確に示すことができる。


/// ## 列挙のケースを超えてパラメータ化する

/// 上記の例では、テストする`Food`のケースのリストをハードコードしました。
/// `Food`が`CaseIterable`に準拠している列挙である場合、代わりに以下のように記述できます:



@Test("All foods available", arguments: MyFood.allCases)
func foodAvailable3(_ food: MyFood) async throws {
    #expect(await food.cook())
}


/// このようにすると、`Food`列挙に新しいケースが追加されると、このテスト関数によって自動的にテストされるようになります。

/// ## 整数の範囲を超えてパラメータ化する

/// 閉じた整数の範囲を超えてテスト関数をパラメータ化することは可能です:


@Test("Can make large orders", arguments: 1 ... 100)
func makeLargeOrder(count: Int) async throws {
    let food = MyFood.iceCream
    #expect(await food.cook(count: count))
}


/// - 注意: `0 ..< .max`のような非常に大きな範囲はテストに過度の時間を要するか、またはリソースの制約のために完了しない可能性があります。

/// ## 複数のコレクションをテストする

/// 複数のコレクションをテストすることも可能です。以下のテスト関数を考えてみましょう。


@Test("Can make large orders", arguments: MyFood.allCases, 1 ... 100)
func makeLargeOrder2(of food: MyFood, count: Int) async throws {
    print(food, count)
    #expect(await food.cook(count: count))
}


/// 最初のコレクションの要素はテスト関数の最初の引数として渡され、2つ目のコレクションの要素は2つ目の引数として渡され、以降同様になります。

/// `Food`列挙型に5つのケースがあると仮定すると、このテスト関数は実行時に食べ物と注文サイズのすべての可能な組み合わせで 5 × 100 = 500 回呼び出されるでしょう。
/// これらの組み合わせは、コレクションの[デカルト積](https://en.wikipedia.org/wiki/Cartesian_product)と呼ばれます。

/// 上記の組み合わせ論理を避けるには、[`zip()`](https://developer.apple.com/documentation/swift/zip(_:_:))を使用します:


@Test("Can make large orders zip", arguments: zip(MyFood.allCases, 1 ... 100))
func makeLargeOrder3(of food: MyFood, count: Int) async throws {
    print(food, count)
    #expect(await food.cook(count: count))
}


/// ジップされたシーケンスは自動的に2つの引数に「分解」され、評価のためにテスト関数に渡されます。

/// この修正されたテスト関数は、ジップされたシーケンス内の各タプルに対して一度だけ呼び出され、500回の呼び出しではなく、合計5回の呼び出しになります。
/// 言い換えれば、このテスト関数は `(.burger, 1)`, `(.burger, 2)`, `(.burger, 3)`, ... `(.kebab, 99)`, `(.kebab, 100)` の代わりに、`(.burger, 1)`, `(.iceCream, 2)`, ..., `(.kebab, 5)` の入力を渡されることになります。

import XCTest
import Testing
@testable import SwiftTesting


/// テスト実行前に個々のテストを条件付きで有効または無効にする。

/// ## 概要

/// 多くの場合、テストは特定の状況でのみ適用されることがある
/// 例えば、特定のハードウェア機能を持つデバイス上でのみ実行されるテストを書く、またはロケール依存の操作を実行するテストを書くことがある
/// テスティングライブラリは、これらの条件が満たされていない場合にランナーが自動的にテストをスキップするように、テストにトレイトを追加することを可能にする

/// - 注意: 条件はテスト中に複数回評価されることがある

/// ## テストの無効化

/// テストを無条件に無効にする必要がある場合は、Trait/disabled(_:fileID:filePath:line:column:) 関数を利用する
/// 以下のテスト関数が与えられた場合：



@Test("テストをするよ1")
func isPiyo1() async throws {
}


/// テストの表示名の 後 にトレイトを追加する
/// テストは常にスキップされるようになる

@Test(".disabled()を追加するとテストはスキップされるよ", .disabled())
func isPiyo2() async throws {
}


/// また、トレイトにコメントを追加し、ランナーがテストをスキップするときにランナーの出力に表示されるようにすることも可能

@Test(
    ".disabled()の中にコメントを入れるとスキップ理由になるよ",
    .disabled("眠たいからスキップする")
)
func isPiyo3() async throws {
}


/// ## テストの条件付き有効化または無効化

/// 時として、条件が満たされた場合にのみテストを有効にするのが理にかなっている



@Test("アイスクリームは冷たい1")
func isCold1() async throws { }


/// 現在が冬である場合、おそらくアイスクリームは販売されていないため、このテストは失敗する
/// したがって、現在が夏である場合にのみこれを有効にするのが理にかなっている
/// テストを条件付きで有効にするには、``Trait/enabled(if:_:fileID:filePath:line:column:)`` を使用する

enum Season {
    case summer, winter
    static var current: Season = .summer
}

@Test("enableの中がtrueならtestは実行される", .enabled(if: Season.current == .summer))
func isCold2() async throws { }


/// また、テストを条件付きで _無効化_ し、複数の条件を組み合わせることも可能です：


@Test(
  "disabledが設定されるとテストはスキップされる",
  .enabled(if: Season.current == .summer),
  .disabled("無効にする")
)
func isCold3() async throws { }

/// テストが対応するバグ報告のための問題で無効にされている場合、
/// 関係``Bug/Relationship-swift.enum/failingBecauseOfBug``
/// とともに``Trait/bug(_:relationship:)-duvt``
/// または``Trait/bug(_:relationship:)-40riy``関数を使用できます：


@Test(
  "bugの情報を付与することが可能",
  .enabled(if: Season.current == .summer),
  .disabled("無効にする"),
  .bug("#12345", relationship: .failingBecauseOfBug)
)
func isCold4() async throws { }


/// テストに複数の条件が適用されている場合、それらは _すべて_ パスする必要があります。それ以外の場合、最初に失敗した条件がテストがスキップされた理由として注記されます。


/// ## 複雑な条件の取り扱い

/// 条件が複雑な場合、読みやすさを向上させるためにヘルパー関数に分けることを検討する


struct MyValue5 {
    let value: Int
}

func allIngredientsAvailable(for myValue: MyValue5) -> Bool { return true}

@Test(
  "Can make sundaes",
  .enabled(if: Season.current == .summer),
  .enabled(if: allIngredientsAvailable(for: MyValue5(value: 999)))
)
func makeSundae() async throws { }


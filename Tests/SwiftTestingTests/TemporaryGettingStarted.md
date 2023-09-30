# Getting started

新しいテストターゲット、または既存のXCTestベースのテストターゲットでテストの実行を開始します。

## 概要

テストライブラリはまだSwift Package Managerに統合されていませんが、開発者がSwiftパッケージと一緒に使用を開始したい場合のための一時的なメカニズムが提供されています。

- 警告: この機能は、Swift Package Managerなどの既存のツールとテストライブラリを統合するために一時的に提供されています。将来のリリースで削除される予定です。

テストライブラリ自体に貢献する方法を学ぶには、[`swift-testing`への貢献](https://github.com/apple/swift-testing/blob/main/CONTRIBUTING.md)を参照してください。

### テストスカフォルディングの追加

パッケージのテストターゲットに "Scaffolding.swift" という名前の新しいSwiftソースファイルを追加します。次の内容を追加します:

```swift
import XCTest
import Testing

final class AllTests: XCTestCase {
  func testAll() async {
    await XCTestScaffold.runAllTests(hostedBy: self)
  }
}
```

これで、パッケージのテストターゲットに追加のSwiftソースファイルを追加し、コマンドラインから `swift test` を実行するか、XcodeのProduct&nbsp;&rarr;&nbsp;Testメニューアイテムをクリックするときに実行したいテストをテストライブラリを使用して書くことができます。

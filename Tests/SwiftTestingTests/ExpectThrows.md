#  テストでのエラーや問題を検証する

テストコードがエラーをスローするタイミングと方法を検証します。

## 概要

テストの一部として、エラーがスローされること（またはエラーがスローされないこと）を検証することがしばしば必要です。テストライブラリは、これらのアクションを実行するために使用できる`#expect()`および`#require()`マクロのいくつかのオーバーロードを提供しています。

テストライブラリはまた、`withKnownIssue()`という関数を提供しており、この関数は既知の問題としてマークするために使用できます。言い換えれば、テストが問題を記録することが知られている、問題を断続的に（"flaky"なテスト）記録する可能性がある、または不完全なアプリケーションコードをテストする場合、この関数はランタイムでテストライブラリにそれらの問題が発生したときにテストを失敗としてマークしないように通知するために使用できます。

## Topics

### エラーがスローされることを検証する

- ``expect(throws:_:performing:)-2j0od``
- ``expect(throws:_:performing:)-1s3lx``
- ``expect(_:performing:throws:)``
- ``require(throws:_:performing:)-8762f``
- ``require(throws:_:performing:)-84jir``
- ``require(_:performing:throws:)``

### エラーがスローされないことを検証する

- ``expect(throws:_:performing:)-jtjw``
- ``require(throws:_:performing:)-4a80i``

### テストで既知の問題を記録する

- ``withKnownIssue(_:isIntermittent:fileID:filePath:line:column:_:)-4txq1``
- ``withKnownIssue(_:isIntermittent:fileID:filePath:line:column:_:)-8ibg4``
- ``withKnownIssue(_:isIntermittent:fileID:filePath:line:column:_:when:matching:)-3n2cc``
- ``withKnownIssue(_:isIntermittent:fileID:filePath:line:column:_:when:matching:)-5bsda``
- ``Issue``
- ``KnownIssueMatcher``

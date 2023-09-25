#  期待を使って動作を検証する

テストで期待される値や結果を確認する。

## 概要

テストでは、期待を使用して動作を検証することができます。このページでは、さまざまな組み込み期待APIについて説明します。

## Topics

### 期待を使用して動作を検証する

- ``expect(_:_:)``
- ``require(_:_:)-6lago``
- ``require(_:_:)-3wq2g``

### 確認を使って非同期動作を検証する

- ``Confirmation``
- ``confirmation(_:expectedCount:fileID:filePath:line:column:_:)``

### テストでのエラーや問題を検証する

- <doc:ExpectThrows>

### チェックされた期待に関する情報を取得する

- ``Expectation``
- ``ExpectationFailedError``
- ``SourceCode``

### ソース位置を表現する

- ``SourceLocation``
- ``SourceContext``
- ``Backtrace``

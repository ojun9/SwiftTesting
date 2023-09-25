# テストに特性を追加する

テストに注釈を付けたり、動作をカスタマイズしたりするために特性を追加します。

## 概要

この記事では、「Trait」、「TestTrait」、「SuiteTrait」プロトコルについて説明し、テストライブラリによって提供される特性をリストし、それらを作成するために使用できる関数をリストします。

「Trait」、「TestTrait」、「SuiteTrait」プロトコルは、テスト関数とテストスイートの動作をカスタマイズするタイプを定義するために使用されます。

## Topics

### テストの条件を定義する

- <doc:EnablingAndDisabling>
- ``Trait/enabled(if:_:fileID:filePath:line:column:)``
- ``Trait/enabled(_:fileID:filePath:line:column:_:)``
- ``Trait/disabled(_:fileID:filePath:line:column:)``
- ``Trait/disabled(if:_:fileID:filePath:line:column:)``
- ``Trait/disabled(_:fileID:filePath:line:column:_:)``
- ``ConditionTrait``

### テストにタグを追加する

- ``Trait/tags(_:)-yg0i``
- ``Trait/tags(_:)-272p``
- ``Tag``
- ``Tag/List``

### テストにコメントを追加する

- <doc:AddingComments>
- ``Trait/comment(_:)``
- ``Comment``

### テストから問題やバグレポートを参照する

- <doc:AssociatingBugs>
- <doc:BugIdentifiers>
- ``Trait/bug(_:relationship:)-duvt``
- ``Trait/bug(_:relationship:)-40riy``
- ``Bug``

### テストの実行時間を制限する

- ``TimeLimitTrait``
- ``Trait/timeLimit(_:)``

### カスタム特性を作成する

- ``Trait``
- ``TestTrait``
- ``SuiteTrait``

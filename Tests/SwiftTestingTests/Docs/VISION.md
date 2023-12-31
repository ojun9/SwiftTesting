# Swiftにおけるテストの新しいAPIの方向性

## はじめに

任意の開発者プラットフォームの成功のための主要な要件は、ソフトウェアの欠陥を特定するための自動テストを使用する方法です。テストのためのより優れたAPIとツールは、プラットフォームの品質を大幅に向上させることができます。以下では、Swiftでのテストのための新しいAPI方向を提案します。

まず基本的な原則を定義し、それらの原則を具現化する特定の機能を説明します。次に、いくつかの設計上の考慮事項を詳しく議論します。最後に、Swiftで全く新しいテストAPIを提供するための具体的なアイデアを提示し、それらを考慮された代替案と比較します。

## 原則

Swiftでのテストは、新しいプログラマと経験豊富なエンジニアの両方にとって**アプローチ可能**でなければなりません。学ぶべきAPIは少なく、それらはエルゴノミックでモダンに感じるべきです。新しいテストを徐々に追加することは簡単であり、テストは人々が毎日知っていて使用しているツールとワークフローにシームレスに統合されるべきです。

良いテストは**表現力**があり、失敗時には自動的に実行可能な情報を含むべきです。明確な名前と目的を持ち、テストの表現とメタデータをカスタマイズする設備が提供されるべきです。可能な限り、テストの詳細はコード内のテストで指定されるべきです。

テストライブラリは**柔軟**であり、多くのニーズを満たすことができるべきです。関連するテストをグループ化することが有益な場合はそれを可能にし、またはそれらをスタンドアロンにすることができます。必要に応じてテストの動作をカスタマイズする方法があり、適切なデフォルトがあるべきです。テスト中に一時的にデータを保存することは可能で安全であるべきです。

現代のテストシステムは、**拡張性**を念頭に置いており、大規模なテストスイートを円滑に処理するべきです。デフォルトでテストを並行して実行し、一部のテストをオプトアウトできるようにするべきです。異なる入力でテストを繰り返し、詳細な結果を見ることが簡単であるべきです。ライブラリは軽量で効率的であり、テストされるコードに最小限のオーバーヘッドを課すべきです。

## 優れたテストAPIの特徴

これらの原則に導かれて、新しいテストAPIを設計する際に考慮する重要な特徴が多くあります。

### アプローチ可能性

* **学習および使用が簡単であること**: 個別のAPIは覚えるべきものが少なく、それらは十分なドキュメントがあり、新しいテストを書くのに迅速でシームレスであるべきです。摩擦が少なければ少ないほど、多くのテストが書かれる可能性が高くなります。
* **期待される動作または結果を検証すること**: 任意のテストライブラリの最も重要

な役割は、コードが特定の期待を満たしていることを確認することです。たとえば、関数が期待される結果を返すことを確認するか、2つの値が等しいことを確認することです。これには、コレクション全体を比較する、またはエラーをチェックするなど、多くの興味深いバリエーションがあります。堅牢なテストAPIはこれらのすべてのニーズを満たすべきであり、API自体はエルゴノミックであり、Swiftの[API設計ガイドライン](https://www.swift.org/documentation/api-design-guidelines/)に準拠しているべきです。
* **インクリメンタルな採用を可能にする**: XCTestや他のテストライブラリを現在使用しているプロジェクトと無理なく共存し、ユーザーが自分のペースで移行できるようにインクリメンタルな採用を可能にするべきです。これは特に、この新しいAPIが機能のパリティを達成するまでに時間がかかる可能性があるため、非常に重要です。
* **ツール、IDE、およびCIシステムとの統合**: 便利なテストライブラリには、テストのリスト表示と選択、ランナープロセスの起動、および結果の収集などの機能に関するサポートツールが必要です。これらの機能は、一般的なIDE、SwiftPMの`swift test`コマンド、および継続的インテグレーション(CI)システムとシームレスに統合されるべきです。

### 表現力

* **詳細で実行可能な失敗情報を含める**: テストは、バグをキャッチして失敗し、最も価値のある提供を提供しますが、失敗が実行可能であるためには十分に詳細である必要があります。テストが失敗すると、それは可能な限り多くの関連情報を収集し表示するべきです、特にそれが信頼できる方法で再現できない可能性があるためです。
* **柔軟な命名、コメント、およびメタデータを提供する**: テストの著者は、テストのプレゼンテーションの方法をカスタマイズできるように、それらに情報を提供する名前、コメント、または共通のものを持っているテストにラベルを割り当てるメタデータを指定できるべきです。
* **動作をカスタマイズできるようにする**: 一部のテストには共通のセットアップまたはティアダウンロジックが共有されており、各テストまたはグループごとに一度実行する必要があります。他の場合、テストは関連性のない理由で失敗し始め、一時的に無効にする必要があります。一部のテストは特定のデバイスタイプであるか、外部リソースが利用可能な場合にのみ実行する意味があります。現代のテストシステムは、これらのすべてのニーズを満たすのに十分な柔軟性を持つべきであり、より単純な使用例を複雑にしないようにするべきです。

### 柔軟性

* **テストをグループにまとめる（またはまとめない）ことを許可する:** 多くの場合、コンポーネントは関連する複数のテストを持っており、これらをまとめることが理にかなっています。テストを階層にグループ化することが可能でありながら、単純なテストをスタンドアロンで保持することを可能にする必要があります。
* **テストごとのストレージをサポートする:** テストは実行中にデータを保存する必要があり、ローカル変数は常に十分ではありません。たとえば、テストのセットアップロジックがテストでアクセスする必要がある値を作成する可能性がありますが、これらは異なるスコープにあります。テストごとのデータを慎重に保存する方法が必要であり、それが単一のテストに隔離され、予期せぬ依存関係や失敗を避けるために確実に初期化されることを確実にする必要があります。
* **テストイベントの監視を許可する:** 一部のユースケースでは、テストイベントを監視する機能が必要です—たとえば、結果のカスタムレポート作成や分析を行うためです。テストライブラリは、イベント処理のためのAPIフックを提供する必要があります。

### スケーラビリティ

* **実行を並列化する:** 多くのテストは、実行時間を改善するために並列に実行できます。これは、単一のプロセス内で複数のスレッドを使用するか、複数のランナープロセスを使用するかのいずれかです。テストライブラリは、適格なテストのために柔軟な並列化オプションを提供し、可能な限り並列化を奨励し、この動作に対する粒度の高い制御を提供する必要があります。また、データ競合の安全機能（`Sendable`の強制など）を可能な限り最大限に活用し、並行処理のバグを回避する必要があります。
* **異なる引数でテストを複数回繰り返す:** 多くのテストは、マイナーなバリエーションを持つテンプレートで構成されています—たとえば、異なる引数を使用して関数を複数回呼び出し、各呼び出しの結果を検証する、といったものです。テストライブラリは、このパターンを簡単に適用できるようにし、単一の引数中の失敗が明確に表現されるように、詳細な報告を含める必要があります。
* **プラットフォーム間で一貫して動作する:** 新しいテストソリューションは、その概念設計からクロスプラットフォームであり、Swiftがサポートするすべてのプラットフォームをサポートする必要があります。観察可能な動作は、特にテストの発見と実行などのコアな責務に関して、これらのプラットフォーム間で可能な限り一貫しているべきです。

## 設計に関する考慮事項

新しいテストAPIを設計する際には、いくつかの領域を詳しく検討する必要があります。理想的な体験を提供するために言語やコンパイラツールチェーンの強化が得られる可能性があるため、および非明示的な推論や要件を持つため、いくつかの領域があります。

### 期待値

テストライブラリは通常、値を比較するAPIを提供しています—例えば、関数が期待される結果を返すことを確認するためや、比較が成功しない場合にテスト失敗を報告するためです。ライブラリによっては、これらのAPIは「アサーション」、「期待値」、「チェック」、「要件」、「マッチャー」、または他の名前で呼ばれることがあります。このドキュメントでは、これらを**期待値**と呼んでいます。

テストの失敗が対処可能であるためには、問題を理解するのに十分な詳細を含める必要があり、理想的には人間が手動で失敗を再現しデバッグすることなくです。期待値の失敗に関連する最も重要な詳細は、比較またはチェックされる値と、実行されている期待値の種類（例: 等しい、等しくない、未満、nilでない、など）です。また、期待値に渡された式を評価する際にエラーがキャッチされた場合は、それも含めるべきです。

評価された式の値を超えて、期待値のAPIにキャプチャして含めると便利な他の情報があります:

* 期待値の**ソースコードの位置**は通常、`#file:#line:#column` の形式を使用しています。これにより、テストの作成者はコードの行に素早くジャンプしてコンテキストを表示することができ、IDEはその位置でUIに失敗を表示することができます。
* 期待値に渡された**式のソースコードテキスト**。例として、期待値APIのコール `myAssertEqual(subject.label == "abc")` のソースコードテキストは、文字列 `"subject.label == \"abc\""` になります。
  
  ソースコードテキストは、IDEで失敗を表示する際にコードが存在するため必要ではないかもしれませんが、それが最近変更された場合に評価されたソースコードが期待通りであったことを確認するのに便利です。これはCIウェブサイトやソースがない場所で失敗が表示される場合にさらに便利であり、（この例での `subject.label` などの）サブ式は失敗に関する有用な手がかりを提供する可能性があります。
* **カスタムユーザー指定のコメント**。コメントは、テスト作成者がコンテキストや失敗が発生した場合にのみ必要な情報を追加するのに便利です。通常は短く、テストライブラリからのテキストログ出力に含まれます。
* **カスタムデータやファイルの添付**。一部のテストではファイルやデータ処理が関与し、期待値が任意のデータやファイルを結果に保存して後で分析することを許可することで利益を得る可能性があります。

#### 力強く、しかしシンプルに

期待値の失敗メッセージに含める最も重要な詳細は、比較される式や式の種類であるため、いくつかのテストライブラリは詳細な報告のために多くの特化したAPIを提供しています。以下は、他の著名なテストライブラリからのいくつかの期待値APIです：

| | Java (JUnit) | Ruby (RSpec) | XCTest |
|----|----|----|----|
| 等しい | `assertEquals(result, 3);` | `expect(result).to eq(3)` | `XCTAssertEqual(result, 3)` |
| 同一である | `assertSame(result, expected);` | `expect(result).to be(expected)` | `XCTAssertIdentical(result, expected)` |
| 以下である | N/A | `expect(result).to be <= 5` | `XCTAssertLessThanOrEqual(result, 5)` |
| null/nilである | `assertNull(actual);` | `expect(actual).to be_nil` | `XCTAssertNil(actual)` |
| 例外を投げる | `assertThrows(E.class, () -> { ... });` | `expect {...}.to raise_error(E)` | `XCTAssertThrowsError(...) { XCTAssert($0 is E) }` |

多くの特化した期待値APIを提供することは、既存のライブラリの間で一般的な慣行です：XCTestは[`XCTAssert`ファミリー](https://developer.apple.com/documentation/xctest/boolean_assertions)で40以上のAPIを持っており; JUnitには[数十のAPI](https://junit.org/junit5/docs/5.0.1/api/org/junit/jupiter/api/Assertions.html)があり、RSpecにはテストマッチャーの[大きなDSL](https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers)があります。

このアプローチは直接的な報告を可能にするものの、拡張性がありません:

* 新しいユーザーに多くの新しいAPIを学ばせ、それぞれの状況で正しいものを使うことを覚えてもらうことで、学習曲線が増加し、または不明瞭なテスト結果が得られるリスクがあります。
* より複雑な使用例がサポートされていない可能性があります—例えば、`Sequence`が`starts(with:)`を使用していくつかの接頭辞で始まることをテストする期待値APIがない場合、ユーザーは結果が実用的であるためにシーケンスを含むカスタムコメントを追加するなどの回避策が必要かもしれません。
* テストライブラリのメンテナは、多くの使用例をサポートする特注のAPIを追加する必要があり、これによりメンテナンスの負担が生じます。
* 正確な関数の署名に依存して、型チェックを複雑にする追加のオーバーロードが必要になる場合があります。

私たちは、期待値はできるだけシンプルであるよう努め、少数の明確なAPIを含むが、すべての式に対して詳細な結果を含めるのに十分に強力であるべきだと信じています。多くの特化した期待値APIを提供するのではなく、APIは一般的であり、すべての使用例をカバーするために組み込みの言語演算子とAPIに依存するべきです。

#### 評価ルール

期待値は、引数を取り扱う際に慎重に守らなければならない特定のルールがあります：

* チェックされる主要な式は正確に一度だけ評価されるべきです。特に、期待値が満たされなかった場合、評価された任意の式の値を示すことは、式が2回目に評価される原因となるべきではありません。これは、複数の評価の望ましくないまたは予期しない副作用を避けるためです。
* カスタムコメントやメッセージは、期待値が満たされなかった場合にのみ、そして最も多くても一度だけ評価されるべきであり、同様に望ましくない副作用を避け、不必要な作業を防ぐためです。

#### 失敗後の継続

単一のテストには複数の期待値が含まれている場合があり、テストライブラリはその期待値の1つが失敗した後にテストを実行し続けるかどうかを決定する必要があります。いくつかのテストは、以前の期待値が失敗したとしても完了するまで常に実行することで利益を得ることがあり、それらは異なるものを検証し、早期の期待値は後のものとは無関係です。他のテストは、後のロジックが前の期待値の結果に大きく依存しているように構築されているため、期待値が失敗した後にテストを終了すると時間を節約できます。また、他のテストではハイブリッドアプローチを取り、特定の期待値のみが必要であり、失敗時にテストの実行を終了するべきです。

これはポリシーの決定事項であり、テストライブラリはユーザーがグローバル、テストごと、または期待値ごとにこれを制御できるようにする可能性があります。

#### 評価された値のリッチな表現

しばしば、期待値APIは、失敗を報告する際に生の式の値を保持せず、代わりに報告目的のためにこれらの値の文字列表現を生成します。文字列表現はしばしば十分ですが、期待値APIが特定の、既知のデータタイプの値を保持できるようになれば、失敗のプレゼンテーションは向上する可能性があります。

例として、仮想の期待値APIコール`ExpectEqual(image.height, 100)`を想像してみてください。ここで`image`はいくつかのよく知られたグラフィカルな画像タイプ`UILibrary.Image`の値です。これは既知のデータタイプを使用しているため、期待値APIは失敗時に`image`を保持し、テスト結果に含める可能性があり、その後、IDEや他のツールが画像をグラフィカルに表示し、診断を容易にすることができます。この機能は、テストライブラリの既知のデータタイプの1つに任意の値を変換する方法を説明するプロトコルを使用することで拡張可能でクロスプラットフォームになる可能性があり、一般に使用されるタイプに対する期待値の結果のプレゼンテーションを大幅に向上させることができます。

### テストの特性

上記で議論されたいくつかの機能における繰り返されるテーマは、個々のテストやテストグループ

に関する追加情報やオプションを表現する必要性です。いくつかの例は以下のとおりです：

* テストの要件を記述するか、テストを無効にマークする。
* タグやラベルをテストに割り当て、共通点を持つものを見つけたり実行したりする。
* パラメータ化されたまたは「データ駆動型」のテストのための引数値を宣言する。
* テストの前後に共通のロジックを実行する。

これらはこのドキュメントでは**特性**としてまとめて参照されています。個々のテストの特性は、テスト定義とは別のスタンドアロンのファイルに格納される_可能性がありますが_、別のファイルに依存することには既知のデメリットがあります。それはテスト名が変更された場合に同期が取れなくなる可能性があり、重要な詳細（テストが無効であるか特定の要件を持っているかなど）が別々に格納されている場合、それらを見落とすのは簡単です。

私たちは、単一のテストの特性は、これらの問題を避けるために、可能な限りテストを記述するのに近い場所に置かれたコード内に宣言されるべきであると考えています。しかし、グローバル設定は、コード内に配置する正規の場所がない場合、外部ファイルを介した設定から依然として利益を得ることができるかもしれません。

#### 特性の継承

関連するテストをグループ化する際に、テスト特性が個々のテストとそのテストを含むグループの両方で指定されている場合、どのオプションが優先されるかは不明確になる可能性があります。テストライブラリは、この問題を解決するための方針を確立する必要があります。

テスト特性は継承の振る舞いの観点から異なるカテゴリに分類される可能性があります。いくつかは、ユーザーが合理的に合計されると期待する複数の値を意味的に表します。例えば、テスト要件: グループが1つの要件を指定し、そのテスト関数が別の要件を指定する場合、両方の要件が満たされている場合にのみテスト関数を実行する必要があります。これらの要件が評価される順序は考慮され、正式に指定される価値があり、ユーザーは要件が常に“外側から内側”またはその逆で評価されることを確信できます。

別の例はテストタグです：これらも多値と見なされますが、タグが付けられた項目は通常、`Array`ではなく`Set`セマンティクスを持ち、重複を無視することが期待されているため、このタイプの特性では評価順序は重要ではありません。

他のテスト特性は、セマンティックに単一の値を表し、それらの間の競合は解決が難しい場合があります。仮定として、`.enabled(Bool)`と呼ばれるテスト特性を想像してみてください。これには、テストが実行されるべきかどうかを決定する`Bool`が含まれています。グループが`.enabled(false)`を指定し、そのテスト関数の1つが`.enabled(true)`を指定する場合、どちらの値が尊重されるべきでしょうか？どちらの方針にも根拠があるかもしれません。

可能であれば、曖昧さを避ける方が簡単かもしれません：前の例では、`.disabled`オプションのみを提供し、その逆を提供しないことでこの問題を解決できるかもしれません。しかし、各オプションの継承セマンティクスを考慮し、曖昧さが避けられない場合は、それを解決する方針を確立し、文書化するべきです。

#### 特性の拡張性

柔軟なテストライブラリは、テスト作成者による特定の動作の拡張を許可する必要があります。一般的な例は、テストの前後にロジックを実行することです。特定のグループ内のすべてのテストに同じステップが前もって必要な場合、それらのステップはそのグループ内の単一のメソッドに配置でき、特定のテストにオプションとして表現される必要はありません。ただし、グループ内のごく一部のテストのみがこれらのステップを必要とする場合、テスト特性を利用してこれらのテストを個別にマークするのが理にかなっています。

テスト特性は、このワークフローをサポートする動作の拡張を提供する能力を持たなければなりません。例えば、カスタムテスト特性を定義し、テストやグループの前後にカスタムコードを実行するためのフックを実装することが可能であるべきです。

### テストの識別

いくつかの機能はテストを一意に識別する能力を必要とし、個々のテストを実行する選択や結果のシリアル化などがあります。また、テストの本体内でテスト名にアクセスすることや、テストイベントを観察するエンティティがテスト名をクエリすることも有用かもしれません。

テストライブラリには、テストを一意に識別するための堅牢なメカニズムが含まれている必要があり、識別子はテストの実行ごとに安定している必要があります。テストの表示名をカスタマイズすることが可能である場合、テストライブラリは、どの名前が権威あるものであり、一意の識別子に含まれるものであるかを決定する必要があります。また、関数のオーバーロードは、追加の型情報なしに特定のテスト関数名が曖昧になる可能性があります。

### テストの発見

全ての言語のテストライブラリにとって頻繁に挑戦となるのは、テストを実行するためにそれらを探し出す必要があることです。ユーザーは通常、テストが自動的に発見されることを期待しており、維持負担となる包括的なリストを提供する必要はないと考えています。

特に異なる目的を果たす3つのテスト発見タイプを考慮する価値があります：

* **ランタイム時:** テストランナープロセスが起動されたとき、テストライブラリはテストを探し出して実行する必要があります。
* **ビルド後:** すべてのテストコードのコンパイルが成功して完了したが、テストランナープロセスが起動されていない状態で、テストビルド製品を内省し、テストのリストを印刷したり、それらに関する他のメタデータを実行せずに抽出したりするツールが便利かもしれません。
* **作成中:** テストが作成または編集された後、しかしビルドが完了する前に、IDEや他のツールがコードを静的に分析またはインデックスし、UIにそれらをリストし、実行を許可するためにテストを探し出すことが一般的です。

これらはそれぞれ重要であり、異なる解決策が必要になるかもしれません。

#### ランタイム外の発見

上記のテスト発見タイプの2つ—_ビルド後_ と _作成中_—は、ランナープロセスを起動せず、そしてテストライブラリのランタイムロジックとモデルを使用せずにテストを発見する能力を必要とします。上記で言及したIDEのユースケースに加えて、静的にテストを発見することが便利なもう1つの理由は、CIシステムがテストに関する情報を抽出し、物理デバイス上のテスト実行スケジューリングを最適化するために使用できるようにすることです。CIシステムは、ターゲットとしているプラットフォームと異なるホストOSで実行されることが一般的であり—たとえば、iOSデバイス用のテストをビルドするIntel Mac—これらの状況では、CIシステムがこの情報を収集するためにランナープロセスを起動することが非現実的または高価になる可能性があります。

すべてのテストの詳細が静的に抽出可能であるわけではないことに注意してください：ランタイムテスト動作を可能にするものはそうでないかもしれませんが、些細なメタデータ（テストの名前や無効化されているかどうかなど）は抽出可能であるべきであり、特にSwiftの[ビルド時定数値](https://github.com/apple/swift-evolution/blob/main/proposals/0359-build-time-constant-values.md)のサポートがさらに進化すると特にそうです。新しいテストAPIを設計する際には、これらのランタイム外の発見ユースケースをサポートするためにどのテストメタデータが静的に抽出可能であるべきかを検討することが重要です。

### パラメータ化されたテスト

異なる引数でテストを複数回繰り返す—正式には[パラメータ化またはデータ駆動テスト](https://en.wikipedia.org/wiki/Data-driven_testing)と呼ばれています—は、最小限のコードの繰り返しでより多くのシナリオをカバーするテストカバレッジを拡張できます。ユーザーはテ

ストの本体で `for...in` のような単純なループを使用してこれを近似できますが、テストライブラリがこのタスクを処理させる方がよく、テストライブラリは各テストの呼び出しに対する引数を自動的に追跡し、結果に記録することができます。また、個々の引数の組み合わせを選択的に再実行し、1つのインスタンスが失敗した場合に微細なデバッグを行う方法を提供することもできます。

個々のパラメータ化されたテストの引数を結果に記録し、再実行することに注意してください。これには、これらの引数を一意に表現する方法が必要であり、これは
[Test identity](#test-identity)で議論されたいくつかの検討事項と重なります。

## 今日の解決策: XCTest

[XCTest](https://developer.apple.com/documentation/xctest)は、歴史的にSwiftでのデファクトスタンダードテストライブラリとして機能してきました。もともとは[1998年に](https://www.sente.ch/ocunit/?lang=en) Objective-Cで書かれており、そのAPI全体でObjective-Cのイディオムを強く採用しています。XCTestは、テストの発見と実行などについて、サブクラス化（参照セマンティクス）、動的メッセージパッシング、NSInvocation、およびObjective-Cランタイムに依存しています。2010年代には、XCTestはXcodeに深く統合され、多くの新しい機能とAPIが追加され、これによりAppleプラットフォームの開発者は業界をリードするソフトウェアを提供するのに役立ってきました。

Swiftが導入されたとき、XCTestは新しい言語をサポートするように拡張され、そのコアAPIと全体的なアプローチを維持しました。これにより、Objective-CでXCTestを使用してきた開発者は迅速にスピードアップすることができましたが、その設計の一部の側面はSwiftの現代的なベストプラクティスを反映しておらず、一部は問題となっており、機能の拡張を妨げています。例としては、テストの発見のためにObjective-Cランタイムに依存していること; Swiftで利用できないNSInvocationのようなAPIに依存していること; テストサブクラスでの暗黙的に展開されたオプショナル（IUO）プロパティの頻繁な必要性; そしてSwift Concurrencyとシームレスに統合するのが困難であること、があります。

Swiftでのテストに新しい方向を示す時がきました、そして新しい方向を提案することで、これは究極的にはXCTestの後継者を意味します。この移行はおそらく数年にわたって進行し、私たちは年間にわたる保守から得られた多くの教訓を念頭に置いて、さらに強力な解決策を慎重に設計し、提供することを目指しています。

## 新しいAPI方向性

> [!NOTE]
> 以下に説明されているアプローチは、このドキュメントで議論されている _すべての_ 検討事項や機能の解決策を含むものではありません。これは新しいAPI方向の出発点を説明しており、多くのトピックをカバーしていますが、後続の作業の一部として追求するものもあります。

新しい方向性には、新しいモジュール名 `Testing` 経由で公開される3つの主要なコンポーネントが含まれています：

1. `@Test` および `@Suite` アタッチマクロ：それぞれ、テスト関数とスイートタイプを宣言します。
2. Traits：テスト関数またはスイートタイプの動作をカスタマイズする `@Test` または `@Suite` に渡される値。
3. Expectations `#expect` と `#require`：期待される条件を検証し、失敗を報告する式マクロ。 

この新しいアプローチはSwiftの現代的な設計原則を反映し、Objective-Cランタイムへの依存を減らし、Swift Concurrencyとの良好な統合を目指しています。また、`Testing`モジュールは、テストの発見と実行を管理し、パラメータ化されたテストやその他の高度なテストケースをサポートする可能性があります。この新しいAPI方向は、Swiftでのテスト作成と実行をさらに強化し、効率的に行うための基盤を提供することを目指しています。

### テストとスイートの宣言

テスト関数とスイート（テストを含むタイプ）を宣言するには、
[Attached Macros (SE-0389)](https://github.com/apple/swift-evolution/blob/main/proposals/0389-attached-macros.md)を活用します。
概要として、これには `Testing` という新しいモジュールで定義された、テストタイプまたはテスト関数に配置できるいくつかのアタッチマクロが含まれます。

```swift
/// テスト関数を宣言
@attached(peer)
public macro Test(
  // ...後で説明されるパラメーター
)

/// テストスイートを宣言。
@attached(member) @attached(peer)
public macro Suite(
  // ...後で説明されるパラメーター
)
```

以下はいくつかの使用例です:

```swift
import Testing

// グローバル関数として実装されたテスト
@Test func example1() {
  // ...
}

@Suite struct BeginnerTests {
  // インスタンスメソッドとして実装されたテスト
  @Test func example2() { ... }
}

// @Test関数を含むため、スイートタイプとして暗黙的に扱われる。
actor IntermediateTests {
  private var count: Int

  init() async throws {
    // このタイプの@Testインスタンスメソッドの前に実行される
    self.count = try await fetchInitialCount()
  }

  deinit {
    // このタイプの@Testインスタンスメソッドの後に実行される
    print("count: \(count), delta: \(delta)")
  }

  // asyncおよびthrowsインスタンスメソッドとして実装されたテスト
  @Test func example3() async throws {
    delta = try await computeDelta()
    count += delta
    // ...
  }
}
```

**テスト関数**はグローバル関数またはタイプ内のインスタンスまたは静的メソッドとして定義できます。これらは常に明示的に`@Test`として注釈付けされる必要があり、特定の命名規則（「test」で始まるなど）に従う必要はなく、`async`、`throws`、または`mutating`を含めることができます。

**スイートタイプ**、または単に「スイート」とは、`@Test`関数または他のネストされたスイートタイプを含むタイプを指します。スイートタイプは`@Suite`属性を明示的に含めることができますが、これはオプショナルであり、特性（下記参照）を指定する場合にのみ必要です。スイートタイプは、インスタンス`@Test`メソッドを含む場合、ゼロパラメータの`init()`を持っている必要があります。

**テストごとのストレージ:** `IntermediateTests`の例は、テストごとのセットアップとティアダウン、およびテストごとのストレージを示しています: `IntermediateTests`のユニークなインスタンスは、それが含む`@Test`で注釈付けされたインスタンスメソッドごとに作成されるため、それぞれの`init`と`deinit`はそれぞれ一度実行され、セットアップまたはティアダウンのロジックを含めることができます。`count`はインスタンスストレージプロパティであるため、テストごとのストレージとして機能し、`example3()`はそのエンクロージングアクタータイプに隔離されているため、`count`を変更することが許可されています。

**Sendability:** これらの例のテスト関数とスイートタイプは`Sendable`である必要はありません。ランタイムで、`@Test`関数がインスタンスメソッドの場合、テストライブラリはスイートタイプをインスタンス化し、そのインスタンスで`@Test`関数を呼び出すスランクを作成します。スイートタイプのインスタンスは単一のタスクからのみアクセスされます。

**アクターの分離:** `@Test`関数またはタイプはグローバルアクター（`@MainActor`など）で注釈付けすることができ、標準の言語およびタイプシステムルールに従います。これにより、テストは対象のグローバルアクターと一致させ、停止ポイントの必要性を減らすことができます。



#### ランタイムテストディスカバリ

ランタイムでは、テストは`Test`のインスタンスとして表され、コンパイラが生成するメタデータを使用して取得されます。このメカニズムの具体的な内容はまだ設計されていないが、[SE-0385](https://github.com/apple/swift-evolution/blob/main/proposals/0385-custom-reflection-metadata.md) の改訂や新しい`@section`属性（[pitch](https://forums.swift.org/t/pitch-low-level-linkage-control-attributes-used-and-section/65877)を参照）によってカバーされる予定で、これによりプロパティを定数データのみを持つように注釈付けし、その内容をバイナリの特別なセクションに配置することができます。

しかし、そのサポートが実装される前に、テストライブラリは一時的なアプローチとして、既知のプロトコルに準拠するタイプを反復処理し、静的プロパティを呼び出してテストを収集することを使用します。アタッチされたマクロは、このメカニズムを使用して発見されるタイプを生成するコードを発行します。より恒久的なサポートが実装されると、アタッチされたマクロはそれを代わりに採用するように調整されます。

### トレイト（Traits）

以前の議論で述べたように、テストのトレイトを指定するサポートは重要です。[SE-0389](https://github.com/apple/swift-evolution/blob/main/proposals/0389-attached-macros.md) では、アタッチされたマクロ宣言にパラメータを含めることができ、これによりユーザーはテスト関数やタイプの`@Test`属性に引数を渡すことができます。

`Testing`モジュールは、`TestTrait`および`SuiteTrait`といったプロトコルに準拠するタイプを介して、テストごとのトレイトを指定する拡張可能なメカニズムを提供します：

```swift
/// テスト関数またはテストスイートに追加できるトレイトを説明するプロトコル。
public protocol Trait: Sendable { ... }

/// テスト関数に追加できるトレイトを説明するプロトコル。
public protocol TestTrait: Trait { ... }

/// テストスイートに追加できるトレイトを説明するプロトコル。
public protocol SuiteTrait: Trait { ... }
```

これらのプロトコルを使用すると、以前に示したアタッチされたマクロ`@Test`および`@Suite`は、トレイトを受け入れるパラメータを持つようになります：

```swift
/// テスト関数を宣言します。
///
/// - Parameter traits: このテストに適用する0個以上のトレイト。
@attached(peer)
public macro Test(
  _ traits: any TestTrait...
)

/// テスト関数を宣言します。
///
/// - Parameters:
///   - displayName: このテストのカスタマイズされた表示名。
///   - traits: このテストに適用する0個以上のトレイト。
@attached(peer)
public macro Test(
  _ displayName: _const String,
  _ traits: any TestTrait...
)

/// テストスイートを宣言します。
///
/// - Parameter traits: このテストスイートに適用する0個以上のトレイト。
@attached(member) @attached(peer)
public macro Suite(
  _ traits: any SuiteTrait...
)

/// テストスイートを宣言します。
///
/// - Parameters:
///   - displayName: このテストスイートのカスタマイズされた表示名。
///   - traits: このテストスイートに適用する0個以上のトレイト。
@attached(member) @attached(peer)
public macro Suite(
  _ displayName: _const String,
  _ traits: any SuiteTrait...
)
```

`Trait`プロトコルの詳細やそれに準拠する組

み込みタイプは後続の提案に残されますが、一般的なパターンを示すために、テストを無効にマークするための仮想オプションがどのように構造化されているかを示す例を示します：

```swift
/// テストを無効にマークするテストトレイト。
public struct DisabledTrait: TestTrait {
  /// このオプションに関連するオプショナルなコメント。
  public var comment: String?
}

extension TestTrait where Self == DisabledTrait {
  /// オプショナルなコメントでテストを無効にマークするテストトレイトを構築します。
  public static func disabled(_ comment: String? = nil) -> Self
}

// 使用例:
@Test(.disabled("現在クラッシュが発生しています: 詳細は#12345を参照"))
func example4() {
  // ...
}
```

#### ネスト / サブグループ化テスト

以前の例では、関連するテストを`Suite`に準拠する型内に配置することにより、それらをグループ化する方法が示されていました。この技術は、1つの`Suite`準拠型を別の`Suite`準拠型内にネストすることにより、サブグループを形成することも可能にします：

```swift
struct OuterTests {
  @Test func outerExample() { /* ... */ }

  @Test(.tags("edge-case"))
  struct InnerTests {
    @Test func innerExample1() { /* ... */ }
    @Test func innerExample2() { /* ... */ }
  }
}
```

この技術を使用すると、ネストされた型にテストの特徴を指定し、それらが含むすべてのテストに継承させることができます。たとえば、ここに示された`InnerTests`の`.tags("edge-case")` トレイトは、`innerExample1()`および`innerExample2()`の両方にタグ`edge-case`を追加する効果があり、`InnerTests`にも追加されます。

#### パラメータ化されたテスト

このAPIの方向性を使用して、パラメータ化されたテストをサポートするのは簡単です：以前に示した`@Test`関数はパラメータを受け付けないため、非パラメータ化されていますが、`@Test`関数にパラメータが含まれている場合、`Collection`を受け入れる`Test.init`の異なるオーバーロードが使用され、関連付けられた`Element`タイプはパラメータのタイプと一致します：

```swift
/// 一連の値にわたってパラメータ化されたテスト関数を宣言します。
///
/// - Parameters:
///   - traits: このテストに適用する0個以上のトレイト。
///   - collection: 関連付けられたテスト関数に渡す値のコレクション。
///
/// テスト中、`collection`内の各要素に対して関連付けられたテスト関数が一度呼び出されます。
@attached(peer)
public macro Test<C>(
  _ traits: any TestTrait...,
  arguments collection: C
) where C: Collection & Sendable, C.Element: Sendable

// 使用例:
@Test(arguments: ["a", "b", "c"])
func example5(letter: String) {
  // ...
}
```

Swiftの[可変ジェネリクス（Variadic Generics）](https://github.com/hborla/swift-evolution/blob/variadic-generics-vision/vision-documents/variadic-generics.md)のサポートがさらに機能を備えるようになると、これらの`@Test`マクロのシグネチャは複数の引数コレクションを受け入れるように改訂される可能性があります。これにより、_N_ のアリティを持つテスト関数が_N_ コレクションからの要素の各組み合わせに対して1回ずつ繰り返されるようになり、この機能が拡張されます。





### 期待値

Swift開発者に利用可能な既存のテストソリューションでは、`assert(2 < 1)` のような失敗した期待値に対して利用可能な診断情報は限られています。式は実行時に単純なブール値に減少し、テストの出力に含めるためのコンテキスト（オリジナルのソースコードなど）が利用できません。

[Expression Macros (SE-0382)](https://github.com/apple/swift-evolution/blob/main/proposals/0382-expression-macros.md) を採用することで、開発者に対して_暗黙的に表現力豊かな_テスト期待値を提供することができます。以下に示す期待値は、失敗時にブール値 `false`だけでなく、左辺および右辺のオペランドおよび演算子自体（それぞれ`x`、`1`、および`<`）をキャプチャし、`x → 2` のようなサブ式を評価された値に展開できます:

```swift
let x = 2
#expect(x < 1)  // failed: (x → 2) < 1
```

#### オプショナルの処理

いくつかの期待値は、テストが続行するために_pass_しなければなりません。これらは別のマクロ `#require()`で表現されます。`#require()`は_pass_しなければならないため、`#expect()`では実行できない引数に基づいて追加の動作を推測することができます。たとえば、オプショナル値が`#require()`に渡された場合、`#require()`はオプショナル値を返すか、それが`nil`の場合に失敗する必要があると推測できます:

```swift
let x: Int? = 10
let y: String? = nil
let z = try #require(x) // passes, z == 10
let w = try #require(y) // fails, test ends early with a thrown error
```

#### 複雑な式の処理

また、`a.contains(b)`のような式のコンポーネントを抽出し、失敗時に`a`および`b`の値を報告することもできます:

```swift
let a = [1, 2, 3]
let b = 4
#expect(a.contains(b)) // failed: (a → [1, 2, 3]).contains(b → 4)
```

#### コレクションの処理

また、さらなる表現力のために既存の言語機能を利用することもできます。
以下のテストロジックを考慮してください:

```swift
let a = [1, 2, 3, 4, 5]
let b = [1, 2, 3, 3, 4, 5]
#expect(a == b)
```

この期待値は、`b`の追加要素`3`のために失敗します。我々は、
[Ordered Collection Diffing (SE-0240)](https://github.com/apple/swift-evolution/blob/main/proposals/0240-ordered-collection-diffing.md) を利用して、これらの配列がどのように異なるかを正確にキャプチャし、その情報をテスト出力の一部として、またはIDE内で開発者に提供することができます。

## 検討された代替案

### Result Buildersを使用した宣言的なテスト定義

新しいテストAPIの方向性を探る中で、私たちは
[Result Builders](https://docs.swift.org/swift-book/LanguageGuide/AdvancedOperators.html#ID630)に
重く依存するアプローチを考え、徹底的にプロトタイプを作成しました。概念的には、いくつかの要素が含まれていました：

* `TestCase`および`TestSuite`のような型がそれぞれ個々のテストとグループを表しています。
* `TestBuilder`という`@resultBuilder`タイプが、テスト階層の宣言的な作成を許可しています。
* `TestProvider`という名前のプロトコルで、`@TestBuilder static var tests: TestSuite<Self>`という要件があり、スイートタイプはテストを定義するためにこれを実装します。
* 上記の`static var tests`リザルトビルダー内で定義されたテストは、テストごとのインスタンスストレージにアクセスできる`TestContext`というタイプのインスタンスを受け入れるクロージャーとして定義されています。

このアプローチは初めは有望に見え、このドキュメントの初めに記述された多くの目標を満たしていましたが、いくつかの重要な欠点を発見しました：

* **型チェックのパフォーマンス:** 特定のResult Builderの使用パターンは、式が長い場合に特に型チェックのパフォーマンスが低下する可能性があることが知られています。テストスイート全体を記述する際、テストが任意にネストされている可能性があり、作業量が指数関数的に増加し、ビルド時間が顕著に増加するか、極端な場合にはコンパイラのタイムアウトが発生する可能性があります。
* **テスト状態へのアクセス:** テストは`static`コンテキストで定義されているため、テストごとの状態は`TestContext`ラッパータイプを介して間接的にアクセスされる必要があります。これにより、テストごとのストレージへのアクセスが必要以上に冗長になり、ラッパータイプでの同期の必要性が生じました。
* **グローバルアクターの分離:** テスト本体と、テストごとの状態を格納するテストを囲む型の両方でグローバルアクター（ほとんどの場合は`@MainActor`）を使用し、それらが一致することを確認することは難しい、または不可能です。実際、グローバルアクターを含むテスト対象のテストは、多くの`await`サスペンションポイントなしに書くことは困難です。
* **ビルド時のテスト発見:** テストの定義がリザルトビルダー関数で行われるため、ビルド時にテストを包括的に発見することは困難、または不可能です。
* **発見:** Result Buildersを使用しても、ランタイムテストの発見問題を完全に解決することはできず、各準拠タイプ内のテストは、静的`tests`プロパティを呼び出すことで簡単に収集できるものの、`TestProvider`プロトコルに準拠するタイプを見つける必要があります。

### 命令形テスト定義

テストを定義する別の方法は、命令形スタイルAPIを使用したビルダーパターンを利用することです。これの良い例は、Swift自身の
[StdlibUnittest](https://github.com/apple/swift/tree/main/stdlib/private/StdlibUnittest)
ライブラリで、これは標準ライブラリのAPIをテストするために使用されています。テストを定義するには、ユーザーはまず`TestSuite`を作成し、その後、
`.test("Some name") { /* body */ }` を1回以上呼び出して各テストを含むクロージャを追加します。

このアプローチを一般化する際の問題の1つは、ビルド後またはIDEでテストを作成している間にテストを確定的に発見する方法がないことです（[Test discovery](#test-discovery)参照）。テストは命令形のコードを使用して定義されているため、静的解析が推論できない任意の制御フローロジックを含む可能性があります。作為の例として、以下を想像してみてください：

```swift
import StdlibUnittest

var myTestSuite = TestSuite("My tests")
if Bool.random() {
    myTestSuite.test("Foo") { /* ... */ }
}
```

ここで`if Bool.random()`のような任意のロジックがテストスイートの構築に影響を与える可能性があり、これにより、IDEのディスカバリーのような重要な機能が一般的なケースで不可能になります。

このような状況は、テストの自動発見と整理に挑戦をもたらし、開発者がどのテストが実行されるかを明確に理解するのを困難にする可能性があります。さらに、このスタイルのテスト定義は、テストの実行順序やグループ化、またはその他の構造的な属性を管理することが困難になる可能性があります。

命令形のテスト定義アプローチは、テストの構造とロジックを明示的に分離することなく、制御フローとテスト定義を混在させる傾向があります。これにより、テストの可読性と管理性が低下する可能性があり、大規模なプロジェクトまたは多数のテストスイートが含まれるプロジェクトで問題が発生する可能性があります。

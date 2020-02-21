# sentAls
東京都立多摩科学技術高等学校IT領域課題研究　jj1lis

### To English reader
[here](README.md) is README in English.

## 概要
sentAlsは日本語用感情極性判定機です。「感情極性」とは文章の感情・印象面から見たポジティブ、ネガティブさの度合いのことで、
文章の形態素、構文、係り受け関係を解析し、そこから文章の感情極性をスコアとして算出します。

## 依存関係
sentAlsは以下の環境、ライブラリに依存し、動作を確認しています。
- D言語: dmd v2.090.0以上 (https://dlang.org/)
- cabocha: cabocha バージョン0.69以上 (https://taku910.github.io/cabocha/)
- 日本語評価極性辞書: 東北大学　乾・鈴木研究室 (https://www.cl.ecei.tohoku.ac.jp/index.php?Open%20Resources/Japanese%20Sentiment%20Polarity%20Dictionary)

## フィードバッグ
連絡の際はこちらからどうぞ
- [issues](https://github.com/jj1lis/sentAls/issues) on Github
- email: rinta.nambuline205@gmail.com
- (twitter: [@_SIL1JJ](https://twitter.com/_SIL1JJ))

## 研究について
- 名前: jj1lis
- 所属: 東京都立多摩科学技術高等学校
- 研究題目: 日本語における文章の感情極性判定 (Sentiment Classification of Sentence in Japanese)

## 使い方
このレポジトリをCloneします。
```
$ git clone https://github.com/jj1lis/sentAls.git
```

### 使う前に
C++部分をコンパイルします（リンクはしません）。sentAls/cppに移動したら、
```bash
$ cd cpp/
$ g++ -c dependency.cpp
```
プロジェクトを**DUB**(D言語パッケージマネージャ)でビルドします。
プロジェクトのルートディレクトリ(sentAls/)に移動したら以下を実行しましょう
```
$ dub build
```
もしお持ちでなければ[こちら](https://code.dlang.org)を参照ください。

DUBは結構面倒なので、makefileも（いつか）書きます。

### 実行
```bash
$ ./sent-als [<option> <arguments>]

# 例

$ ./sent-als -h
    #ヘルプを表示します
$ ./sent-als -t おはようございます。 -i data/hogedata
    #「おはようございます。」と"data/hogedata"の内容を入力します。
$ ./sent-als -i fugatext -o fugaout
    #"fugatext"から入力し、"fugaout.(sum|als|ctx)"へ出力します
```

### オプション
現在のところ以下のオプションがあります。

|オプション|説明|補足|
|------|-----------|----------|
|-v|バージョンを表示|引数は無視します|
|-h|ヘルプを表示|引数は無視します|
|-t|コマンドラインから文章を入力|文章は複数入力できます|
|-i|入力ファイルを指定|入力ファイルは複数指定できます|
|-o|出力ファイルを指定|出力ファイルは**複数指定できません**|
|-n|出力なし|sentAlsは結果をどこにも出力しません|

#### 出力オプションについて
sentAlsの結果出力先はデフォルトでは標準出力ですが、
*-o* オプションをつけると**3つの**ファイルが作成されます。
1. 解析ファイル (.als)
    - 文節の重み、文ごとのスコアなど詳細な解析内容です。
2. 概要ファイル (.sum)
    - 文章とスコアのみの概要です。
3. 文脈ファイル (.ctx)
    - 標準フォーマットです。

`-o sample`とオプションをつけて実行すれば、sentAlsは`sample.als  sample.sum  sample.ctx`を作成します。

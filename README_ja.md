# sentAls
東京都立多摩科学技術高等学校IT領域所属 jj1lis 課題研究

### To English reader
[here](README.md) is README in English.

## 概要
これは日本語用感情極性判定機です。「感情極性」とは文章の感情・印象面から見たポジティブ、ネガティブさの度合いのことで、
sentAlsは文章の形態素、構文、係り受け関係を解析し、そこから文章の感情極性をスコアとして算出します。

## 依存関係
sentAlsは以下の環境、ライブラリに依存し、また動作が確認されています。
- dlang: dmd v2.090.0以上 (https://dlang.org/)
- cabocha: cabocha バージョン0.69以上 (https://taku910.github.io/cabocha/)
- 日本語評価極性辞書: 東北大学　乾・鈴木研究室 (https://www.cl.ecei.tohoku.ac.jp/index.php?Open%20Resources/Japanese%20Sentiment%20Polarity%20Dictionary)

## フィードバッグ
連絡の際はこちらからどうぞ
- issues on Github
- email: rinta.nambuline205@gmail.com
- (twitter: @_SIL1JJ)

## 研究について
- name: jj1lis
- 所属: 東京都立多摩科学技術高等学校
- research title: 日本語における文章の感情極性判定 (Sentiment Classification of Sentence in Japanese)

## 使い方
このレポジトリをCloneします。
```
$ git clone https://github.com/jj1lis/sentAls.git
```

### 使う前に
プロジェクトを**DUB**(D言語パッケージマネージャ)でビルドします。
プロジェクトのルートディレクトリに移動したら以下を実行しましょう
```
$ dub build
```
もしお持ちでなければ[こちら](https://code.dlang.org)を参照ください。

### 実行
```bash
$ ./sent-als [<option> <arguments>]

# example

$ ./sent-als -h
    #print help
$ ./sent-als -t おはようございます。 -i data/hogedata
    # input text "おはようございます。" and contents of file "data/hogedata"
$ ./sent-als -i fugatext -o fugaout
    # input from "fugatext" and output to file "fugaout.(sum|als|ctx)"
```

### オプション
現在のところ以下のオプションがあります:

|オプション|説明|補足|
|------|-----------|----------|
|-v|バージョンを表示|引数は無視します|
|-h|ヘルプを表示|引数は無視します|
|-t|コマンドラインから文章を入力|文章は複数入力できます|
|-i|入力ファイルを指定|入力ファイルは複数指定できます|
|-o|出力ファイルを指定|出力ファイルは**複数指定できません**|
|-n|出力なし|sentAlsは結果をどこにも出力しません|

#### 出力オプションについて
sentAlsは結果をデフォルトでは標準出力に表示します。
*-o* オプションをつけると、**3つの**ファイルが作成されます。
1. 解析ファイル (.als)
    - 文節の重み、文ごとのスコアなど詳細な解析内容です。
2. 概要ファイル (.sum)
    - 文章とスコアのみの概要です。
3. 文脈ファイル (.ctx)
    - 標準フォーマットです。

`-o sample`で実行すれば、sentAlsは`sample.als  sample.sum  sample.ctx`を作成します。

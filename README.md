# sentAls
Themed research of jj1lis, IT Department, Tama High School of Science and Technology.

### To Japanese reader
日本語版READMEは[こちら](README_ja.md)

## Overview
This is Sentiment Classification Analyzer for Japanese. "Sentiment classification"
is the degree to which text is positive or negative terms in the emotion and impression.
sentAls analyzes morpheme, syntax, and dependency that text includes and calculates its classification as score from them.

## Dependencies
sentAls depends and is confirmed its motion following environments and libraries.
- dlang: dmd v2.090.0 over (https://dlang.org/)
- cabocha: cabocha of 0.69 (https://taku910.github.io/cabocha/)
- Japanese Sentiment Polarity Dictionary: Natural Language Processing Lab (Inui-Suzuki Lab), Tohoku University (https://www.cl.ecei.tohoku.ac.jp/index.php?Open%20Resources/Japanese%20Sentiment%20Polarity%20Dictionary)

## Feedback
contact me at:
- [issues](https://github.com/jj1lis/sentAls/issues) on Github
- email: rinta.nambuline205@gmail.com
- (twitter: [@_SIL1JJ](https://twitter.com/_SIL1JJ))

## about research
- name: jj1lis
- affiliation: Tokyo Metropolitan Tama High School of Science and Technology
- research title: Sentiment Classification of Sentence in Japanese (日本語における文章の感情極性判定)

## Usage
Clone this repo to your local.
```
$ git clone https://github.com/jj1lis/sentAls.git
```

### Before using
Compile the part written in C++. Move to sentAls/cpp.
```bash
$ cd cpp/
$ g++ -c dependecy.cpp
```

Build project by **DUB**: package manager for D package.
Move to the root directory (sentAls/) and execute following:
```bash
$ dub build
```
Refer to https://code.dlang.org if you don't have.

I'll also create makefile (someday).

### Execute
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

### Options
There are these options now:

|Option|Description|Supplement|
|------|-----------|----------|
|-v|Display version|Ignore arguments|
|-h|Display help information|Ignore arguments|
|-t|Input texts from commandline|You can specify multiple texts|
|-i|Specify input files|You can specify multiple files|
|-o|Specify output file|You **cannot** specify multiple files; only one file|
|-n|No output|sentAls doesn't output results anywhere|

#### About output option
sentAls defaultly output results to standard output.
It creates **three** output files if you specify option *-o*:
1. analysis file (.als)
    - Detailed analysis contents such as phrase weight and score for each sentences.
2. summary file (.sum)
    - Summary that is texts and score only.
3. context file (.ctx)
    - Basic format.

Executing `-o sample` make sentAls create `sample.als  sample.sum  sample.ctx`.

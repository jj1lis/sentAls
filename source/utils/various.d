module utils.various;

import std.datetime;

import utils.io;

struct Meta{
    private SysTime start;
    private string writefile;
    private string[] _texts;
    private string dicfile;
    private DicShelf dics;

    private string path="dictionary/";

    @property{
        auto startTime(){return start;}
        auto startDateTime(){return cast(DateTime)start;}
        auto texts(){return _texts;}
        auto filename(){return writefile;}
        auto dicname(){return dicfile;}
        auto dictionary(){return dics;}
    }
    this(string[] texts,string file){
        start=Clock.currTime;
        _texts~=texts;
        writefile=file;
        dics=new DicShelf(path~"noun.dic",path~"precaution.dic");
    }
}

Meta meta;

string replaceSymbol(string text){
    import std.regex;
    text=replace(text,regex("!","g"),"！");
    text=replace(text,regex("\?","g"),"？");
    text=replace(text,regex(",","g"),"、");
    return text;
}

string[] separateSentence(string text){
    string[] sentences;
    dchar[] tmp_sentence;
    foreach(c;text.to!(dchar[])){
        switch(c){
            case '。':
                sentences~=(tmp_sentence~c).to!string;
                tmp_sentence.length=0;
                break;
                //
            default:
                tmp_sentence~=c;
        }
    }
    if(tmp_sentence.length!=0){
        sentences~=tmp_sentence.to!string;
    }
    return sentences;
}

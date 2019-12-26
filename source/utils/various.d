module utils.various;

import std.datetime;
import std.conv;

import utils.io;

enum Output{
    file,
    comline,//stdout
}

struct Meta{
    private string path="dictionary/";

    private SysTime start;
    private string writefile;
    private Output output_flag;
    private string[] _texts;
    private string dicfile;
    private DicShelf dics;

    @property{
        auto startTime(){return start;}
        auto startDateTime(){return cast(DateTime)start;}
        auto texts(){return _texts;}
        auto filename(){return writefile;}
        auto outflag(){return output_flag;}
        auto dicname(){return dicfile;}
        auto dictionary(){return dics;}
    }
    this(string[] texts,string file,Output output_flag){
        start=Clock.currTime;
        _texts~=texts;
        writefile=file;
        this.output_flag=output_flag;
        dics=new DicShelf(path~"noun.dic",path~"precaution.dic");
    }
}

Meta meta;

string replaceSymbol(string text){
    import std.regex;
    text=replace(text,regex("!","g"),"！");
    text=replace(text,regex("\\?","g"),"？");
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

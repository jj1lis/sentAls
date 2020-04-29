module utils.various;

import std.conv;

import utils;

@safe:

enum Output{
    file,
    stdout,
    stderr,
    none,
}

struct Meta{
    import std.datetime;
    private:
        string path="dictionary/";

        SysTime start;
        string _outputfile;
        Output output_destination;
        string[] _texts;
        DicShelf dics;

    public:
        real weight_base=0.5;
        invariant(0<weight_base&&weight_base<1);

        @property{
            auto startTime(){return start;}
            auto startDateTime(){return cast(DateTime)start;}
            auto texts(){return _texts;}
            auto outputfilename(){return _outputfile;}
            auto outputdestination(){return output_destination;}
            auto dictionary(){return dics;}
        }

        @system this(const string[] texts,Output output_destination,string _outputfile){
            start=Clock.currTime;
            _texts=texts.dup;
            this._outputfile=_outputfile;
            this.output_destination=output_destination;
            dics=new DicShelf(path~"noun.dic",path~"precaution.dic");
        }
}

Meta meta;

string replaceSymbol(const string _text){
    import std.regex;
    string text=replace(_text,regex("!","g"),"！");
    text=replace(text,regex("\\?","g"),"？");
    text=replace(text,regex(",","g"),"、");
    return text;
}

string[] separateSentence(const string text){
    string[] sentences;
    dchar[] tmp_sentence;
    foreach(c;text.to!(dchar[])){
        switch(c){
            case '。','？','！':
                sentences~=(tmp_sentence~c).to!string;
                tmp_sentence.length=0;
                break;
            default:
                tmp_sentence~=c;
        }
    }
    if(tmp_sentence.length!=0){
        sentences~=tmp_sentence.to!string;
    }
    return sentences;
}

module utils.meta;

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
    this(SysTime c,string[] texts,string file){
        start=c;
        _texts~=texts;
        writefile=file;
        dics=new DicShelf(path~"noun.dic",path~"precaution.dic");
    }
}

Meta meta;

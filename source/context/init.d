module context.init;

import std.datetime;

import context.io;


struct Meta{
    private SysTime start;
    private string readfile;
    private string dicfile;
    private DicShelf dics;

    private string path="dictionary/";

    @property{
        auto startTime(){return start;}
        auto startDateTime(){return cast(DateTime)start;}
        auto filename(){return readfile;}
        auto dicname(){return dicfile;}
        auto dictionary(){return dics;}
    }
    this(SysTime c,string file){
        start=c;
        readfile=file;
        dics=new DicShelf(path~"noun.dic",path~"precaution.dic");
    }
}

Meta meta;

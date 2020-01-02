module utils.io;

import std.stdio;
import std.file;
import std.string;

import utils.various;

auto outputln(T)(T filename,string buffer){
    output(filename,buffer~"\n");
}

auto output(T)(lazy T filename,string buffer){
    switch(meta.outflag){
        case Output.file:
            append(filename,buffer);
            break;
        case Output.stdout:
            buffer.write;
            break;
        case Output.stderr:
            stderr.write(buffer);
            break;
        case Output.none:
            break;
        default:
    }
}

auto devideFileByLine(string filename){
    try{
        return readText(filename).splitLines;
    }catch(FileException fe){
        throw new FileException(filename,"failed to open file");
    }
}

auto initFiles(string file){
    try{
        if(exists(file~".ctx")&&isFile(file~".ctx")){
            remove(file~".ctx");
        }
        if(exists(file~".als")&&isFile(file~".als")){
            remove(file~".als");
        }
        if(exists(file~".log")&&isFile(file~".log")){
            remove(file~".log");
        }
        if(exists(file~".sum")&&isFile(file~".sum")){
            remove(file~".sum");
        }
    }catch(FileException fe){
        stderr.writeln("error: "~fe.msg);
    }
}

class DicShelf{
    private string[] _noun;
    private string[] _precaution;
    private string[] _idiom;

    @property{
        string[] noun(){return _noun;}
        string[] precaution(){return _precaution;}
        string[] idiom(){return _idiom;}
    }

    this(string noundic,string predic,string idiomdic){
        try{
            _noun=devideFileByLine(noundic);
            _precaution=devideFileByLine(predic);
            _idiom=devideFileByLine(idiomdic);
        }catch(FileException fe){
            stderr.writeln("error: can't open Dictionary. :"~fe.msg);
        }
    }
}

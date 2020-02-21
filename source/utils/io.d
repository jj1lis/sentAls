module utils.io;

import std.stdio;
import std.file;
import std.string;
import std.conv;

import utils.various;
import utils.exception;

auto outputln(T)(T filename,string buffer){
    output(filename,buffer~"\n");
}

auto output(T)(T filename,string buffer){
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

//import std.algorithm;
//auto textNums=(string[] lines)=>lines.filter!((line)=>line.split(",")=="#").map!((line)=>line.split(",").to!int).array();

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
    private:
        string[] _noun;
        string[] _precaution;

    public:

        @property{
            string[] noun(){return _noun;}
            string[] adject(){return _precaution;}
            string[] verb(){return _precaution;}
        }

        this(string noundic,string predic){
            try{
                _noun=devideFileByLine(noundic);
                _precaution=devideFileByLine(predic);
            }catch(FileException fe){
                stderr.writeln("error: can't open Dictionary. :"~fe.msg);
            }
        }
}

module utils.io;

import std.stdio;
import std.file;
import std.string;
import std.conv;

import utils;

@system:

void writeError(const Exception ex, const string type="error"){
    stderr.writeln("\033[1m\033[33m"~type~"\033[0m\033[1m: "~ex.msg);
}

auto outputln(T)(const T filename,const string buffer){
    output(filename,buffer~"\n");
}

auto output(T)(const T filename,const string buffer){
    switch(meta.outputdestination){
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

@safe auto devideFileByLine(const string filename){
    try{
        return readText(filename).splitLines;
    }catch(FileException fe){
        throw new FileException(filename,"failed to open file");
    }
}

auto initFiles(const string file){
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

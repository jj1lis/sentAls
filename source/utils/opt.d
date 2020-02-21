module utils.opt;

import std.stdio;

import utils.exception;
import utils.various;
import utils.io;

enum Opt{
    text,
    inputfile,
    outputfile,
    no_output,
    help,
    ver,
    unknown,
}

struct Option{
    private Opt opt;
    private string[] args;

    @property{
        Opt option(){return opt;}
        string[] arg(){return args;}
    }

    this(Opt opt,string[] args){
        this.opt=opt;
        this.args=args;
    }
}

Option[] separateOption(string[] args){
    auto isAlone=(Opt opt)=>opt==Opt.ver||opt==Opt.help;

    string[] tmp_arg;
    Option[] options;
    Opt opt=args[0].argToOption;
    foreach(arg;args[1..$]){
        if(arg.argToOption!=Opt.unknown){
            options~=Option(opt,tmp_arg);
            tmp_arg.length=0;
            opt=arg.argToOption;
        }else{
            tmp_arg~=arg;
        }
    }
    options~=Option(opt,tmp_arg);
    return options;
}

Opt argToOption(string arg){
    switch(arg){
        case "-t":
            return Opt.text;
        case "-i":
            return Opt.inputfile;
        case "-o":
            return Opt.outputfile;
        case "-h":
            return Opt.help;
        case "-v":
            return Opt.ver;
        case "-n":
            return Opt.no_output;
            //
        default:
            return Opt.unknown;
    }
}

bool executeOption(Option[] opts){
    string[] texts;
    string[] inputfiles;
    string outputfile;
    Output outflag=Output.stdout;
    bool continue_flag,outputflag;

    foreach(opt;opts){
        switch(opt.option){
            case Opt.unknown:
                throw new ArgumentException("Unknown option included.");
            case Opt.text:
                if(opt.arg.length==0){
                    throw new ArgumentException("-t: Specify text.");
                }else{
                    continue_flag=true;
                    texts~=opt.arg;
                }
                break;
            case Opt.inputfile:
                if(opt.arg.length==0){
                    throw new ArgumentException("-i: Specify input filename.");
                }else{
                    continue_flag=true;
                    foreach(file;opt.arg){
                        texts~=file.devideFileByLine;
                    }
                }
                break;
            case Opt.outputfile:
                if(opt.arg.length==0){
                    throw new ArgumentException("-o: Specify output filename.");
                }else if(opt.arg.length>1){
                    throw new ArgumentException("-o: Too many arguments.");
                }else{
                    outputflag=true;
                    outputfile=opt.arg[0];
                    outflag=Output.file;
                }
                break;
            case Opt.no_output:
                if(opt.arg.length>0){
                    throw new ArgumentException("-n: This option must be calld without arguments.");
                }
                outflag=Output.none;
                break;
            case Opt.help:
                help.writeln;
                break;
            case Opt.ver:
                ver.writeln;
                break;
            default:
        }
    }
    if(!continue_flag&&outputflag){
        throw new NoInputException("-o: Output file is specified even though text isn't input.");
    }

    meta=Meta(texts,outputfile,outflag);
    return continue_flag;
}

string help(){
    return "help!";
}

string ver(){
    enum VER="Sentiment Classification Analyzer 0.1.0221 raugh";
    return VER~"\ncopyright (c) 2019-2020 jj1lis";
}

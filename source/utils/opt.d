module utils.opt;

import std.stdio;
import std.range;

import utils;

@safe:

enum OptType{
    text,
    inputfile,
    outputfile,
    no_output,
    help,
    ver,
    unknown,
}

bool isHelperOptType(OptType ot){
    switch(ot){
        case OptType.help,OptType.ver:
            return true;
        default:
            return false;
    }
}

O to(O)(string arg)if(is(O==OptType)){
    switch(arg){
        case "-t":
            return OptType.text;
        case "-i":
            return OptType.inputfile;
        case "-o":
            return OptType.outputfile;
        case "-h":
            return OptType.help;
        case "-v":
            return OptType.ver;
        case "-n":
            return OptType.no_output;
            //
        default:
            return OptType.unknown;
    }
}

struct Option{
    private OptType opt;
    private string[] args;

    @property{
        inout OptType opttype(){return opt;}
        string[] arg(){return args;}
    }

    this(OptType opt,string[] args){
        this.opt=opt;
        this.args=args;
    }
}

auto separateOption(R)(const R args)if(isRandomAccessRange!R&&is(ElementType!R==string)){

    assert(args.length>0);

    string[] tmp_arg;
    Option[] options;
    OptType opt=args[0].to!OptType;

    if(args.length>1){
        foreach(arg;args[1..$]){
            if(arg.to!OptType!=OptType.unknown){
                options~=Option(opt,tmp_arg);
                tmp_arg.length=0;
                opt=arg.to!OptType;
            }else{
                tmp_arg~=arg;
            }
        }
    }
    options~=Option(opt,tmp_arg);
    return options;
}

bool isMainProcessExecuted(R)(const R opts)if(isRandomAccessRange!R&&is(ElementType!R==Option)){
    foreach(opt;opts)
        if(opt.opttype.isHelperOptType||opt.opttype==OptType.unknown)
            return false;

    return true;
}

@system void executeOption(Option[] opts){
    string[] texts;
    string[] inputfiles;
    string outputfile;
    Output out_destination=Output.stdout;
    bool inputflag,outputflag;

    foreach(opt;opts){
        switch(opt.opttype){
            case OptType.unknown:
                throw new ArgumentException("Unknown option included.");
            case OptType.text:
                if(opt.arg.length==0){
                    throw new ArgumentException("-t: Specify text.");
                }else{
                    inputflag=true;
                    texts~=opt.arg;
                }
                break;
            case OptType.inputfile:
                if(opt.arg.length==0){
                    throw new ArgumentException("-i: Specify input filename.");
                }else{
                    inputflag=true;
                    foreach(file;opt.arg){
                        texts~=file.devideFileByLine;
                    }
                }
                break;
            case OptType.outputfile:
                if(opt.arg.length==0){
                    throw new ArgumentException("-o: Specify output filename.");
                }else if(opt.arg.length>1){
                    throw new ArgumentException("-o: Too many arguments.");
                }else{
                    outputflag=true;
                    outputfile=opt.arg[0];
                    out_destination=Output.file;
                }
                break;
            case OptType.no_output:
                if(opt.arg.length>0){
                    throw new ArgumentException("-n: This option must be calld without arguments.");
                }
                out_destination=Output.none;
                break;
            case OptType.help:
                help.writeln;
                return;
            case OptType.ver:
                ver.writeln;
                return;
            default:
        }
    }
    if(!inputflag&&outputflag){
        throw new NoInputException("-o: Output file is specified even though text isn't input.");
    }

    meta=Meta(texts,out_destination,outputfile);
}

string help(){
    return "help!";
}

string ver(){
    enum VER="Sentiment Classification Analyzer 0.1.0221 raugh";
    return VER~"\ncopyright (c) 2019-2020 jj1lis";
}

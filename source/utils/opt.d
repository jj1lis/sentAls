module utils.opt;

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
    string[] tmp_arg;
    Option[] options;
    Opt opt=args[0].argToOption==Opt.unknown?Opt.unknown:args[0].argToOption;
    foreach(arg;args){
        if(arg.argToOption!=Opt.unknown){
            if(tmp_arg.length!=0){
                options~=Option(opt,tmp_arg);
                tmp_arg.length=0;
            }else if(options.length!=0){
                options~=Option(opt,[]);
            }
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

void excecuteOption(Option[] opts){
    string[] texts;
    string[] inputfiles;
    string outputfile;
    Output outflag=Output.stdout;
    foreach(opt;opts){
        switch(opt.option){
            case Opt.unknown:
                throw new ArgumentException("Unknown Option.");
            case Opt.text:
                if(opt.arg.length==0){
                    throw new ArgumentException("-t: Specify text.");
                }else{
                    texts~=opt.arg;
                }
                break;
            case Opt.inputfile:
                if(opt.arg.length==0){
                    throw new ArgumentException("-i: Specify input filename.");
                }else{
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
                throw new Termination(help);
            case Opt.ver:
                throw new Termination(ver);
            default:
        }
    }
    meta=Meta(texts,outputfile,outflag);
}

string help(){
    auto msg=new string[];
    msg~="-h\t\t\t\tShow help.";
    msg~="-v\t\t\t\tShow version.";
    msg~="-t [texts...]\t\t\t\tInput texts to analyze from command line.";
    msg~="-i [input files...]\t\t\t\tSpecify input files."
    msg~="-o [output file]\t\t\t\tSpecify output file name.";
    msg~="\t\t\t\tResults are output to stderr by default (-o isn't specified).";
    msg~="-n\t\t\t\tDo not display output.";
    return msg;
}

string ver(){
    enum VER="0.3 rough";
    return "sentAnalyzer "~VER~"\ncopyright (c) 2019 jj1lis";
}

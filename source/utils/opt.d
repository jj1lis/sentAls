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

bool isHelperOptType(const OptType ot){
    switch(ot){
        case OptType.help,OptType.ver:
            return true;
        default:
            return false;
    }
}

O to(O)(const string arg)if(is(O==OptType)){
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

@system void executeOption(const Option[] opts){
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

enum help(){
    return "
    usage: sent-als [<option> <arg>...]...

    Option List

        -t      Input texts directly.
                args are raw Japanese texts.
                you can specify multiple texts (separate with a half-width space.)
                    e.g.: sent-als -t おはようございます。今日もいい天気ですね。 昨日の新聞は読みましたか？
                        Texts of this example are separated as following:
                            - \"おはようございます。今日もいい天気ですね。\"
                            - \"昨日の新聞は読みましたか？\"

        -i      Input texts from specified files.
                args are filenames (you can specify multiple files.)
                    e.g.: sent-als -i sample1 sample2 sample3

        -o      Specify file written the analysis result.
                arg is filename (you can specify only one file.)
                    e.g.: sent-als -o result.txt
                The result'll be emitted to stdout if you don't specify the output file.

        -n      Don't emit the result.
                The result isn't written to file nor display to stdout.
                You can specify no arguments.
                    e.g.: sent-als -n
                
        -h      Display the help.

        -v      Display the version information.

    Multiple options can be specified.";
}

//TODO
enum ver(){
    return "Sentiment Classification Analyzer 0.1.0221 raugh\nFinal Built on "~__DATE__~"\ncopyright (c) 2019-2020 jj1lis";
}

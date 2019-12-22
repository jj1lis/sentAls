import std.stdio;
import std.file;
import std.datetime;

import context.init;
import context.io;
import context.exception;
import context.calc;
import context.text;

import include.cabocha;

void main(string[] args){
    if(args.length<2){
        stderr.writeln("error: "~new ArgumentNumberException("argument is too little").msg);
    }else{
        foreach(fn;args[1..$]){
            fn.writeln;
            initFiles(fn);
            auto filelines=devideFileByLine(fn);
            foreach(read_text_num;textNums(filelines)){
                meta=Meta(Clock.currTime,fn);
                Text text;
                try{
                    text=new Text(separateText(filelines,read_text_num),read_text_num);
                }catch(stringToIntException stie){
                    stderr.writeln("error: "~stie.msg);
                }catch(FileException fe){
                    stderr.writeln("error: "~fe.msg);
                }catch(NoTextNumberException ntne){
                    stderr.writeln("error: "~ntne.msg);
                }catch(stringToFloatException stfe){
                    stderr.writeln("error: "~stfe.msg);
                }catch(ScoreException se){
                    stderr.writeln("error: "~se.msg);
                }

                text.setScore(calculateTextScore(text));
                writeText(text);
                writeAnalysis(text);
                writeSummary(text);

                debugSpace(text);
            }
        }
    }
}

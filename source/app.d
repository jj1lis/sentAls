import std.stdio;
import std.file;

import utils.meta;
import utils.io;
import utils.opt;
import utils.exception;
import context.io;
import context.calc;
import context.text;

import include.cabocha;

class input{
        string[] texts;
        string[] inputfiles;
        string outputfile;
}

void main(string[] args){
    try{ 
        args[1..$].separateOption.excecute;
    }catch(ArgumentException ae){
        stderr.writeln("error: "~ae.msg);
    }catch(Termination t){
        stderr.writeln(t.msg);
        import core.stdc.stdlib;
        t.isfailure?exit(-1):exit(0);
    }

    //Context
    foreach(fn;args[1..$]){
        fn.writeln;
        initFiles(fn);
        auto filelines=devideFileByLine(fn);
        foreach(read_text_num;textNums(filelines)){
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

auto debugSpace(Text target){
    string[] text;
    foreach(Sentence s;target.sentences){
        foreach(Phrase p;s.phrases){
            foreach(Word w;p.words){
                text~=w.morpheme;
            }
        }
    }
    foreach(string s;text){
        s.write;
    }
    "\n".write;
}

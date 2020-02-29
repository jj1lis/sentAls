import std.stdio;
import std.file:FileException;
import std.conv;

import utils.various;
import utils.io;
import utils.opt;
import utils.exception;
import context.io;
import context.calc;
import context.text;

void writeErr(Exception ex){
    stderr.writeln("\033[1m\033[33merror\033[0m\033[1m: "~ex.msg);
}

void main(string[] args){
    bool continue_flag;
    try{ 
        if(args.length<2){
            throw new ArgumentException("No arguments.");
        }
        continue_flag=args[1..$].separateOption.executeOption;
    }catch(ArgumentException ae){
        writeErr(ae);
    }catch(FileException fe){
        writeErr(fe);
    }catch(NoInputException nie){
        writeErr(nie);
    }/*catch(Termination t){
       stderr.writeln(t.msg);
       import core.stdc.stdlib;

       int exitcode=t.isfailure?-1:0;
       writefln("exit code %s\nTerminated.",exitcode);
       exit(exitcode);
       }*/

    if(continue_flag){

        if(meta.outflag==Output.file){
            meta.filename.initFiles;
        }
        
        Text[] texts;

        foreach(read_text_num;0..meta.texts.length.to!int){
            //Text text;
            auto sents=meta.texts[read_text_num].replaceSymbol.separateSentence;
            try{
                //text=new Text(sents,read_text_num);
                texts~=new Text(sents,read_text_num);
            }catch(stringToIntException stie){
                stderr.writeln("error: "~stie.msg);
            }catch(NoTextNumberException ntne){
                stderr.writeln("error: "~ntne.msg);
            }catch(stringToFloatException stfe){
                stderr.writeln("error: "~stfe.msg);
            }catch(ScoreException se){
                stderr.writeln("error: "~se.msg);
            }

            //text.score=text.calculateTextScore;
            //writeText(text);
            //writeAnalysis(text);
            //writeSummary(text);

            //debugSpace(text);
        }
        debugSpace2(texts);
    }
}

auto debugSpace2(Text[] texts){
    "debugSpace2 called".writeln;
    import std.file,std.algorithm,std.array;
    append(meta.filename~".csv","a,b,score1,score2,....\n");
    string[] results;
    string func(real base){
        meta.weight_base=base;
        writefln("base==%s",base);
        texts.each!(text=>text.score=text.calculateTextScore);
        texts.each!(text=>text.score.writeln);
        auto base_=meta.weight_base.to!string;
        auto score=texts.map!(text=>text.score.to!string).join(",");
        return base_~","~score;
    }

    import std.range;
    func(1./5.);
    "other case".writeln;
    foreach(base;iota(10000).map!(i=>(1/10001.)*(i+1))){
        func(base);
    }
    append(meta.filename~".csv",results.join("\n"));

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

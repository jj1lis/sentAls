import std.stdio;
import std.conv;

import utils.meta;
import utils.io;
import utils.opt;
import utils.exception;
import context.io;
import context.calc;
import context.text;

void main(string[] args){
    try{ 
        args[1..$].separateOption.excecuteOption;
    }catch(ArgumentException ae){
        stderr.writeln("error: "~ae.msg);
    }catch(Termination t){
        stderr.writeln(t.msg);
        import core.stdc.stdlib;

        int exitcode=t.isfailure?-1:0;
        writefln("exit code %s\nTerminated.",exitcode);
        exit(exitcode);
    }

    //foreach(read_text_num;0..meta.texts.length.to!int){
    //    Text text;
    //    auto sents=meta.texts[read_text_num].replaceSymbol.separateSentence;
    //    try{
    //        text=new Text(sents,read_text_num);
    //    }catch(stringToIntException stie){
    //        stderr.writeln("error: "~stie.msg);
    //    }catch(NoTextNumberException ntne){
    //        stderr.writeln("error: "~ntne.msg);
    //    }catch(stringToFloatException stfe){
    //        stderr.writeln("error: "~stfe.msg);
    //    }catch(ScoreException se){
    //        stderr.writeln("error: "~se.msg);
    //    }

    //    text.score=text.calculateTextScore;
    //    writeText(text);
    //    writeAnalysis(text);
    //    writeSummary(text);

    //    debugSpace(text);
    //}
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

string replaceSymbol(string text){
    import std.regex;
    text=replace(text,regex("!","g"),"！");
    text=replace(text,regex("\?","g"),"？");
    text=replace(text,regex(",","g"),"、");
    return text;
}

string[] separateSentence(string text){
    string[] sentences;
    dchar[] tmp_sentence;
    foreach(c;text.to!(dchar[])){
        switch(c){
            case '。':
                sentences~=(tmp_sentence~c).to!string;
                tmp_sentence.length=0;
                break;
                //
            default:
                tmp_sentence~=c;
        }
    }
    if(tmp_sentence.length!=0){
        sentences~=tmp_sentence.to!string;
    }
    return sentences;
}

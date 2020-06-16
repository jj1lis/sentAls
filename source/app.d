import std.stdio;
import std.file:FileException;
import std.conv;

import utils;
import context;

void main(string[] args){
    bool continue_flag;

    try{ 
        if(args.length<2){
            throw new ArgumentException("No arguments.");
        }
        auto options=args[1..$].separateOption;
        continue_flag=options.isMainProcessExecuted;
        options.executeOption;

    }catch(ArgumentException ae){
        writeError(ae);
    }catch(FileException fe){
        writeError(fe);
    }catch(NoInputException nie){
        writeError(nie);
    }

    if(continue_flag){
        if(meta.outputdestination==Output.file){
            meta.outputfilename.initFiles;
        }
        
        Text[] texts;

        foreach(read_text_num;0..meta.texts.length){
            auto sents=meta.texts[read_text_num].replaceSymbol.separateSentence;
            try{
                texts~=new Text(sents,read_text_num);
            }catch(stringToIntException stie){
                writeError(stie);
            }catch(NoTextNumberException ntne){
                writeError(ntne);
            }catch(stringToFloatException stfe){
                writeError(stfe);
            }catch(ScoreException se){
                writeError(se);
            }catch(ElementEmptyException eee){
                writeError(eee);
            }

        }
        debugSpace2(texts);
    }
}

auto debugSpace2(Text[] texts){
    "debugSpace2 called".writeln;
    import std.file,std.algorithm,std.array;
    append(meta.outputfilename~".csv","a,b,score1,score2,....\n");
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
    append(meta.outputfilename~".csv",results.join("\n"));

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

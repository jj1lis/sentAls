module context.io;

import std.stdio;
import std.file:FileException;
import std.conv;
import std.array:join;
import std.algorithm;
import std.array;


import utils.io;
import utils.various;
import utils.exception;
import context.text;
import context.pos;

auto writeText(Text target,string filename=meta.filename~".ctx"){
    string[] lines;
    {
        scope(exit) lines~="<#>,"~to!string(target.number)~","~target.score.to!string;
        foreach(s;target.sentences){
            scope(exit) lines~="<%>,"~to!string(s.number)~","~s.score.to!string;
            foreach(p;s.phrases){
                scope(exit) lines~="<$>,"~to!string(p.number)~","~p.score.to!string;
                foreach(w;p.words){
                    lines~=w.morpheme()~","~w.poses.pos.to!string~","~w.poses.subpos1.to!string~
                        ","~w.poses.subpos2.to!string~","~w.poses.subpos3.to!string~","~w.base;
                }
            }
        }
    }
    try{
        outputln(filename,lines.join("\n"));
    }catch(FileException fe){
        stderr.writeln("error: "~fe.msg);
    }
}

auto writeAnalysis(Text target,string filename=meta.filename~".als"){
    import std.string:detab;
    string[] lines;
    {
        lines~="<#text:"~target.number.to!string~">";
        scope(exit) lines~="</text>";
        lines~=cast(string)"\tscore:".detab(2)~target.score.to!string;
        foreach(s;target.sentences){
            lines~=cast(string)"\t<%sentence:".detab(2)~s.number.to!string~">";
            scope(exit) lines~=cast(string)"\t</sentence>".detab(2);
            lines~=cast(string)"\t\tscore           :".detab(2)~s.score.to!string;
            foreach(p;s.phrases){
                lines~=cast(string)"\t\t<$phrase:".detab(2)~p.number.to!string~">";
                scope(exit) lines~=cast(string)"\t\t</phrase>".detab(2);
                lines~=cast(string)"\t\t\tscore      :".detab(2)~p.score.to!string;
                lines~=cast(string)"\t\t\tdepend on  :phrase ".detab(2)~p.dependency.to!string;
                lines~=cast(string)"\t\t\tbe depended:by phrase ".detab(2)~p.getBe_depended.to!string;
                lines~=cast(string)"\t\t\tweight     :".detab(2)~p.weight.to!string;
                foreach(w;p.words){
                    lines~=cast(string)"\t\t\t<word:".detab(2)~w.number.to!string~">";
                    scope(exit) lines~=cast(string)"\t\t\t</word>".detab(2);
                    lines~=cast(string)"\t\t\t\tscore   :".detab(2)~w.score.to!string;
                    lines~=cast(string)"\t\t\t\tmorpheme:".detab(2)~w.morpheme;
                    lines~=cast(string)"\t\t\t\tpos     :".detab(2)~w.poses.pos.to!string;
                    lines~=cast(string)"\t\t\t\tsubpos1 :".detab(2)~w.poses.subpos1.to!string;
                    lines~=cast(string)"\t\t\t\tsubpos2 :".detab(2)~w.poses.subpos2.to!string;
                    lines~=cast(string)"\t\t\t\tsubpos3 :".detab(2)~w.poses.subpos3.to!string;
                    lines~=cast(string)"\t\t\t\tbase    :".detab(2)~w.base;
                }
            }
        }
    }
    try{
        outputln(filename,lines.join("\n"));
    }catch(FileException fe){
        stderr.writeln("error: "~fe.msg);
    }
}

auto writeCalcLog(T)(string log,T target,string filename=meta.filename~".log"){
    string type=typeof(target).stringof;
    try{
        outputln(filename,log~" "~type~" "~target.number.to!string);
    }catch(FileException fe){
        stderr.writeln("error: "~fe.msg);
    }
}

auto writeCalcLog(string log,string filename=meta.filename~".log"){
    try{
        outputln(filename,log);
    }catch(FileException fe){
        stderr.writeln("error: "~fe.msg);
    }
}

auto writeSummary(Text target,string filename=meta.filename~".sum"){
    string[] lines;
    foreach(s;target.sentences){
        foreach(p;s.phrases){
            foreach(w;p.words){
                lines~=w.morpheme;
            }
        }
    }
    lines~=":score->"~target.score.to!string;
    try{
        outputln(filename,lines.join);
    }catch(FileException fe){
        stderr.writeln("error: "~fe.msg);
    }
}

auto cursorIdiom(Word[] words){
    import std.range:iota;
    assert(words.length>0);
    int head=0;
    int[] cursor=new int[words.length];
    cursor[]=-1;
    while(head<words.length){
        int[] candidates=iota(meta.dictionary.idiom.length.to!int).array;
        foreach(i;head..words.length.to!int){
            candidates=searchIdiom(words[head..i+1],candidates);
            if(candidates.length==1){
                cursor[head..i]=candidates[0];
                continue;
            }else if(candidates.length==0){
                head=head==i?i+1:i;
                break;
            }
        }
    }
    return cursor;
}

auto searchIdiom(Word[] words,int[] candidates_front){
    assert(words.length>0);
    auto str=words.length==1?words[0..1].map!(w=>w.morpheme).array:words[0..$-2].map!(w=>w.morpheme).array~words[$-1].suitable;
    int[] candidates;
    foreach(l;candidates_front){
        auto dic=meta.dictionary.idiom[l].split(",")[0].split;
        if(dic.length>=str.length&&dic[0..str.length-1].equal(str)){
            candidates~=l;
        }
    }
    return candidates;
}

auto getWordScore(Word word){//TODO
    import std.string;
    string[] dic;
    real word_score;
    switch(word.poses.pos){
        case Pos.noun:
            dic=meta.dictionary.noun;
            break;
        case Pos.adject,Pos.verb:
            dic=meta.dictionary.precaution;
            break;
        default:
            return real.nan;
    }
    foreach(line;dic){
        if(line.split(",")[0]==word.suitable){
            return line.split(",")[1].chomp.to!real;
        }
    }
    return real.nan;
}

auto getIdiomScore(int line){
    import std.string;
    assert(line<meta.dictionary.idiom.length);
    return meta.dictionary.idiom[line].split(",")[1].to!real;
}

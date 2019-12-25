module context.io;

import std.stdio;
import std.file;
import std.string;
import std.conv;
import std.array:join;

import utils.io;
import utils.meta;
import utils.exception;
import context.calc;
import context.text;
import context.pos;

auto separateText(string[] file_lines,int text_number){
    string[] tmp_text;
    int cnt_text;
    for(int cnt=0;cnt<file_lines.length;cnt++){
        if(file_lines[cnt].split(",")[0]!="<#>"){
            tmp_text.length++;
            tmp_text[cnt_text]=file_lines[cnt];
            cnt_text++;
        }else if(to!int(file_lines[cnt].split(",")[1])==text_number){
            return tmp_text;
        }else{
            tmp_text.length=0;
            cnt_text=0;
        }
    }
    throw new NoTextNumberException(text_number);
}

auto textNums(string[] filelines){
    int[] text_nums;
    foreach(line;filelines){
        if(line.split(",")[0]=="<#>"){
            text_nums~=line.split(",")[1].to!int;
        }
    }
    return text_nums;
}
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
        appendln(filename,lines.join("\n"));
    }catch(FileException fe){
        stderr.writeln("error: "~fe.msg);
    }
}

auto writeAnalysis(Text target,string filename=meta.filename~".als"){
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
                lines~=cast(string)"\t\t\tdepend on  :phrase ".detab(2)~p.dependency.to!string;
                lines~=cast(string)"\t\t\tbe depended:by phrase ".detab(2)~p.getBe_depended.to!string;
                lines~=cast(string)"\t\t\tweight     :".detab(2)~p.weight.to!string;
                foreach(w;p.words){
                    lines~=cast(string)"\t\t\t<word:".detab(2)~w.number.to!string~">";
                    scope(exit) lines~=cast(string)"\t\t\t</word>".detab(2);
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
        appendln(filename,lines.join("\n"));
    }catch(FileException fe){
        stderr.writeln("error: "~fe.msg);
    }
}

auto writeCalcLog(T)(string log,T target,string filename=meta.filename~".log"){
    string type=typeof(target).stringof;
    try{
        appendln(filename,log~" "~type~" "~target.number.to!string);
    }catch(FileException fe){
        stderr.writeln("error: "~fe.msg);
    }
}

auto writeCalcLog(string log,string filename=meta.filename~".log"){
    try{
        appendln(filename,log);
    }catch(FileException fe){
        stderr.writeln("error: "~fe.msg);
    }
}

auto writeSummary(Text target,string filename=meta.filename~".sum"){
    string[] lines;
    foreach(s;target.sentences){
        scope(exit) lines~="。";
        foreach(p;s.phrases){
            foreach(w;p.words){
                lines~=w.morpheme;
            }
        }
    }
    lines~=":score->"~target.score.to!string;
    try{
        appendln(filename,lines.join);
    }catch(FileException fe){
        stderr.writeln("error: "~fe.msg);
    }
}

auto getWordScore(Word word){
    string[] dic;
    real word_score;
          switch(word.poses.pos){
              case Pos.noun:
                  dic=meta.dictionary.noun;
                  break;
              case Pos.adject:
                  dic=meta.dictionary.adject;
                  break;
              case Pos.verb:
                  dic=meta.dictionary.verb;
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

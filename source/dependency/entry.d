module dependency.entry;

import std.stdio;
import std.conv;
import std.regex;
import std.string;
import include.cabocha;

auto dependencyEntry(string text){
    assert(!match(text,r".*\n"));
    auto sentences=text.replaceSymbol.separateSentence;
    string[] tmp;

    try{
        foreach(sentence;sentences){
            auto parser=createParser("");
            auto tree=parser.parse(sentence.toStringz);
            foreach(i;0..tree.size+1){
                auto token=tree.token(i);
                if(token.chunk){
                    tmp~="$";
                    tmp~=token.chunk.link.to!string;
                }
                tmp~="&";
                tmp~=token.surface;
                tmp~=token.getBase;
                foreach(j;0..5){
                    tmp~=token.feature_list[j];
                }
            }
        }
    }catch(Exception ex){
        stderr.writeln("error: CaboCha calling faild: "~ex.msg);
    }
    return tmp;
}

string getBase(const Token* token) {
    if (token.feature_list_size > 6 && token.feature_list[6] != string("*"))
        return token.feature_list[6];
    return token.surface;
}

auto replaceSymbol(string text){
    text=replace(text,regex("!","g"),"！");
    text=replace(text,regex("?","g"),"？");
    text=replace(text,regex(",","g"),"、");
    return text;
}

auto separateSentence(string text){
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
    return sentences;
}

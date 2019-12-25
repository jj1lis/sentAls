module dependency.link;

import std.string;
import std.conv;
import utils.exception;
import dependency.analyze;
import context.text;

extern(C++){
    char* analyzeCaboCha(const char* sentence);
}

string linkCaboCha_cpp(string sentence){
    return analyzeCaboCha(sentence.toStringz).to!string;
}

RawPhrase[] wrapedCaboCha(string sentence){
    import std.algorithm:splitter;
    import std.array:array;
    auto analyzed_raw=sentence.linkCaboCha_cpp.split("|")[1..$-1];
    RawPhrase[] phrases;
    foreach(phrase;analyzed_raw.splitter("$").array[1..$]){
        RawWord[] words=new RawWord[0];
        foreach(word;phrase.splitter("&").array[1..$]){
            words~=new RawWord(word[0],word[1],word[2],word[3],word[4],word[5],word[6],word[7],word[8]);
        }
        phrases~=new RawPhrase(phrase[0].to!int,words);
    }
    return phrases;
}

module dependency.link;

import std.string;
import std.conv;

extern(C++){
    char* analyzeCaboCha(const char* sentence);
}

string analyzeDependency(string sentence){
    return analyzeCaboCha(sentence.toStringz).to!string;
}

void main(){
    import std.stdio;
    "おはようございます".analyzeDependency.writeln;
}

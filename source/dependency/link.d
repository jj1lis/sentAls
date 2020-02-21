module dependency.link;

import std.string:toStringz;
import std.conv:to;

extern(C++) char* analyzeCaboCha(const char* sentence);

string linkCaboCha_cpp(string sentence){
    return analyzeCaboCha(sentence.toStringz).to!string;
}


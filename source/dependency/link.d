module dependency.link;

import std.string:toStringz;
import std.conv:to;

extern(C++) char* analyzeCaboCha(const char* sentence);

@system:

string linkCaboCha_cpp(const string sentence){
    return analyzeCaboCha(sentence.toStringz).to!string;
}

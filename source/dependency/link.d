module dependency.link;

import dependency.analyze;

extern(C++){
    char* analyzeCaboCha(const char* sentence);
}

string linkCaboCha_cpp(string sentence){
    import std.string:toStringz;
    import std.conv:to;
    return analyzeCaboCha(sentence.toStringz).to!string;
}

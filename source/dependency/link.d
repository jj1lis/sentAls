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


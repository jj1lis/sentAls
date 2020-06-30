module dependency.link;

import std.string:toStringz;
import std.conv:to;

extern(C++) const char* analyzeCaboCha(const char* sentence);
/*****
    "$<dependency>&<morpheme>|<pos>|<subpos1>|<sbpos2>|<subpos3>|<conjugate form>|<conjucate type>|<base>|<reading>|<pronunciation>"
*****/

@system:

string linkCaboCha_cpp(const string sentence){
    return analyzeCaboCha(sentence.toStringz).to!string;
}

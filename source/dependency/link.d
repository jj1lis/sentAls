module dependency.link;

import std.string:toStringz;
import std.conv:to;

extern(C++)char* analyzeCaboCha(const char* sentence);
/*****
    "$<dependency>&<morpheme>|<pos>|<subpos1>|<sbpos2>|<subpos3>|<conjugate form>|<conjucate type>|<base>|<reading>|<pronunciation>"
*****/

@system:

string linkCaboCha_cpp(const string sentence){
    return analyzeCaboCha(sentence.toStringz).to!string;
}

unittest{
    import std;
    enum test="毎度おなじみ流浪の番組、タモリ倶楽部でございます。";
    test.writeln;
    typeof(test.toStringz.analyzeCaboCha).stringof.writeln;
}

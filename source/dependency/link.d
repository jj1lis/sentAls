module dependency.link;

import std.string:toStringz;
import std.conv:to;

extern(C++,CaboCha){//TODO
    class Chunk{
        int link();
        float score;
        int feature_list_size();
    }
    class Token{
        Chunk chunk();
        const char* feature();
    }
    class Tree{
        Chunk chunk(int);
        int chunk_size();
        Token token(int);
        int token_size();
    }
    class Parser{
        Tree parse(const char*);
    }

        Parser getCaboChaParser();
    /*****
      "$<dependency>&<morpheme>|<pos>|<subpos1>|<sbpos2>|<subpos3>|<conjugate form>|<conjucate type>|<base>|<reading>|<pronunciation>"
     *****/
}

@system:

//string linkCaboCha_cpp(const string sentence){
//    return analyzeCaboCha(sentence.toStringz).to!string;
//}

//unittest{
//    import std;
//    enum test="毎度おなじみ流浪の番組、タモリ倶楽部でございます。";
//    test.writeln;
//    typeof(test.toStringz.analyzeCaboCha).stringof.writeln;
//}

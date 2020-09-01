module dependency.link;

import std.string:toStringz;
import std.conv:to;
import std.algorithm;
import std.array;

extern(C++ ,CaboCha){//TODO
    class Chunk{
        int link();
        float score;
        ushort feature_list_size();
    }
    class Token{
        Chunk chunk();
        const char* feature();
        const char** feature_list();
        ushort feature_list_size();
        const char* surface();
    }
    class Tree{
        int size();
        Chunk chunk(int);
        int chunk_size();
        Token token(int);
        int token_size();
    }
    class Parser{
        Tree parse(const char*);
    }

    Parser getCaboChaParser();
}

@system:

/*****
  "$<dependency>&<morpheme>|<pos>|<subpos1>|<sbpos2>|<subpos3>|<conjugate form>|<conjugate type>|<base>|<reading>|<pronunciation>"
 *****/

string linkCaboCha_cpp(const string sentence){
    auto tree=getCaboChaParser.parse(sentence.toStringz);
    import std;
    return tree.size.iota.map!((i){
        string result;
        auto token=tree.token(i);
        if(token.chunk)
            result~="$"~token.chunk.link.to!string;
        result~="&"~token.surface.to!string~"|";
        return result~token.feature_list_size.iota.map!(j=>
            token.feature_list[j].to!string~(j==token.feature_list_size-1?"":"|")
        ).join;
    }).join;
}

@safe nothrow struct CaboChaData{
    private:
        int _number;
        int _depends;
        CaboChaWord[] _words;
    public:
        struct CaboChaWord{
            private:
                string _morpheme;
                string _pos;
                string _subpos1;
                string _subpos2;
                string _subpos3;
                string _conjugate_form;
                string _conjugate_type;
                string _base;
                string _reading;
                string _pronunciation;
            public:
                @property{
                    auto morpheme(){return this._morpheme;}
                    auto pos(){return this._pos;}
                    auto subpos1(){return this._subpos1;}
                    auto subpos2(){return this._subpos2;}
                    auto subpos3(){return this._subpos3;}
                    auto conjugate_form(){return this._conjugate_form;}
                    auto conjugate_type(){return this._conjugate_type;}
                    auto base(){return this._base;}
                    auto reading(){return this._reading;}
                    auto pronunciation(){return this._pronunciation;}
                }
                this(string[] texts){
                    this._morpheme=texts[0];
                    this._pos=texts[1];
                    this._subpos1=texts[2];
                    this._subpos2=texts[3];
                    this._subpos3=texts[4];
                    this._conjugate_form=texts[5];
                    this._conjugate_type=texts[6];
                    if(texts.length==10){
                        this._base=texts[7];
                        this._reading=texts[8];
                        this._pronunciation=texts[9];
                    }else{
                        this._base="*";
                        this._reading="*";
                        this._pronunciation="*";
                    }
                }

        }

        this(int _number,int _depends,string[] texts){
            this._number=_number;
            this._depends=_depends;
            this._words=texts.splitter("|").map!(t=>CaboChaWord(t)).array;
        }
}

class CaboChaPacket{
    private:
        CaboChaData[] _data;
        Parser _parser;
        Tree _tree;
    public:
        @property CaboChaData[] data(){return _data;}
        this(const string sentence){
            this._parser=getCaboChaParser;
            this._tree=this._parser.parse(sentence.toStringz);
            int number,depends;
            string[] texts;
            bool first=true;
            foreach(i;0.._tree.size){
                auto token=_tree.token(i);
                if(token.chunk){
                    if(!first){
                        _data~=CaboChaData(number,depends,texts);
                        texts=[];
                        number++;
                    }
                    depends=token.chunk.link;
                }else
                    texts~="|";
                texts~=token.surface.to!string;
                import std.range:iota;
                texts~=token.feature_list_size.iota.map!(j=>token.feature_list[j].to!string).array;
            }
        }

}


//unittest{
//    import std;
//    enum test="毎度おなじみ流浪の番組、タモリ倶楽部でございます。";
//    test.writeln;
//    typeof(test.toStringz.analyzeCaboCha).stringof.writeln;
//}

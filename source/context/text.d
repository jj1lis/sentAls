module context.text;

import std.stdio;
import std.string;
import std.conv;
import std.traits:isNumeric;
import std.range;
import std.algorithm;

import utils.exception;
import context;
import dependency.analyze;

@safe:

enum inf(R)()if(isNumeric!R){return R.max/4;}

class Common{
    private:
        size_t _number;
        size_t _parent_number;
        size_t _granpa_number;
        size_t _dgranpa_number;

    public:

        @property{
            auto number(){return _number;}
            auto parent_number(){return _parent_number;}
            auto granpa_number(){return _granpa_number;}
            auto dgranpa_number(){return _dgranpa_number;}
        }

        this(size_t number,size_t parent_number=inf!size_t,
                size_t granpa_number=inf!size_t,size_t dgranpa_number=inf!size_t){
            this._number=number;
            this._parent_number=parent_number;
            this._granpa_number=granpa_number;
            this._dgranpa_number=dgranpa_number;
        }
}

class Word:Common{
    private: 
        string _morpheme;
        Poses _poses;
        size_t _pos_id;
        string _base;
        string _conjugate_form;
        string _conjugate_type;
        string _reading;
        string _pronunciation;

    public:

        @property{
            auto morpheme(){return _morpheme;}
            auto poses(){return _poses;}
            auto pos_id(){return _pos_id;}
            auto base(){return _base;}
            auto conjugate_form(){return _conjugate_form;}
            auto conjucate_type(){return _conjugate_type;}
            auto reading(){return _reading;}
            auto pronunciation(){return _pronunciation;}
        }

        this(RawWord raw_word,size_t number,size_t phrase_number,size_t sent_number,size_t text_number){
            super(number,phrase_number,sent_number,text_number);
            _morpheme=raw_word.morpheme;
            _base=raw_word.base;
            _conjugate_form=raw_word.conjugate_form;
            _conjugate_type=raw_word.conjucate_type;
            _reading=raw_word.reading;
            _pronunciation=raw_word.pronunciation;

            _pos_id=raw_word.raw_pos_id;
            _poses=context.pos.to!Poses(this._pos_id);
        }

        auto suitable(){
            if(_base=="*"){
                return morpheme;
            }
            return _base;
        }
}

class Phrase:Common{
    private:
        Word[] _words;
        size_t _dependency;
        size_t[] be_depended;
        int _weight;
        real score_phrase;

    public:

        @property{
            auto words(){return _words;}
            auto dependency(){return _dependency;}
            auto weight(){return _weight;}
            auto weight(int w){_weight=w;}
            auto score(){return score_phrase;}
            auto score(real s){score_phrase=s;}
        }

        this(RawPhrase raw_phrase,size_t number,size_t sent_number,size_t text_number){
            super(number,sent_number,text_number);
            if(raw_phrase.words.length==0){
                throw new ElementEmptyException(this.number,this.parent_number,this.granpa_number);
            }
            _dependency=raw_phrase.dependency;
            raw_phrase.words.length.iota.
                each!(i=>_words~=new Word(raw_phrase.words[i],i,this.number,this.parent_number,this.granpa_number));
        }

        auto enqueueBe_depended(size_t d){
            be_depended~=d;
        }

        auto getBe_depended(){
            return be_depended;
        }
}

class Sentence:Common{
    private:
        Phrase[] _phrases;
        real score_sent;

    public:
        @property{
            auto phrases(){return _phrases;}
            auto score(){return score_sent;}
            auto score(real scr){score_sent=scr;}
        }

        this(RawPhrase[] raw_phrases,size_t number,size_t text_number){
            super(number,text_number);
            if(raw_phrases.length==0){
                throw new ElementEmptyException(this.number,this.parent_number);
            }
            raw_phrases.length.iota.
                each!(i=>_phrases~=new Phrase(raw_phrases[i],i,this.number,this.parent_number));

            foreach(p;_phrases){
                if(p.dependency>=0){
                    _phrases[p.dependency].enqueueBe_depended(p.number);
                }else{
                    assert(p.dependency==inf!size_t);
                }
            }
        }
}

@system class Text:Common{
    private:
        Sentence[] _sentences;
        real score_text=0;

    public:

        @property{
            auto sentences(){return _sentences;}
            auto score(){return score_text;}
            auto score(real scr){
                score_text=scr;
            }
        }

        this(const string[] sents,size_t number){
            super(number);
            if(sents.length==0){
                throw new ElementEmptyException(this.number);
            }
            sents.length.iota.
                each!(i=>_sentences~=new Sentence(sents[i].analyzeDependency,i,this.number));
        }
//        unittest{
//            "そういえば、あなたのお父さんはどちらにお勤めですか？".analyzeDependency;
//        }
}

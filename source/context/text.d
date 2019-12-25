module context.text;

import std.stdio;
import std.string;
import std.conv;

import utils.exception;
import context.pos;
import context.calc;
import dependency.analyze;

class Common{
    private int _number;
    private int _parent_number=-1;
    private int _granpa_number=-1;
    private int _dgranpa_number=-1;

    @property{
        auto number(){return _number;}
        auto parent_number(){return _parent_number;}
        auto granpa_number(){return _granpa_number;}
        auto dgranpa_number(){return _dgranpa_number;}
    }

    this(int number){
        this._number=number;
    }

    this(int number,int parent_number){
        this._number=number;
        this._parent_number=parent_number;
    }

    this(int number,int parent_number,int granpa_number){
        this._number=number;
        this._parent_number=parent_number;
        this._granpa_number=granpa_number;
    }

    this(int number,int parent_number,int granpa_number,int dgranpa_number){
        this._number=number;
        this._parent_number=parent_number;
        this._granpa_number=granpa_number;
        this._dgranpa_number=dgranpa_number;
    }
}

class Word:Common{
    private string _morpheme;
    private Poses _poses;
    private int _pos_id;
    private string _base;
    private string _conjugate_form;
    private string _conjugate_type;
    private string _reading;
    private string _pronunciation;

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

    this(RawWord raw_word,int number,int phrase_number,int sent_number,int text_number){
        super(number,phrase_number,sent_number,text_number);
        _morpheme=raw_word.morpheme;
        _base=raw_word.base;
        _conjugate_form=raw_word.conjugate_form;
        _conjugate_type=raw_word.conjucate_type;
        _reading=raw_word.reading;
        _pronunciation=raw_word.pronunciation;

        _pos_id=raw_word.raw_pos_id;
        _poses=idToPoses(this._pos_id);
    }

    auto suitable(){
        if(_base=="*"){
            return morpheme;
        }
        return _base;
    }
}

class Phrase:Common{
    private Word[] _words;
    private int _dependency;
    private int[] be_depended;
    private uint _weight;

    @property{
        auto words(){return _words;}
        auto dependency(){return _dependency;}
        auto weight(){return _weight;}
        auto weight(uint w){_weight=w;}
    }

    this(RawPhrase raw_phrase,int number,int sent_number,int text_number){
        super(number,sent_number,text_number);
        if(raw_phrase.words.length==0){
            throw new ElementEmptyException(this.number,this.parent_number,this.granpa_number);
        }
        _dependency=raw_phrase.dependency;
        foreach(cnt;0..raw_phrase.words.length.to!int){
            _words~=new Word(raw_phrase.words[cnt],cnt,this.number,this.parent_number,this.granpa_number);
        }
    }

    auto enqueueBe_depended(int d){
        be_depended~=d;
    }

    auto getBe_depended(){
        return be_depended;
    }
}

class Sentence:Common{
    private Phrase[] _phrases;
    private float score_sent;

    @property{
        auto phrases(){return _phrases;}
        auto score(){return score_sent;}
        auto score(real scr){score_sent=scr;}
    }

    this(RawPhrase[] raw_phrases,int number,int text_number){
        super(number,text_number);
        if(raw_phrases.length==0){
            throw new ElementEmptyException(this.number,this.parent_number);
        }
        foreach(cnt;0..raw_phrases.length.to!int){
            _phrases~=new Phrase(raw_phrases[cnt],cnt,this.number,this.parent_number);
        }

        foreach(p;_phrases){
            if(p.dependency>=0){
                _phrases[p.dependency].enqueueBe_depended(p.number);
            }else{
                assert(p.dependency==-1);
            }
        }
    }
}

class Text:Common{
    private Sentence[] _sentences;
    private real score_text=0;

    @property{
        auto sentences(){return _sentences;}
        auto score(){return score_text;}
        auto score(real scr){
            score_text=scr;
        }
    }

    this(string[] sents,int number){
        super(number);
        if(sents.length==0){
            throw new ElementEmptyException(this.number);
        }
        foreach(cnt;0..sents.length.to!int){
            _sentences~=new Sentence(sents[cnt].analyzeDependency,cnt,this.number);
        }
    }
}

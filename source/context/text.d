module context.text;

import std.stdio;
import std.string;
import std.conv;

import utils.exception;
import context.pos;
import context.calc;

class Common{
    private int _number;
    private int _parent_number=-1;
    private int _granpa_number=-1;
    private int _dgranpa_number=-1;

    @property{
        int number(){return _number;}
        int parent_number(){return _parent_number;}
        int granpa_number(){return _granpa_number;}
        int dgranpa_number(){return _dgranpa_number;}
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

    @property{
        auto morpheme(){return _morpheme;}
        auto poses(){return _poses;}
        auto pos_id(){return _pos_id;}
        auto base(){return _base;}
    }

    this(string line_word,int number,int phrase_number,int stc_number,int text_number){
        super(number,phrase_number,stc_number,text_number);
        if(line_word.length==0){
            throw new ElementEmptyException(this.number);
        }
        auto record=line_word.split(",");
        _morpheme=record[0];
        try{
            _pos_id=to!int(record[1]);
            _poses=idToPoses(_pos_id);
        }catch(Exception ex){
            if(record[1]==""){
                _pos_id=-1;
                _poses=Poses(Pos.unknown);
            }else{
                throw new stringToIntException(record[1],this.number,
                        parent_number,granpa_number,dgranpa_number);
            }
        }
        _base=record[2];
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
    private int[] be_depended=new int[0];
    private uint _weight;

    @property{
        auto words(){return _words;}
        auto dependency(){return _dependency;}
        auto weight(){return _weight;}
        auto weight(uint w){_weight=w;}
    }

    this(string[] line_phrase,int number,int stc_number,int text_number,int depend_to){
        super(number,stc_number,text_number);
        if(line_phrase.length==0){
            throw new ElementEmptyException(this.number);
        }
        _dependency=depend_to;
        _words=new Word[line_phrase.length];
        foreach(cnt;0..line_phrase.length.to!int){
            try{
                _words[cnt]=new Word(line_phrase[cnt],cnt,this.number,parent_number,granpa_number);
            }catch(stringToIntException stie){
                stderr.writeln("error: "~stie.msg);
            }
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
    private float score_frontstage;
    private real score_sentence;

    @property{
        auto phrases(){return _phrases;}
        auto score(){return score_sentence;}
        auto score(real scr){score_sentence=scr;}
        auto scorefront(){return score_frontstage;}
    }

    this(string[] line_sentence,float score,int number,int text_number){
        super(number,text_number);
        if(line_sentence.length==0){
            throw new ElementEmptyException(this.number);
        }
        score_frontstage=score;
        _phrases=new Phrase[0];
        string[] tmp_phrase;
        int cnt_phrase;
        foreach(cnt;0..line_sentence.length){
            if(line_sentence[cnt].split(",")[0]!="<$>"){
                tmp_phrase~=line_sentence[cnt];
            }else{
                auto exflag=false;
                int phrase_number,dependency;
                try{
                    phrase_number=line_sentence[cnt].split(',')[1].to!(int);
                    dependency=line_sentence[cnt].split(',')[2].to!(int);
                }catch(Exception ex){
                    exflag=true;
                    throw new stringToIntException("element in phrase",
                            cnt_phrase,this.number,parent_number);
                }
                if(exflag){
                    _phrases~=new Phrase(tmp_phrase,cnt_phrase,
                            this.number,parent_number,-1);
                }else{
                    _phrases~=new Phrase(tmp_phrase,phrase_number,
                            this.number,parent_number,dependency);
                }
                tmp_phrase.length=0;
                cnt_phrase++;
            }
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
        auto setScore(real score){
            //assert(score<=100&&score>=-100);
            score_text=score;
        }
    }

    this(string[] line_text,int number){
        super(number);
        if(line_text.length==0){
            throw new ElementEmptyException(this.number);
        }
        _sentences=new Sentence[0];
        string[] tmp_sentence;
        int cnt_sentence;
        foreach(cnt;0..line_text.length){
            if(line_text[cnt].split(",")[0]!="<%>"){
                tmp_sentence~=line_text[cnt];
            }else{
                float score_sentence;
                try{
                    score_sentence=to!float(line_text[cnt].split(",")[1]);
                }catch(Exception ex){
                    throw new stringToFloatException(line_text[cnt].split(",")[1],cnt_sentence,this.number);
                }
                if(score_sentence<-1.||score_sentence>1.){
                    throw new ScoreException(-1.,1.,cnt_sentence,this.number);
                }
                try{
                    _sentences~=new Sentence(tmp_sentence,score_sentence,cnt_sentence,this.number);
                }catch(stringToIntException stie){
                    stderr.writeln("error: "~stie.msg);
                }
                tmp_sentence.length=0;
                cnt_sentence++;
            }
        }
    }
}

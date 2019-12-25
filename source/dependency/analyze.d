module dependency.analyze;

import std.stdio;
import std.conv;
import std.string;

import dependency.link;

auto analyzeDependency(string sent){
    return sent.wrapedCaboCha;
}

class RawPhrase{
    private int _dependency;
    private RawWord[] _words;
    invariant(_dependency>=-1);
    @property{
        int dependency(){return _dependency;}
        RawWord[] words(){return _words;}
    }
    this(int _dependency,RawWord[] _words){
        this._dependency=_dependency;
        this._words=words;
    }
}

class RawWord{
    private string _morpheme;
    private string _pos;
    private string _subpos1;
    private string _subpos2;
    private string _subpos3;
    private string _conjugate_form;
    private string _conjugate_type;
    private string _base;
    private string _reading;
    private string _pronunciation;
    private int _raw_pos_id;

    invariant(_raw_pos_id>=0);

    @property{
        string morpheme(){return _morpheme;}
        string pos(){return _pos;}
        string subpos1(){return _subpos1;}
        string subpos2(){return _subpos2;}
        string subpos3(){return _subpos3;}
        string conjugate_form(){return _conjugate_form;}
        string conjucate_type(){return _conjugate_type;}
        string base(){return _base;}
        string reading(){return _reading;}
        string pronunciation(){return _pronunciation;}
        int raw_pos_id(){return _raw_pos_id;}
    }

    this(string _morpheme,string _pos,string _subpos1,string _subpos2,string _subpos3,string _conjugate_form,string _conjugate_type,string _base,string _pronunciation){
        this._morpheme=_morpheme;
        this._pos=_pos;
        this._subpos1=_subpos1;
        this._subpos2=_subpos2;
        this._subpos3=_subpos3;
        this._conjugate_form=_conjugate_form;
        this._conjugate_type=_conjugate_type;
        this._base=_base;
        this._reading=_reading;
        this._pronunciation=_pronunciation;
        this._raw_pos_id=getRaw_pos_id(_pos,_subpos1,_subpos2,_subpos3);
    }

    private int getRaw_pos_id(string pos,string subpos1,string subpos2,string subpos3){
        if(pos=="その他"){
            if(subpos1=="間投"){
                return 0;
            }
        }else if(pos=="フィラー"){
            return 1;
        }else if(pos=="感動詞"){
            return 2;
        }else if(pos=="記号"){
            if(subpos1=="アルファベット"){
                return 3;
            }else if(subpos1=="一般"){
                return 4;
            }else if(subpos1=="括弧開"){
                return 5;
            }else if(subpos1=="括弧閉"){
                return 6;
            }else if(subpos1=="句点"){
                return 7;
            }else if(subpos1=="空白"){
                return 8;
            }else if(subpos1=="読点"){
                return 9;
            }
        }else if(pos=="形容詞"){
            if(subpos1=="自立"){
                return 10;
            }else if(subpos1=="接尾"){
                return 11;
            }else if(subpos1=="非自立"){
                return 12;
            }
        }else if(pos=="助詞"){
            if(subpos1=="格助詞"){
                if(subpos2=="一般"){
                    return 13;
                }else if(subpos2=="引用"){
                    return 14;
                }else if(subpos2=="連語"){
                    return 15;
                }
            }else if(subpos1=="係助詞"){
                return 16;
            }else if(subpos1=="終助詞"){
                return 17;
            }else if(subpos1=="接続助詞"){
                return 18;
            }else if(subpos1=="特殊"){
                return 19;
            }else if(subpos1=="副詞化"){
                return 20;
            }else if(subpos1=="副助詞"){
                return 21;
            }else if(subpos1=="副助詞／並立助詞／終助詞"){
                return 22;
            }else if(subpos1=="並立助詞"){
                return 23;
            }else if(subpos1=="連体化"){
                return 24;
            }
        }else if(pos=="助動詞"){
            return 25;
        }else if(pos=="接続詞"){
            return 26;
        }else if(pos =="接頭詞"){
            if(subpos1=="形容詞接続"){
                return 27;
            }else if(subpos1=="数接続"){
                return 28;
            }else if(subpos1=="動詞接続"){
                return 29;
            }else if(subpos1=="名詞接続"){
                return 30;
            }
        }else if(pos=="動詞"){
            if(subpos1=="自立"){
                return 31;
            }else if(subpos1=="接尾"){
                return 32;
            }else if(subpos1=="非自立"){
                return 33;
            }
        }else if(pos=="副詞"){
            if(subpos1=="一般"){
                return 34;
            }else if(subpos1=="助詞類接続"){
                return 35;
            }
        }else if(pos=="名詞"){
            if(subpos1=="サ変接続"){
                return 36;
            }else if(subpos1=="ナイ形容詞語幹"){
                return 37;
            }else if(subpos1=="一般"){
                return 38;
            }else if(subpos1=="引用文字列"){
                return 39;
            }else if(subpos1=="形容動詞語幹"){
                return 40;
            }else if(subpos1=="固有名詞"){
                if(subpos2=="一般"){
                    return 41;
                }else if(subpos2=="人名"){
                    if(subpos3=="一般"){
                        return 42;
                    }else if(subpos3=="姓"){
                        return 43;
                    }else if(subpos3=="名"){
                        return 44;
                    }
                }else if(subpos2=="組織"){
                    return 45;
                }else if(subpos2=="地域"){
                    if(subpos3=="一般"){
                        return 46;
                    }else if(subpos3=="国"){
                        return 47;
                    }
                }
            }else if(subpos1=="数"){
                return 48;
            }else if(subpos1=="接続詞的"){
                return 49;
            }else if(subpos1=="接尾"){
                if(subpos2=="サ変接続"){
                    return 50;
                }else if(subpos2=="一般"){
                    return 51;
                }else if(subpos2=="形容動詞語幹"){
                    return 52;
                }else if(subpos2=="助数詞"){
                    return 53;
                }else if(subpos2=="助動詞語幹"){
                    return 54;
                }else if(subpos2=="人名"){
                    return 55;
                }else if(subpos2=="地域"){
                    return 56;
                }else if(subpos2=="特殊"){
                    return 57;
                }else if(subpos2=="副詞可能"){
                    return 58;
                }
            }else if(subpos1=="代名詞"){
                if(subpos2=="一般"){
                    return 59;
                }else if(subpos2=="縮約"){
                    return 60;
                }
            }else if(subpos1=="動詞非自立的"){
                return 61;
            }else if(subpos1=="特殊"){
                return 62;
            }else if(subpos1=="非自立"){
                if(subpos2=="一般"){
                    return 63;
                }else if(subpos2=="形容動詞語幹"){
                    return 64;
                }else if(subpos2=="助動詞語幹"){
                    return 65;
                }else if(subpos2=="副詞可能"){
                    return 66;
                }
            }else if(subpos1=="副詞可能"){
                return 67;
            }
        }else if(pos=="連体詞"){
            return 68;
        }
        assert(0);
    }
}

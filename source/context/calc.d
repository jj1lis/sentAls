module context.calc;

import std.conv;

import context.text;
import context.pos;
import context.io;

size_t[] cursorMainWord(Phrase phrase){
    auto words=phrase.words;
    int[] word_weight=new int[words.length];
    foreach(cnt;0..words.length-1){
        Poses poses=words[cnt].poses;
outer:switch(poses.pos){
          case Pos.verb:
              switch(poses.subpos1){
                  case Subpos1.independ:
                      word_weight[cnt]+=2;
                      break outer;
                  default:
                      word_weight[cnt]++;
                      break outer;
              }
          case Pos.noun:
              switch(poses.subpos1){
                  case Subpos1.proper:
                      word_weight[cnt]+=2;
                      break outer;
                  default:
                      word_weight[cnt]++;
                      break outer;
              }
          case Pos.adject,Pos.conjunct,Pos.adverb,Pos.rentai:
              word_weight[cnt]++;
              break;
          default:
      }
    }

    size_t[] weighests;
    int tmp_weighest;
    foreach(cnt;0..word_weight.length){
        if(tmp_weighest<word_weight[cnt]){
            tmp_weighest=word_weight[cnt];
            weighests.length=0;
            weighests~=cnt;
        }else if(tmp_weighest==word_weight[cnt]){
            weighests~=cnt;
        }
    }
    foreach(i;weighests){
    }

    return weighests;
}

void weightPhrase(Text target){
    Word[] words_inText=new Word[0];
    foreach(Sentence s;target.sentences){
        foreach(Phrase p;s.phrases){
            foreach(Word w;p.words){
                words_inText~=w;
            }
        }
    }

    size_t[string] word_weight;
    foreach(w;words_inText){
        if(w.suitable in word_weight){
            word_weight[w.suitable]++;
        }else{
            word_weight[w.suitable]=0;
        }
    }
    foreach(w;words_inText){
    }

    foreach(Sentence s;target.sentences){
        foreach(p;s.phrases){
            foreach(cursor;p.cursorMainWord){
                word_weight[p.words[cursor].suitable]+=p.getBe_depended.length;
            }
        }
        foreach(p;s.phrases){
            int phrase_weight;
            foreach(i;0..p.words.length){
                phrase_weight+=word_weight[p.words[i].suitable];
            }
            p.weight=phrase_weight;
        }
    }
}

auto calculateTextScore(Text target){
    real text_score_sum=0;
    weightPhrase(target);
    foreach(s;target.sentences){
        real sent_score_sum=0;
        int[] weights_inSentence;
        foreach(p;s.phrases){
            weights_inSentence~=p.weight;
        }
        foreach(p;s.phrases){
            p.score=p.rawscore*p.weight.getLankCoeff(weights_inSentence)/p.words.length;
            if(p.isNegative){
                p.score=p.score*-1;
            }
            sent_score_sum+=p.score;
        }
        s.score=sent_score_sum/cast(real)s.phrases.length;
        text_score_sum+=s.score;
    }
    return 100*text_score_sum/cast(real)target.sentences.length;
}

auto rawscore(Phrase p){
    real sum=0;
    int hit_counter;
    foreach(w;p.words){
        import std.math:isNaN;
        auto word_score=w.getWordScore;
        if(!word_score.isNaN){
            sum+=word_score;
            hit_counter++;
        }
    }
    return hit_counter!=0?sum/cast(real)hit_counter:0;
}

bool isNegative(Phrase p){
    foreach(w;p.words){
        if(w.isNegative){
            return true;
        }
    }
    return false;
}

auto isNegative(Word w){//TODO
    switch(w.base){
        case "ない":
        case "ず":
        case "ぬ":
        case "不":
        case "非":
        case "無":
            return true;
        default:
            return false;
    }
}


real getLankCoeff(int weight,int[] weights){
    enum lankCoeff{
        first=3.,
        second=2,
        third=1.5,
        Dedault=1.,
    }

    import std.algorithm;
    sort!("a>b")(weights);
    int lank=-1;
    foreach(i;0..weights.length){
        if(weight>=weights[i]){
            lank=i.to!int;
            break;
        }
    }
    switch(lank){
        case 1:
            return lankCoeff.first;
        case 2:
            return lankCoeff.second;
        case 3:
            return lankCoeff.third;
        default:
            return lankCoeff.Dedault;
    }
}

module context.calc;

import context.text;
import context.pos;
import context.io;

size_t[] cursorMainWord(Phrase phrase){
    auto words=phrase.words;
    size_t[] word_weight=new size_t[words.length];
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
    size_t tmp_weighest;
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
    auto word_weight=target.word_appearance;

    foreach(Sentence s;target.sentences){
        foreach(p;s.phrases){
            foreach(cursor;p.cursorMainWord){
                word_weight[p.words[cursor].suitable]+=p.getBe_depended.length;
            }
        }
        foreach(p;s.phrases){
            uint phrase_weight;
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
            p.score=p.phraseScore;
            auto phrase_score=p.score*p.weight.getLankCoeff(weights_inSentence);
            if(p.isNegative){
                phrase_score*=-1;
            }
            sent_score_sum+=phrase_score;
        }
        s.score=sent_score_sum/cast(real)s.phrases.length;
        text_score_sum+=s.score;
    }
    return text_score_sum/cast(real)target.sentences.length;
}

auto phraseScore(Phrase p){
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
    if(hit_counter!=0){
        return sum/cast(real)hit_counter;
    }else{
        return 0;
    }
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
        case "ない","ず","ぬ","不","無","非":
            return true;
        default:
            return false;
    }
}

enum lankCoeff{
    first=3.,
    second=2,
    third=1.5,
    Dedault=1.,
}

real getLankCoeff(int weight,const int[] weights){
    import std.algorithm;
    sort!("a>b")(weights.dup);
    int lank=-1;
    foreach(i;0..cast(int)weights.length){
        if(weight>=weights[i]){
            lank=i;
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

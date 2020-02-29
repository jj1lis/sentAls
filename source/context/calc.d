module context.calc;

import std.conv;

import context.text;
import context.pos;
import context.io;
import context.weighting;

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
            p.score=p.rawscore*p.weight.weighting(weights_inSentence)/p.words.length;
            if(p.isNegative){
                p.score=p.score*-1;
            }
            sent_score_sum+=p.score;
        }
        import utils.various,std.math;
        auto base=meta.weight_base;
        real integral=(1-1/base)/log(base)+1;
        /*
           integral(0_1) correctFunc(x) dx
          =integral(0_1) {base^(x-1)+1} dx
          =[base^(x-1) / log(base) + x](0_1)
          =(base^0 / log(base) + 1) - (base^(-1) / log(base))
          =( 1 - base^(-1) ) / log(base) + 1
          =( 1 - 1/base ) / log(base) + 1 ---QED.
        */
        //s.score=sent_score_sum/integral/s.phrases.length;
        s.score=sent_score_sum/s.phrases.length;

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

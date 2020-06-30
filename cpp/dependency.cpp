#include <cabocha.h>
#include <iostream>
#include <string>
#include <vector>
#include <cstdio>
using namespace std;

//TODO

const char* analyzeCaboCha(const char* sentence){
    basic_string<char> result;
    int cnt=0;
    try{
        auto parser=CaboCha::createParser("");
        auto tree=parser->parse(const_cast<char*>(sentence));
        for(unsigned int i=0;i<tree->size();i++){
            auto token=tree->token(i);
            if(token->chunk){
                result+="$";
                result+=to_string(token->chunk->link);
            }
            result+="&";
            result+=token->surface;
            for(int j=0;j<token->feature_list_size;j++){
                result+=token->feature_list[j];
                result+=(j==token->feature_list_size-1?"":"|");
            }
        }
    }catch(exception &ex){
        cerr<<ex.what()<<endl;
    }

    return result.data();
}

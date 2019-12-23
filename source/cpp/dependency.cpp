#include "include/cabocha.h"
#include <iostream>
#include <string>
#include <vector>
#include <cstdio>
using namespace std;

const char* getBase(const CaboCha::Token* token) {
    if (token->feature_list_size > 6 && token->feature_list[6] != string("*"))
        return token->feature_list[6];
    return token->surface;
}

const char** analyzeCaboCha(char* sentence){
        const char[100] *element;
        int cnt=0;
    try{
        CaboCha::Parser* parser=CaboCha::createParser("");
        const CaboCha::Tree *tree=parser->parse(sentence);
        for(unsigned int i=0;i<tree->size();i++){
            const CaboCha::Token *token=tree->token(i);
            if(token->chunk){
                element[cnt++]="$";
                sprintf(const_cast<char*>(element[cnt++]),"%d",token->chunk->link);
            }
            element[cnt++]="&";
            element[cnt++]=token->surface;
            element[cnt++]=getBase(token);
            for(int j=0;j<=4;j++){
                element[cnt++]=token->feature_list[j];
            }
        }
    }catch(exception &ex){
        cerr<<ex.what()<<endl;
    }
    return element;
}

int main(){
    const char** cabocha=analyzeCaboCha("どうもこんにちは");
    for(int i=0;i<100;i++){
        cout<<cabocha[i]<<endl;
    }
    return 0;
}

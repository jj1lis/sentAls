#include <cabocha.h>
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

char* analyzeCaboCha(const char* sentence){
    vector<string> element;
    int cnt=0;
    try{
        auto parser=CaboCha::createParser("");
        auto tree=parser->parse(const_cast<char*>(sentence));
        for(unsigned int i=0;i<tree->size();i++){
            auto token=tree->token(i);
            if(token->chunk){
                element.push_back("$");
                element.push_back(to_string(token->chunk->link));
            }
            element.push_back("&");
            element.push_back(token->surface);
            element.push_back(getBase(token));
            for(int j=0;j<=4;j++){
                element.push_back(token->feature_list[j]);
            }
        }
    }catch(exception &ex){
        cerr<<ex.what()<<endl;
    }
    string als;
    for(int j=0;j<element.size();j++){
        als+="|";
        als+=element[j];
    }
    char* result=new char[als.length()];
    for(int k=0;k<als.length();k++){
        result[k]=als[k];
    }
    return result;
}
//
//int main(){
//    cout<<analyzeCaboCha("こんばんは、だいぶ寒いですね。")<<endl;
//    //cout<<str<<endl;
//    return 0;
//}
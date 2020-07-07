#include <cabocha.h>
#include <iostream>
#include <string>
using namespace std;

//TODO

//test
//string analyzeCaboCha(const char* sentence){
CaboCha::Parser* getCaboChaParser(){
    try{
        return CaboCha::createParser("");
    }catch(exception &ex){
        cerr<<ex.what()<<endl;
    }
}

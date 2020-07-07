#include <iostream>
#include <string>
using namespace std;
int main(){
    string a="hogehoge";
    cout<<"size:"<<a.length()<<endl;
    auto cp=a.data();
    for(int cnt=0;cp[cnt]!='\0';cnt++){
        cout<<cp[cnt]<<endl;
    }
}

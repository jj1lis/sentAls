import std;

void main(){
    func(1/3.);
    auto range=10000;
    foreach(i;iota(range).map!(b=>(b+1)*(1/(range.to!real+1)))){
        func(i);
    }
}

void func(real base){
    auto correct=(real x)=>pow(base,x-1);
    real integral=(1-1/base)/log(base)+1;
    writefln("base:%s\n\tcorrect(0)=%s:correct(1)=%s\n\tintegral=%s\n",base,correct(0),correct(1),integral);
}

module context.weighting;

import std.algorithm;
import std.math;
import std.conv:to;

real weighting(int weight,const int[] _weightlist)in{
    assert(_weightlist.length!=0);
}out(result){
    assert(!result.isNaN&&!result.isInfinity);
}do{
    auto weightlist=_weightlist.dup;

    sort!("a>b")(weightlist);
    int lank=int.max;
    foreach(i;0..weightlist.length){
        if(weight>=weightlist[i]){
            lank=i.to!int+1;
            break;
        }
    }
    if(lank==int.max)lank=weightlist.length.to!int;

    return correctFunc(lank,weightlist.length);
}

//example

import utils.various;

@safe @nogc nothrow real correctFunc(int lank,size_t len){
    real width=1/len.to!real;
    real lpl=lank*(1/(len.to!real+1));    //lank per length
    return pow(meta.weight_base,lpl-1);
}

module context.weighting;

import std.algorithm;
import std.conv:to;

real weighting(int weight,const int[] _weightlist)in{
    assert(_weightlist.length!=0);
}out(result){
    assert(result!=real.nan);
}do{
    auto weightlist=_weightlist.dup;
    enum lankCoeff{
        first=3.,
        second=2,
        third=1.5,
        Dedault=1.,
    }

    sort!("a>b")(weightlist);
    int lank=int.max;
    foreach(i;0..weightlist.length){
        if(weight>=weightlist[i]){
            lank=i.to!int;
            break;
        }
    }

    return correctFunc(lank/weightlist.length);
}

//example
@safe @nogc nothrow pure real function(real) correctFunc=(x)=>1+1/x;

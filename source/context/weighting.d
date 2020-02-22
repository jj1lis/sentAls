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
    //import std.stdio;

    //writefln("lank=%s %s:weightlist.length=%s %s:lank/weightlist.length.to!real=%s %s\ncorrectFunc(lank/weightlist.length.to!real)=%s %s",typeof(lank).stringof,lank,typeof(weightlist.length).stringof,weightlist.length,typeof(lank/weightlist.length.to!real).stringof,lank/weightlist.length.to!real,typeof(correctFunc(lank/weightlist.length.to!real)).stringof,correctFunc(lank/weightlist.length.to!real));
    return correctFunc(lank/weightlist.length.to!real);
    //if(result.isNaN||result.isInfinity)assert(0);
    //return result;
}

//example
@safe @nogc nothrow pure real function(real) correctFunc=(x)=>1+1/x;

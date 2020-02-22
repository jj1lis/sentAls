module context.weighting;

import std.algorithm;
import std.conv:to;

real weighting(int weight, int[] weightlist);

real weighting(int weight,int[] weights){
    enum lankCoeff{
        first=3.,
        second=2,
        third=1.5,
        Dedault=1.,
    }

    sort!("a>b")(weights);
    int lank=-1;
    foreach(i;0..weights.length){
        if(weight>=weights[i]){
            lank=i.to!int;
            break;
        }
    }
    switch(lank){
        case 1:
            return lankCoeff.first;
        case 2:
            return lankCoeff.second;
        case 3:
            return lankCoeff.third;
        default:
            return lankCoeff.Dedault;
    }
}

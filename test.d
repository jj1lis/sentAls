void main(){
    import std;
    auto str=["I like hot dog","Because it is not a dog","Do you like hot dog"];
    auto head=str.map!(x=>x.splitter.array[0]).array;
    head.writeln;
    iota(100).filter!(x=>x%2==0&&x%3==0).take(10).writeln;
    int[] array;
    typeof(array.length).stringof.writeln;
    array.length.writeln;
    auto str2=["I like hot,dog","Because it is not a,dog","Do you like hot,dog"];
    auto head2=str2.map!(x=>x.splitter(",").array[0].splitter.array[0]).array;
    head2.writeln;
    auto a=[1,3,4];
    a.filter!(x=>x>0).array.length.writeln;
    a.filter!(x=>x>2).array.length.writeln;
    auto str3=["A","A B","A B C","A B C D"];
    str3.filter!(x=>x.splitter.array.length>2).writeln;
    a[0..$-1].writeln;
    auto b=[1,2,3];
    b[0..$-1].writeln;
    b[$-1].writeln;
}

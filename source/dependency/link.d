module dependency.link;

import core.stdcpp.vector;
import core.stdcpp.string;
import std.string;
import std.conv;

alias cpp_string=basic_string!(char);

extern(C++){
    vector!(cpp_string) analyzeCaboCha(cpp_string sentence);
}

string[] analyzeDependency(string sent){
    string[] elements;
    auto sentence=cpp_string(sent);
    auto cabocha=sentence.analyzeCaboCha;
    foreach(ele;cabocha){
        elements~=ele.data.to!string;
    }
    return elements;
}

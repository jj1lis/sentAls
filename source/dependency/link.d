module dependency.link;

import core.stdcpp.vector;
import core.stdcpp.string;
import std.string;
import std.conv;

extern(C++){
    vector!(basic_string!char) analyzeCaboCha(basic_string!char sentence);
}

string[] analyzeDependency(string sentence){
    string[] elements;
    auto cabocha=basic_string(sentence.toStringz).analyzeCaboCha;
    foreach(ele;cabocha){
        element~=ele.to!string;
    }
}

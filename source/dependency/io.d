module dependency.io;

import std.stdio;
import std.file;
import std.string;
import std.conv;

import utils.io;

@safe:

auto getTexts(string filename){
    return devideFileByLine(filename);
}

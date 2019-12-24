module include.binder;

import std.string;

extern(C++,CaboCha):

    struct cabocha_chunk_t{
        int link;
    }

alias Chunk=cabocha_chunk_t;

struct cabocha_token_t{
    string surface;
    string feature;
    string[] feature_list;
    ushort feature_list_size;
    Chunk *chunk;
}

alias Token=cabocha_token_t;

class Tree{
    const size_t size();
    const Token *token(size_t);
}

class Parser{
    const Tree *parse(const char*);
}

const Parser *createParser(const char*);

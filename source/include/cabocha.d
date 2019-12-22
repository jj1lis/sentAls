module include.cabocha;
/* CaboCha -- Yet Another Japanese Dependency Parser
   $Id: cabocha.h 50 2009-05-03 08:25:36Z taku-ku $;
   Copyright(C) 2001-2008 Taku Kudo <taku@chasen.org>
*/

extern (C):

enum
{
    CABOCHA_EUC_JP = 0,
    CABOCHA_CP932 = 1,
    CABOCHA_UTF8 = 2,
    CABOCHA_ASCII = 3
}

enum
{
    CABOCHA_IPA = 0,
    CABOCHA_JUMAN = 1,
    CABOCHA_UNIDIC = 2
}

enum
{
    CABOCHA_FORMAT_TREE = 0,
    CABOCHA_FORMAT_LATTICE = 1,
    CABOCHA_FORMAT_TREE_LATTICE = 2,
    CABOCHA_FORMAT_XML = 3,
    CABOCHA_FORMAT_CONLL = 4,
    CABOCHA_FORMAT_NONE = 5
}

enum
{
    CABOCHA_INPUT_RAW_SENTENCE = 0,
    CABOCHA_INPUT_POS = 1,
    CABOCHA_INPUT_CHUNK = 2,
    CABOCHA_INPUT_SELECTION = 3,
    CABOCHA_INPUT_DEP = 4
}

enum
{
    CABOCHA_OUTPUT_RAW_SENTENCE = 0,
    CABOCHA_OUTPUT_POS = 1,
    CABOCHA_OUTPUT_CHUNK = 2,
    CABOCHA_OUTPUT_SELECTION = 3,
    CABOCHA_OUTPUT_DEP = 4
}

enum
{
    CABOCHA_TRAIN_NE = 0,
    CABOCHA_TRAIN_CHUNK = 1,
    CABOCHA_TRAIN_DEP = 2
}

struct cabocha_t;
struct cabocha_tree_t;
struct mecab_node_t;

struct cabocha_chunk_t
{
    int link;
    size_t head_pos;
    size_t func_pos;
    size_t token_size;
    size_t token_pos;
    float score;
    const(char*)* feature_list;
    const(char)* additional_info;
    ushort feature_list_size;
}

struct cabocha_token_t
{
    const(char)* surface;
    const(char)* normalized_surface;
    const(char)* feature;
    const(char*)* feature_list;
    ushort feature_list_size;
    const(char)* ne;
    const(char)* additional_info;
    cabocha_chunk_t* chunk;
}

int cabocha_do (int argc, char** argv);

/* parser */
cabocha_t* cabocha_new (int argc, char** argv);
cabocha_t* cabocha_new2 (const(char)* arg);
const(char)* cabocha_strerror (cabocha_t* cabocha);
const(cabocha_tree_t)* cabocha_parse_tree (
    cabocha_t* cabocha,
    cabocha_tree_t* tree);
const(char)* cabocha_sparse_tostr (cabocha_t* cabocha, const(char)* str);
const(char)* cabocha_sparse_tostr2 (
    cabocha_t* cabocha,
    const(char)* str,
    size_t lenght);
const(char)* cabocha_sparse_tostr3 (
    cabocha_t* cabocha,
    const(char)* str,
    size_t length,
    char* output_str,
    size_t output_length);
void cabocha_destroy (cabocha_t* cabocha);
const(cabocha_tree_t)* cabocha_sparse_totree (cabocha_t* cabocha, const(char)* str);
const(cabocha_tree_t)* cabocha_sparse_totree2 (cabocha_t* cabocha, const(char)* str, size_t length);
const(cabocha_tree_t)* cabocha_parse_tree (cabocha_t* cabocha, cabocha_tree_t* tree);

/* tree */
cabocha_tree_t* cabocha_tree_new ();
void cabocha_tree_destroy (cabocha_tree_t* tree);
int cabocha_tree_empty (cabocha_tree_t* tree);
void cabocha_tree_clear (cabocha_tree_t* tree);
void cabocha_tree_clear_chunk (cabocha_tree_t* tree);
size_t cabocha_tree_size (cabocha_tree_t* tree);
size_t cabocha_tree_chunk_size (cabocha_tree_t* tree);
size_t cabocha_tree_token_size (cabocha_tree_t* tree);
const(char)* cabocha_tree_sentence (cabocha_tree_t* tree);
size_t cabocha_tree_sentence_size (cabocha_tree_t* tree);
void cabocha_tree_set_sentence (
    cabocha_tree_t* tree,
    const(char)* sentence,
    size_t length);
int cabocha_tree_read (
    cabocha_tree_t* tree,
    const(char)* input,
    size_t length,
    int input_layer);
int cabocha_tree_read_from_mecab_node (
    cabocha_tree_t* tree,
    const(mecab_node_t)* node);

const(cabocha_token_t)* cabocha_tree_token (cabocha_tree_t* tree, size_t i);
const(cabocha_chunk_t)* cabocha_tree_chunk (cabocha_tree_t* tree, size_t i);

cabocha_token_t* cabocha_tree_add_token (cabocha_tree_t* tree);
cabocha_chunk_t* cabocha_tree_add_chunk (cabocha_tree_t* tree);

char* cabocha_tree_strdup (cabocha_tree_t* tree, const(char)* str);
char* cabocha_tree_alloc (cabocha_tree_t* tree, size_t size);

const(char)* cabocha_tree_tostr (cabocha_tree_t* tree, int format);
const(char)* cabocha_tree_tostr2 (
    cabocha_tree_t* tree,
    int format,
    char* str,
    size_t length);

void cabocha_tree_set_charset (cabocha_tree_t* tree, int charset);
int cabocha_tree_charset (cabocha_tree_t* tree);
void cabocha_tree_set_posset (cabocha_tree_t* tree, int posset);
int cabocha_tree_posset (cabocha_tree_t* tree);
void cabocha_tree_set_output_layer (cabocha_tree_t* tree, int output_layer);
int cabocha_tree_output_layer (cabocha_tree_t* tree);

int cabocha_learn (int argc, char** argv);
int cabocha_system_eval (int argc, char** argv);
int cabocha_model_index (int argc, char** argv);

/* for C++ */

// API for training


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

extern (C++,CaboCha):
struct Chunk;
struct Token;

enum CharsetType {
  EUC_JP = CABOCHA_EUC_JP,
  CP932  = CABOCHA_CP932,
  UTF8   = CABOCHA_UTF8,
  ASCII  = CABOCHA_ASCII
};

enum PossetType  {
  IPA    = CABOCHA_IPA,
  JUMAN  = CABOCHA_JUMAN,
  UNIDIC = CABOCHA_UNIDIC
}

enum FormatType {
  FORMAT_TREE         = CABOCHA_FORMAT_TREE,
  FORMAT_LATTICE      = CABOCHA_FORMAT_LATTICE,
  FORMAT_TREE_LATTICE = CABOCHA_FORMAT_TREE_LATTICE,
  FORMAT_XML          = CABOCHA_FORMAT_XML,
  FORMAT_CONLL        = CABOCHA_FORMAT_CONLL,
  FORMAT_NONE         = CABOCHA_FORMAT_NONE
}

enum InputLayerType {
  INPUT_RAW_SENTENCE = CABOCHA_INPUT_RAW_SENTENCE,
  INPUT_POS          = CABOCHA_INPUT_POS,
  INPUT_CHUNK        = CABOCHA_INPUT_CHUNK,
  INPUT_SELECTION    = CABOCHA_INPUT_SELECTION,
  INPUT_DEP          = CABOCHA_INPUT_DEP
}

enum OutputLayerType {
  OUTPUT_RAW_SENTENCE = CABOCHA_OUTPUT_RAW_SENTENCE,
  OUTPUT_POS          = CABOCHA_OUTPUT_POS,
  OUTPUT_CHUNK        = CABOCHA_OUTPUT_CHUNK,
  OUTPUT_SELECTION    = CABOCHA_OUTPUT_SELECTION,
  OUTPUT_DEP          = CABOCHA_OUTPUT_DEP
}

enum ParserType {
  TRAIN_NE    = CABOCHA_TRAIN_NE,
  TRAIN_CHUNK = CABOCHA_TRAIN_CHUNK,
  TRAIN_DEP   = CABOCHA_TRAIN_DEP
}

class TreeAllocator;
class Tree {
 public:
  void set_sentence(const char *sentence);
  const char *sentence();
  size_t sentence_size();

  void set_sentence(const char *sentence, size_t length);

  const Chunk *chunk(size_t i);
  const Token *token(size_t i);

  Chunk *mutable_chunk(size_t i);
  Token *mutable_token(size_t i);

  Token *add_token();
  Chunk *add_chunk();

  char *strdup(const char *str);
  char *alloc(size_t size);
  char **alloc_char_array(size_t size);

  TreeAllocator *allocator() const;

  bool   read(const char *input,
              InputLayerType input_layer);

  bool   read(const char *input, size_t length,
              InputLayerType input_layer);
  bool   read(const mecab_node_t *node);

  bool   empty() const;
  void   clear();
  void   clear_chunk();

  size_t chunk_size() const;
  size_t token_size() const;
  size_t size() const;

  const char *toString(FormatType output_format);

  const char *toString(FormatType output_format,
                       char *output, size_t length);

  CharsetType charset() const { return charset_; }
  void set_charset(CharsetType charset) { charset_ = charset; }
  PossetType posset() const { return posset_; }
  void set_posset(PossetType posset) { posset_ = posset; }
  OutputLayerType output_layer() const { return output_layer_; }
  void set_output_layer(OutputLayerType output_layer) { output_layer_ = output_layer; }

  const char *what();

  this();
  ~this();

 private:
  TreeAllocator              *tree_allocator_;
  CharsetType                 charset_;
  PossetType                  posset_;
  OutputLayerType             output_layer_;
}

class Parser {
 public:
  const Tree *parse(const char *input)                          = 0;
  const char *parseToString(const char *input)                  = 0;
  const Tree *parse(Tree *tree)                           = 0;

  const Tree *parse(const char *input, size_t length)           = 0;
  const char *parseToString(const char *input, size_t length)   = 0;
  const char *parseToString(const char *input, size_t length,
                                    char       *output, size_t output_length) = 0;

  const char *what() = 0;
  static char *version_();

  ~this();

  static Parser *create(int argc, char **argv);
  static Parser *create(const char *arg);
}


Parser *createParser(int argc, char **argv);
Parser *createParser(const char *arg);
char *getParserError();
char *getLastError();
// API for training


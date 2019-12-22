/*
  CRF++ -- Yet Another CRF toolkit

  $Id: crfpp.h 1592 2007-02-12 09:40:53Z taku $;

  Copyright(C) 2005-2007 Taku Kudo <taku@chasen.org>
*/

extern (C):

/* C interface  */

struct crfpp_t;
struct crfpp_model_t;

/* C interface */
crfpp_model_t* crfpp_model_new (int, char**);
crfpp_model_t* crfpp_model_new2 (const(char)*);
crfpp_model_t* crfpp_model_from_array_new (int, char**, const(char)*, size_t);
crfpp_model_t* crfpp_model_from_array_new2 (const(char)*, const(char)*, size_t);
const(char)* crfpp_model_get_template (crfpp_model_t*);
void crfpp_model_destroy (crfpp_model_t*);
const(char)* crfpp_model_strerror (crfpp_model_t*);
crfpp_t* crfpp_model_new_tagger (crfpp_model_t*);

crfpp_t* crfpp_new (int, char**);
crfpp_t* crfpp_new2 (const(char)*);
void crfpp_destroy (crfpp_t*);
int crfpp_set_model (crfpp_t*, crfpp_model_t*);
int crfpp_add2 (crfpp_t*, size_t, const(char*)*);
int crfpp_add (crfpp_t*, const(char)*);
size_t crfpp_size (crfpp_t*);
size_t crfpp_xsize (crfpp_t*);
size_t crfpp_dsize (crfpp_t*);
const(float)* crfpp_weight_vector (crfpp_t*);
size_t crfpp_result (crfpp_t*, size_t);
size_t crfpp_answer (crfpp_t*, size_t);
size_t crfpp_y (crfpp_t*, size_t);
size_t crfpp_ysize (crfpp_t*);
double crfpp_prob (crfpp_t*, size_t, size_t);
double crfpp_prob2 (crfpp_t*, size_t);
double crfpp_prob3 (crfpp_t*);
void crfpp_set_penalty (crfpp_t*, size_t i, size_t j, double penalty);
double crfpp_penalty (crfpp_t*, size_t i, size_t j);
double crfpp_alpha (crfpp_t*, size_t, size_t);
double crfpp_beta (crfpp_t*, size_t, size_t);
double crfpp_emisstion_cost (crfpp_t*, size_t, size_t);
double crfpp_next_transition_cost (crfpp_t*, size_t, size_t, size_t);
double crfpp_prev_transition_cost (crfpp_t*, size_t, size_t, size_t);
double crfpp_best_cost (crfpp_t*, size_t, size_t);
const(int)* crfpp_emittion_vector (crfpp_t*, size_t, size_t);
const(int)* crfpp_next_transition_vector (crfpp_t*, size_t, size_t, size_t);
const(int)* crfpp_prev_transition_vector (crfpp_t*, size_t, size_t, size_t);
double crfpp_Z (crfpp_t*);
int crfpp_parse (crfpp_t*);
int crfpp_empty (crfpp_t*);
int crfpp_clear (crfpp_t*);
int crfpp_next (crfpp_t*);
int crfpp_test (int, char**);
int crfpp_test2 (const(char)*);
int crfpp_learn (int, char**);
int crfpp_learn2 (const(char)*);
const(char)* crfpp_strerror (crfpp_t*);
const(char)* crfpp_yname (crfpp_t*, size_t);
const(char)* crfpp_y2 (crfpp_t*, size_t);
const(char)* crfpp_x (crfpp_t*, size_t, size_t);
const(char*)* crfpp_x2 (crfpp_t*, size_t);
const(char)* crfpp_parse_tostr (crfpp_t*, const(char)*);
const(char)* crfpp_parse_tostr2 (crfpp_t*, const(char)*, size_t);
const(char)* crfpp_parse_tostr3 (crfpp_t*, const(char)*, size_t, char*, size_t);
const(char)* crfpp_tostr (crfpp_t*);
const(char)* crfpp_tostr2 (crfpp_t*, char*, size_t);

void crfpp_set_vlevel (crfpp_t*, uint);
uint crfpp_vlevel (crfpp_t*);
void crfpp_set_cost_factor (crfpp_t*, float);
float crfpp_cost_factor (crfpp_t*);
void crfpp_set_nbest (crfpp_t*, size_t);

/* C++ interface */

// open model with parameters in argv[]
// e.g, argv[] = {"CRF++", "-m", "model", "-v3"};

// open model with parameter arg, e.g. arg = "-m model -v3";

// open model with parameters in argv[].
// e.g, argv[] = {"CRF++", "-v3"};

// open model with parameter arg, e.g. arg = "-m model -v3";

// return template string embedded in this model file.

// create Tagger object. Returned object shared the same
// model object

// open model with parameters in argv[]
// e.g, argv[] = {"CRF++", "-m", "model", "-v3"};

// open model with parameter arg, e.g. arg = "-m model -v3";

// add str[] as tokens to the current context

// close the current model

// return parameter vector. the size should be dsize();

// set Model

// set vlevel

// get vlevel

// set cost factor

// get cost factor

// set nbest

// get nbest

// add one line to the current context

// return size of tokens(lines)

// return size of column

// return size of features

// return output tag-id of i-th token

// return answer tag-id of i-th token if it is available

// alias of result(i)

// return output tag of i-th token as string

// return i-th tag-id as string

// return token at [i,j] as string(i:token j:column)

// return an array of strings at i-th tokens

// return size of output tags

// return marginal probability of j-th tag id at i-th token

// return marginal probability of output tag at i-th token
// same as prob(i, tagger->y(i));

// return conditional probability of enter output

// set token-level penalty. It would be useful for implementing
// Dual decompositon decoding.
// e.g.
// "Dual Decomposition for Parsing with Non-Projective Head Automata"
// Terry Koo Alexander M. Rush Michael Collins Tommi Jaakkola David Sontag

// return forward log-prob of the j-th tag at i-th token

// return backward log-prob of the j-th tag at i-th token

// return emission cost of the j-th tag at i-th token

// return transition cost of [j-th tag at i-th token] to
// [k-th tag at(i+1)-th token]

// return transition cost of [j-th tag at i-th token] to
// [k-th tag at(i-1)-th token]

//  return the best accumulative cost to the j-th tag at i-th token
// used in viterbi search

// return emission feature vector of the j-th tag at i-th token

// return transition feature vector of [j-th tag at i-th token] to
// [k-th tag at(i+1)-th token]

// return transition feature vector of [j-th tag at i-th token] to
// [k-th tag at(i-1)-th token]

// normalizing factor(log-prob)

// do parse and change the internal status, if failed, returns false

// return true if the context is empty

// clear all context

// change the internal state to output next-optimal output.
// calling it n-th times, can get n-best results,
// Neeed to specify -nN option to use this function, where
// N>=2

// parse 'str' and return result as string
// 'str' must be written in CRF++'s input format

// return parsed result as string

// return parsed result as string.
// Result is saved in the buffer 'result', 'size' is the
// size of the buffer. if failed, return NULL

// parse 'str' and return parsed result.
// You don't need to delete return value, but the buffer
// is rewritten whenever you call parse method.
// if failed, return NULL

// parse 'str' and return parsed result.
// The result is stored in the buffer 'result'.
// 'size2' is the size of the buffer. if failed, return NULL

// return internal error code as string

/* factory method */

// create CRFPP::Tagger instance with parameters in argv[]
// e.g, argv[] = {"CRF++", "-m", "model", "-v3"};

// create CRFPP::Tagger instance with parameter in arg
// e.g. arg = "-m model -v3";

// create CRFPP::Model instance with parameters in argv[]
// e.g, argv[] = {"CRF++", "-m", "model", "-v3"};

// load model from [buf, buf+size].

// create CRFPP::Model instance with parameter in arg
// e.g. arg = "-m model -v3";

// load model from [buf, buf+size].

// return error code of createTagger();

// alias of getTaggerError();


module utils.exception;

import std.conv;

@safe:

class NoTextNumberException:Exception{
    this(int num){
        string msg="Text Number "~to!string(num)~" not found.";
        super(msg);
    }
}

class stringToIntException:Exception{
    this(string str){
        string msg="\""~str~"\" cannot be converted from \'string\' to \'int\'.";
        super(msg);
    }
    this(string str,int text){
        string msg="\""~str~"\" cannot be converted from \'string\' to \'int\' in text "~to!string(text)~".";
        super(msg);
    }

    this(string str,int sentence,int text){
        string msg="\""~str~"\" cannot be converted from \'string\' to \'int\' in sentence "~to!string(sentence)~",text "~to!string(text)~".";
        super(msg);
    }

    this(string str,int phrase,int sentence,int text){
        string msg="\""~str~"\" cannot be converted from \'string\' to \'int\' in phrase "~to!string(phrase)~",sentence "~to!string(sentence)~",text "~to!string(text)~".";
        super(msg);
    }

    this(string str,int word,int phrase,int sentence,int text){
        string msg="\""~str~"\" cannot be converted from \'string\' to \'int\' in word "~to!string(word)~",phrase "~to!string(phrase)~",sentence "~to!string(sentence)~",text "~to!string(text)~".";
        super(msg);
    }
}

class stringToFloatException:Exception{
    this(string str){
        string msg="\""~str~"\" cannot be converted from \'string\' to \'float\'.";
        super(msg);
    }
    this(string str,int text){
        string msg="\""~str~"\" cannot be converted from \'string\' to \'float\' in text "~to!string(text)~".";
        super(msg);
    }

    this(string str,int sentence,int text){
        string msg="\""~str~"\" cannot be converted from \'string\' to \'float\' in sentence "~to!string(sentence)~",text "~to!string(text)~".";
        super(msg);
    }

    this(string str,int phrase,int sentence,int text){
        string msg="\""~str~"\" cannot be converted from \'string\' to \'float\' in phrase "~to!string(phrase)~",sentence "~to!string(sentence)~",text "~to!string(text)~".";
        super(msg);
    }

    this(string str,int word,int phrase,int sentence,int text){
        string msg="\""~str~"\" cannot be converted from \'string\' to \'float\' in word "~to!string(word)~",phrase "~to!string(phrase)~",sentence "~to!string(sentence)~",text "~to!string(text)~".";
        super(msg);
    }
}

class ScoreException:Exception{
    /*
    this(int min,int max,int text){
        string cursor="text "~to!string(text);
        super(cursor~": score must be in range "~to!string(min)~" ~ "~to!string(max)~".");
    }
    this(int min,int max,int sentence,int text){
        string cursor="sentence "~to!string(sentence)~",text "~to!string(text);
        super(cursor~": score must be in range "~to!string(min)~" ~ "~to!string(max)~".");
    }
    this(int min,int max,int phrase,int sentence,int text){
        string cursor="phrase "~to!string(phrase)~",sentence "~to!string(sentence)~",text "~to!string(text);
        super(cursor~": score must be in range "~to!string(min)~" ~ "~to!string(max)~".");
    }
    this(int min,int max,int word,int phrase,int sentence,int text){
        string cursor="word "~to!string(word)~",phrase "~to!string(phrase)~",sentence "~to!string(sentence)~",text "~to!string(text);
        super(cursor~": score must be in range "~to!string(min)~" ~ "~to!string(max)~".");
    }
    */
    this(float min,float max,int text){
        string cursor="text "~to!string(text);
        super(cursor~": score must be in range "~to!string(min)~" ~ "~to!string(max)~".");
    }
    this(float min,float max,int sentence,int text){
        string cursor="sentence "~to!string(sentence)~",text "~to!string(text);
        super(cursor~": score must be in range "~to!string(min)~" ~ "~to!string(max)~".");
    }
    this(float min,float max,int phrase,int sentence,int text){
        string cursor="phrase "~to!string(phrase)~",sentence "~to!string(sentence)~",text "~to!string(text);
        super(cursor~": score must be in range "~to!string(min)~" ~ "~to!string(max)~".");
    }
    this(float min,float max,int word,int phrase,int sentence,int text){
        string cursor="word "~to!string(word)~",phrase "~to!string(phrase)~",sentence "~to!string(sentence)~",text "~to!string(text);
        super(cursor~": score must be in range "~to!string(min)~" ~ "~to!string(max)~".");
    }
}

class ArgumentException:Exception{
    this(string reason){
        super("Invalid argument: "~reason);
    }
}

class NeuronInitializeException:Exception{
    this(int input_len,int weight_len,int number,string layer){
        super("Number of inputs,"~input_len.to!string~
                " is different from number of weights,"~weight_len.to!string~
                " in Neuron "~number.to!string~", Layer "~layer);
    }
}

class ElementEmptyException:Exception{
    private string msg="Element is Empty: ";
    this(size_t text){
        string cursor="text "~to!string(text);
        super(msg~cursor);
    }
    this(size_t sentence,size_t text){
        string cursor="sentence "~to!string(sentence)~
            ", in text "~to!string(text);
        super(msg~cursor);
    }
    this(size_t phrase,size_t sentence,size_t text){
        string cursor="phrase "~to!string(phrase)~
            ", sentence "~to!string(sentence)~", in text "~to!string(text);
        super(msg~cursor);
    }
    this(size_t word,size_t phrase,size_t sentence,size_t text){
        string cursor="word "~to!string(word)~
            ", phrase "~to!string(phrase)~", sentence "~to!string(sentence)~
            ", in text "~to!string(text);
        super(msg~cursor);
    }
}

class NoInputException:Exception{
    this(string msg){
        super(msg);
    }
}
//
//class Termination:Exception{
//    private bool failure;
//    @property bool isfailure(){return failure;}
//    this(string msg,bool failure=false){
//        this.failure=failure;
//        super(msg);
//    }
//}

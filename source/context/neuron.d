module context.nueron;
/*
import std.file;
import std.string;
import context.exception;

enum Layer{
    input,
    middle,
    output,
}

string LayerToString(Layer l) {
    switch(l){
        case Layer.input:
            return "input";
            break;
        case Layer.middle:
            return "middle";
            break;
        case Layer.output:
            return "output";
            break;
        default:
        assert(0);
    }
}

class Neuron{
    private Layer layer;
    private int neuron_number;
    private real[] inputs;
    private real[] weights;
    private real threshold;
    private real integrated_value;
    private real output;

    this(Layer _layer,int neu_num,
            real _weights[],real _threshold){
        layer=_layer;
        neuron_number=neu_num;
        weights=_weights;
        threshold=_threshold;
    }

    Layer getLayer(){
        return layer;
    }

    int getNumber(){
        return neuron_number;
    }

    abstract real transferFunc(real);

    abstract void modify();
}

class InputNeuron:Neuron{
    this(int num,real[] _weights,real _threshold){
        super(Layer.input,num,_weights,_threshold);
    }

    override real transferFunc(real u){
        return u;   //TODO
    }

    override void modify(){
        //TODO
    }
}

class MiddleNeuron:Neuron{
    this(int num,real[] _weights,real _threshold){
        super(Layer.input,num,_weights,_threshold);
    }

    override real transferFunc(real u){
        return u;   //TODO
    }

    override void modify(){
        //TODO
    }
}

class OutputNeuron:Neuron{
    this(int num,real[] _weights,real _threshold){
        super(Layer.input,num,_weights,_threshold);
    }

    override real transferFunc(real u){
        return u;   //TODO
    }

    override void modify(){
        //TODO
    }
}


class Stat{
    string[] readIndex(string[] file,string index){
        string[] content;
        bool flag=false;
        for(int cnt=0;cnt<file.length;cnt++){
            if(flag){
                content~=file[cnt].strip.toLower;
            }

            if(indexOf(file[cnt],'['~index~']')!=1){
                flag=true;
            }

            if(indexOf(file[cnt],"[/"~index~']')!=1){
                flag=false;
            }
        }
        return content;
    }

    this(string read_file){
        string[] file_whole;
        try{
            file_whole=readText(read_file).splitLines;
        }catch(FileException fe){
            throw new FileException(read_file,"Faild to open File");
        }
        string[] meta=readIndex(file_whole,"meta");
        string[] data=readIndex(file_whole,"data");
    }
}

class Network{
    private InputNeuron[] ineuron;
    private MiddleNeuron[] mneuron;
    private OutputNeuron[] oneuron;
    private int howmany_middlelayer;
    private Stat stat;

    this(string filename,int how_midlay,int how_ineu,int how_mneu,int how_oneu){
        stat=new Stat(filename);
    }
}
*/

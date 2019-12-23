module utils.opt;

enum Opt{
    file,
    text,
    unknown,
}

struct Option{
    private Opt opt;
    private string[] args;

    @property{
        Opt option(){return opt;}
        string[] arg(){return args;}
    }

    this(Opt opt,string[] args){
        this.opt=opt;
        this.args=args;
    }
}

Option[] separateOption(string[] args){
    string[] tmp_arg;
    Option[] options;
    foreach(arg;args){
        Opt opt;
        if(arg.argToOption!=Opt.unknown){
            if(tmp_arg.length!=0){
                options~=Option(opt,tmp_arg);
                tmp_arg.length=0;
            }else{
                options~=Option(opt,[]);
            }
            opt=arg.argToOption;
        }else{
            tmp_arg~=arg;
        }
    }
    return options;
}

Opt argToOption(string arg){
    switch(arg){
        case "-f":
            return Opt.file;
        case "-t":
            return Opt.text;
        //
        default:
            return Opt.unknown;
    }
}

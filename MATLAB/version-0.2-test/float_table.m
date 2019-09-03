mnval = -100;
mxval = 100;

fileID = fopen('C:\Users\bugra\Desktop\Yonga\Float_Adder\input_vectors.txt','w');
refFile = fopen('C:\Users\bugra\Desktop\Yonga\Float_Adder\ref.txt','w');
vals = fopen('C:\Users\bugra\Desktop\Yonga\Float_Adder\vals.txt','w');

for a = 0:100
    val1 = mnval + rand*(mxval-mnval);
    val2 = mnval + rand*(mxval-mnval);
    fprintf(fileID, num2str(dec2bin(typecast(single(val1),'uint32'),32))+" "+num2str(dec2bin(typecast(single(val2),'uint32'),32))+"\n");
    fprintf(refFile, num2str(dec2bin(typecast(single(val1+val2),'uint32'),32))+"\n");
    fprintf(vals, num2str(val1)+"+"+num2str(val2)+"\n");
end
fclose(fileID);
fclose(refFile);
fclose(vals);


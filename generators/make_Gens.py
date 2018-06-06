
infile_name = 'files.txt'

with open(infile_name,'r') as infile:
    for line in infile:
        lines = [] 
        
        line = line.strip('\n')
        
        lines.append('num_lines=$(wc -l < Sources/'+line+'.txt) \n')
        lines.append('choice=$((RANDOM%num_lines+0)) \n')
        lines.append('word=$(head -n $choice Sources/'+line+'.txt | tail -n 1) \n')
        lines.append("echo "+line+": $word \n")
 
 
        outfile = open('gen'+line.title()+'.txt','w+')
        outfile.writelines(lines)
        outfile.close()


 
                   
                   
        

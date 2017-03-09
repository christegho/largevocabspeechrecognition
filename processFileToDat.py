import argparse

def toDatFile(inFile, outFile):
	indir = inFile#'plp-tglm_int3_'+show+'/'+show+'/rescore/rescore.mlf' 
	text = open(indir).read();
	bestLt = text.split('.\n"')
	dat = [];
	for i in range(1,len(bestLt)):
		words = bestLt[i].split('\n')
		if i == len(bestLt)-1:
			maxWord = len(words)-2
		else:
			maxWord = len(words)-1
		dat.append('<s>')
		for word in range(len(words)):
			if word != 0 and word < maxWord :
				wordT = words[word]
				dat.append(wordT.split()[2])	
		dat.append('</s>\n')
	outfile = open(outFile,'w') #open('plp-tglm_int3_'+show+'/'+show+'4.dat','w')
	outfile.write(" ".join(dat))
	outfile.close()


def main() :
    
    parser = argparse.ArgumentParser(description='ROVER.')
    parser.add_argument('--in', dest='inFile', action='store', required=True,
                        help='alpha')
    parser.add_argument('--out', dest='outFile', action='store', required=True,
                        help='none score')
    
    args = parser.parse_args()
    toDatFile(args.inFile, args.outFile)

    
    
if __name__ == '__main__':
    main()

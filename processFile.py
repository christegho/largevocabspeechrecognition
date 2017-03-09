import csv
import argparse
def processFile(filename, outfilename):
	expList = [];
	indir = '/remote/mlsalt-2016/ct506/MLSALT11/'+ filename
	text = open(indir).read();
	exps = text.split('--------------------------------------------------\n')
	for exp in exps:
		if (len(exp)!=0):
			exp = exp.split('\n')
			expList.append(exp[0])
			expList.append(exp[1].split('   ')[12])
			expList.append(exp[1].split('   ')[13].split(' |')[1])
			expList.append('\n')


	with open(outfilename+'.csv', 'wb') as myfile:
	    wr = csv.writer(myfile, delimiter=',' ,quoting=csv.QUOTE_MINIMAL)
	    wr.writerow(expList)



def main() :
    
    parser = argparse.ArgumentParser(description='ROVER.')
    parser.add_argument('--in', dest='filename', action='store', required=True,
                        help='alpha')

    args = parser.parse_args()
    processFile(args.filename, args.filename.split('.')[0])

    
    
if __name__ == '__main__':
    main()

import gzip
import os
import numpy as np
import operator
import argparse

def combineCNC(alpha, nullScore, file1, file2,timealign, decode1, decode2):
	dir1 = '/home/ct506/MLSALT11/'+file1+'/dev03_DEV001-20010117-XX2000/'+decode1+'/lattices/'
	dir2 = '/home/ct506/MLSALT11/'+file2+'/dev03_DEV001-20010117-XX2000/'+decode2+'/lattices/'
	mlf = ['#!MLF!#\n']
	tmp = []
	nullScore = np.log(nullScore)
	for filename in os.listdir(dir1):
		mlf.append('"*/'+filename.split('.')[0] + '.rec"\n')
		tmp.append(filename + '\n')
		f1=gzip.open(dir1+filename,'rb')
		f2=gzip.open(dir2+filename,'rb')
		fc1=f1.read().split('k=')
		fc2=f2.read().split('k=')
		N1 = float(fc1[0].split('=')[1].split(' ')[0])
		N2 = float(fc2[0].split('=')[1].split(' ')[0])
		i = int(N1)
		j = int(N2)
		l = 0
		while (i > 0 and j > 0):
			words = []
			wordsP = []
			ee = []
			ss = []
			s1 = float(fc1[i].split('W=')[1].split('=')[1].split(' ')[0])
			e1 = float(fc1[i].split('W=')[1].split('=')[2].split(' ')[0])
			s2 = float(fc2[j].split('W=')[1].split('=')[1].split(' ')[0])
			e2 = float(fc2[j].split('W=')[1].split('=')[2].split(' ')[0])
			es1 = e1 - s1
			es2 = e2 - s2
			if e1 < s2+es2*timealign:
				for arc in fc1[i].split('W='):
					arci = arc.split('=')
					if (len(arci) > 1):
						ss.append(float(arci[1].split(' ')[0]))
						ee.append(float(arci[2].split(' ')[0]))
						word = arci[0].split(' ')[0]
						p = float(arci[3].split(' ')[0])
						words.append(word)
						wordsP.append(p)
				i -= 1
				l += 1
				if '!NULL' not in words:
					ss.append(s1)
					ee.append(e1)
					words.append('!NULL')
					wordsP.append(nullScore)
				else:
					ind = words.index('!NULL')
					wordsP[ind] += alpha*wordsP[ind] + (1-alpha)*nullScore
			elif e2 < s1 +es1*timealign :
				for arc in fc2[j].split('W='):
					arci = arc.split('=')
					if (len(arci) > 1):
						ss.append(float(arci[1].split(' ')[0]))
						ee.append(float(arci[2].split(' ')[0]))
						word = arci[0].split(' ')[0]
						p = float(arci[3].split(' ')[0])
						words.append(word)
						wordsP.append(p)
				j -= 1
				l += 1
				if '!NULL' not in words:
					ss.append(s2)
					ee.append(e2)
					words.append('!NULL')
					wordsP.append(nullScore)
				else:
					ind = words.index('!NULL')
					wordsP[ind] = (1-alpha)*wordsP[ind] + alpha*nullScore
			else:	
				for arc in fc1[i].split('W='):
					arci = arc.split('=')
					if (len(arci) > 1):
						ss.append(float(arci[1].split(' ')[0]))
						ee.append(float(arci[2].split(' ')[0]))
						word = arci[0].split(' ')[0]
						p = float(arci[3].split(' ')[0])
						words.append(word)
						wordsP.append(p)
				for arc in fc2[j].split('W='):
					arci = arc.split('=')
					if (len(arci) > 1):
						word = arci[0].split(' ')[0]
						p = float(arci[3].split(' ')[0])
						if word not in words:
							ss.append(float(arci[1].split(' ')[0]))
							ee.append(float(arci[2].split(' ')[0]))
							words.append(word)
							wordsP.append(p)
						else:
							ind = words.index(word)
							wordsP[ind] = alpha*wordsP[ind] + (1-alpha)*p
				i -= 1
				j -= 1
				l += 1
			maxi, maxv = max(enumerate(wordsP), key=operator.itemgetter(1))
			mlf.append(str(int(ss[maxi]*1000000))+ ' ' + str(int(ee[maxi]*1000000)) + ' ' + words[maxi] + ' ' + str(maxv) + '\n')
			tmp.append('k=' + str(len(words)) + '\n')
			for ind in range(len(words)):
				tmp.append('W='+words[ind] + ' s='+ str(ss[ind]) + ' e=' + str(ee[ind]) + ' p=' + str(wordsP[ind]) + '\n')  
		tmp.append('N=' + str(l) + '\n')
		tmp.append('.\n')	
		mlf.append('.\n')

	mlfFile = open('/home/ct506/MLSALT11/copy1/dev03_DEV001-20010117-XX2000/decode/rescore.mlf', 'w') #'/home/ct506/MLSALT11/copy1/dev03_DEV001-20010117-XX2000/decode/rescore.mlf'
	for item in mlf:
	  	mlfFile.write("%s" % item)
	
	mlfFile = open('tmp.cn', 'w')
	for item in tmp:
	  	mlfFile.write("%s" % item)
	
def main() :
    
    parser = argparse.ArgumentParser(description='ROVER.')
    parser.add_argument('--alpha', dest='alpha', action='store', default=0.5,
                        help='alpha')
    parser.add_argument('--none', dest='noneSc', action='store', default=-500,
                        help='none score')
    parser.add_argument('--ta', dest='timalign', action='store', default=0.2,
                        help='timalign')
    parser.add_argument('--file1', dest='file1', action='store', required=True,
                        help='ref file')
    parser.add_argument('--file2', dest='file2', action='store', required=True,
                        help='file 2')
    parser.add_argument('--d1', dest='decode1', action='store', required=True,
                        help='file 2')
    parser.add_argument('--d2', dest='decode2', action='store', required=True,
                        help='file 2')
   
    args = parser.parse_args()
    combineCNC(float(args.alpha), float(args.noneSc), args.file1, args.file2, float(args.timalign), args.decode1, args.decode2)

    
    
if __name__ == '__main__':
    main()




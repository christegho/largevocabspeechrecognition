import numpy as np
import operator
#import tabulate as tb
#sourse http://www.giovannicarmantini.com/2016/01/minimum-edit-distance-in-python


def wagner_fischer(word_1, word_2, timing_1, timing_2):
    n = len(word_1) + 1  # counting empty string 
    m = len(word_2) + 1  # counting empty string
 
    # initialize D matrix
    D = np.zeros(shape=(n, m), dtype=np.int)
    D_ = np.zeros(shape=(n, m), dtype=np.int)
    D[:,0] = range(n)
    D[0,:] = range(m)
    D_[:,0] = range(n)
    D_[0,:] = range(m)
 
    # B is the backtrack matrix. At each index, it contains a triple
    # of booleans, used as flags. if B(i,j) = (1, 1, 0) for example,
    # the distance computed in D(i,j) came from a deletion or a
    # substitution. This is used to compute backtracking later.
    B = np.zeros(shape=(n, m), dtype=[("del", 'b'), 
                                      ("sub", 'b'),
                                      ("ins", 'b')])
    B[1:,0] = (1, 0, 0) 
    B[0,1:] = (0, 0, 1)
 
    for i, l_1 in enumerate(word_1, start=1):
        for j, l_2 in enumerate(word_2, start=1):
	    ct = 0
	    aligned = False
	    if (timing_1[i-1][0]<timing_2[j-1][1] and timing_2[j-1][0]<timing_1[i-1][1]):
		e2t2 = timing_2[j-1][1]-timing_2[j-1][0]
		e1t1 = timing_1[i-1][1]-timing_1[i-1][0]
		if (e2t2 > 0.20*e1t1 or e2t2 < 1.8*e1t1):
			ct = 0
			idt = 0
			aligned = True
		else:
			ct = 2
			idt = 2
	    else:
		ct = 2
		idt = 2
	    
	    #print l_1, l_2, timing_1[i-1],timing_2[j-1],D[i-1,j],D[i, j-1], D[i-1,j-1],idt, ct,i,j
	    
            deletion = D[i-1,j] + 2
            insertion = D[i, j-1] + 2
            substitution = D[i-1,j-1] + (0 if l_1==l_2 else 2)
 
            mo = np.min([deletion, insertion, substitution])

 	    #deletion2 = (D[i-1,j] + 1)+idt
            #insertion2 = (D[i, j-1] + 1)+idt
            #substitution2 = (D[i-1,j-1] + (0 if l_1==l_2 else 2))+ct
	    #mo2 = np.min([deletion2, insertion2, substitution2])
	    if (aligned):
            	B[i,j] = (deletion==mo, substitution==mo, insertion==mo)
	    else:
		mo2 = np.min([deletion, insertion])
		B[i,j] = (deletion==mo2, 0, insertion==mo2)
            
	    D[i,j] = mo
	    

    return D, B


def naive_backtrace(B_matrix):
    i, j = B_matrix.shape[0]-1, B_matrix.shape[1]-1
    backtrace_idxs = [(i, j)]
 
    while (i, j) != (0, 0):
        if B_matrix[i,j][1]:
            i, j = i-1, j-1
        elif B_matrix[i,j][0]:
            i, j = i-1, j
        elif B_matrix[i,j][2]:
            i, j = i, j-1
        backtrace_idxs.append((i,j))
 
    return backtrace_idxs


def align(word_1, word_2, bt, timing_1, timing_2, scores_1, scores_2, none_score):
 
    aligned_word_1 = []
    aligned_word_2 = []
    operations = []
    timing = []
    scoresRecomp1 = []
    scoresRecomp2 = []
    best1 = {'seq':[], 'score':[]}
    backtrace = bt[::-1]  # make it a forward trace
 
    for k in range(len(backtrace) - 1): 
        i_0, j_0 = backtrace[k]
        i_1, j_1 = backtrace[k+1]
	
 	
        w_1_letter = None
        w_2_letter = None
        op = None
 	tim = None
        if i_1 > i_0 and j_1 > j_0:  # either substitution or no-op
            if word_1[i_0] == word_2[j_0]:  # no-op, same symbol
                w_1_letter = word_1[i_0]
                w_2_letter = word_2[j_0]
		tim = timing_1[i_0]
		scoreTp = (scores_1[i_0]+scores_2[j_0])/2.0
		scoresRecomp1.append(scoreTp)
		scoresRecomp2.append(scoreTp)
		best1['score'].append(scoreTp)
		best1['seq'].append(word_1[i_0])
                op = " "
            else:  # cost increased: substitution
                w_1_letter = word_1[i_0]
                w_2_letter = word_2[j_0]
		tim = timing_1[i_0]
                op = "s"
		scoresRecomp1.append((scores_1[i_0])/2.0)
		scoresRecomp2.append((scores_2[j_0])/2.0)
		values = [(scores_1[i_0])/2.0,(scores_2[j_0])/2.0]
		arcs = [word_1[i_0],word_2[j_0]]
		max_index, max_value = max(enumerate(values), key=operator.itemgetter(1))
		best1['score'].append(max_value)
		best1['seq'].append(arcs[max_index])
        elif i_0 == i_1:  # insertion
            w_1_letter = " "
            w_2_letter = word_2[j_0]
            op = "i"
	    tim = timing_2[j_0]
	    scoresRecomp1.append(none_score)
	    scoresRecomp2.append((scores_2[j_0])/2.0)
	    values = [none_score,(scores_2[j_0])/2.0]
	    arcs = ['!NULL',word_2[j_0]]
  	    max_index, max_value = max(enumerate(values), key=operator.itemgetter(1))
	    best1['score'].append(max_value)
	    best1['seq'].append(arcs[max_index])	
	    
        else: #  j_0 == j_1,  deletion
            w_1_letter = word_1[i_0]
            w_2_letter = " "
            op = "d"
	    tim = timing_1[i_0]
	    scoresRecomp1.append((scores_1[i_0])/2.0)
	    scoresRecomp2.append(none_score)
	    values = [(scores_1[i_0])/2.0,none_score]
	    arcs = [word_1[i_0], '!NULL']
  	    max_index, max_value = max(enumerate(values), key=operator.itemgetter(1))
	    best1['score'].append(max_value)
	    best1['seq'].append(arcs[max_index])

 	#print tim
        aligned_word_1.append(w_1_letter)
        aligned_word_2.append(w_2_letter)
        operations.append(op)
	timing.append(tim)
 
	#Time readjustment and score averaging
	for op in range(len(operations)):
		if operations[op] == 'i' :
			timeI = timing[op]
			if op != 0 and timeI[0] <= timing[op-1][1]:
				timing[op][0] = timing[op-1][1]+1
			if op != len(operations)-1 and timeI[1] >= timing[op+1][0]:
				if timing[op+1][0] > timing[op][0]+1:
					timing[op][1] = timing[op+1][0]-1
				else:
					timing[op+1][0] = max(timing[op][1]+1,timing[op][0]+1)
					timing[op][1] = timing[op+1][0]-1
		
    return aligned_word_1, aligned_word_2, operations, timing, scoresRecomp1, scoresRecomp2, best1



def test():
	#from minEditAlign import *
	print 'test'

def extractMLF():
filenames = ['/grph-hybrid-bg/grph-tandem-merge-bg/dev03_DEV001-20010117-XX2000/decode/rescore.mlf','/grph-tandem-bg/grph-plp-merge-bg/PR4000.0/dev03_DEV001-20010117-XX2000/decode/rescore.mlf']
mlf = [];
mlfDet = [];
none_score = 0;
indir1 = '/remote/mlsalt-2016/ct506/MLSALT11'+ filenames[0]
indir2 = '/remote/mlsalt-2016/ct506/MLSALT11'+ filenames[1]
text1 = open(indir1).read();
text2 = open(indir2).read();
recs1 = text1.split('.rec"\n')
recs2 = text2.split('.rec"\n')
mlf.append('#!MLF!#\n')

mlf.append('"*'+recs1[0].split('lattices')[1]+'.rec"\n')
mlfDet.append('*'+recs1[0].split('lattices')[1]+'\n')
for i in range(1, len(recs1)):
		words1 = recs1[i].split('.\n')[0].split('\n')
		words_1, scores_1, timing_1 = extractHyp(words1)
		words2 = recs2[i].split('.\n')[0].split('\n')
		words_2, scores_2, timing_2 = extractHyp(words2)
		D, B = wagner_fischer(words_1, words_2, timing_1, timing_2)
		bt = naive_backtrace(B)	 
		aligned_word_1, aligned_word_2, operations, timing, scoresRecomp1, scoresRecomp2, best1 = align(words_1, words_2, bt, timing_1, timing_2, scores_1, scores_2, none_score)
		for besti in range(len(best1['seq'])):
			mlf.append(str(int(timing[besti][0])) + ' ' + str(int(timing[besti][1])) + ' ' + best1['seq'][besti] + ' ' + str(best1['score'][besti]) + '\n')
			mlfDet.append( aligned_word_1[besti] + ' ' + aligned_word_2[besti] + ' ' + str(scoresRecomp1[besti]) + ' '+ str(scoresRecomp2[besti]) + ' '+ operations[besti] + '\n')
		if i < len(recs1)-1:		
			mlf.append('.\n"*'+recs1[i].split('.\n')[1].split('lattices')[1]+'.rec"\n')
			mlfDet.append('*'+recs1[i].split('.\n')[1].split('lattices')[1]+'\n')

mlf.append('.')
mlfFile = open('rescore.mlf', 'w')
for item in mlf:
  	mlfFile.write("%s" % item)

mlfFile2 = open('rescore2.mlf', 'w')
for item in mlfDet:
  	mlfFile2.write("%s" % item)



def extractHyp(words1):
	words_1 = []
	scores_1 = []
	timing_1 = []
	for words_i in range(len(words1)-1):
				hyps = words1[words_i].split(' ')
				words_1.append(hyps[2])
				scores_1.append(float(hyps[3]))
				timing_1.append([float(hyps[0]), float(hyps[1])])
	return words_1, scores_1, timing_1

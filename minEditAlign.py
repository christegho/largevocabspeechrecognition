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
	    
	    print l_1, l_2, timing_1[i-1],timing_2[j-1],D[i-1,j],D[i, j-1], D[i-1,j-1],idt, ct,i,j
	    
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
	    D_[i,j] = mo2

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
		scoresRecomp1.push(scoreTp)
		scoresRecomp2.push(scoreTp)
		best1['score'].push(scoreTp)
		best1['seq'].push(word_1[i_0])
                op = " "
            else:  # cost increased: substitution
                w_1_letter = word_1[i_0]
                w_2_letter = word_2[j_0]
		tim = timing_1[i_0]
                op = "s"
		scoresRecomp1.push(none_score)
		scoresRecomp2.push((scores_2[j_0])/2.0)
		values = [(scores_1[i_0])/2.0,(scores_2[j_0])/2.0]
		arcs = [word_1[i_0],word_2[j_0]]
		max_index, max_value = max(enumerate(values), key=operator.itemgetter(1))
		best1['score'].push(max_value)
		best1['seq'].push(arcs[max_index])
        elif i_0 == i_1:  # insertion
            w_1_letter = " "
            w_2_letter = word_2[j_0]
            op = "i"
	    tim = timing_2[j_0]
	    scoresRecomp1.push(none_score)
	    scoresRecomp2.push((scores_2[j_0])/2.0)
	    values = [none_score,(scores_2[j_0])/2.0]
	    arcs = ['!NULL',word_2[j_0]]
  	    max_index, max_value = max(enumerate(values), key=operator.itemgetter(1))
	    best1['score'].push(max_value)
	    best1['seq'].push(arcs[max_index])	
	    
        else: #  j_0 == j_1,  deletion
            w_1_letter = word_1[i_0]
            w_2_letter = " "
            op = "d"
	    tim = timing_1[i_0]
	    scoresRecomp1.push((scores_1[i_0])/2.0)
	    scoresRecomp2.push(none_score)
	    values = [(scores_1[i_0])/2.0,none_score]
	    arcs = [word_1[i_0], '!NULL']
  	    max_index, max_value = max(enumerate(values), key=operator.itemgetter(1))
	    best1['score'].push(max_value)
	    best1['seq'].push(arcs[max_index])

 	print tim
        aligned_word_1.append(w_1_letter)
        aligned_word_2.append(w_2_letter)
        operations.append(op)
	timing.append(tim)
 
	#Time readjustment and score averaging
	for op in range(len(operations)):
		if operations[op] == 'i' :
			scoresRecomp1.push(.2)
			scoresRecomp2.push(.2)
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
	from minEditAlign import *
	timing_2 = [[1,3],[4,7],[8,10]]
	timing_1 = [[4,5],[6,8]]
	word_2 = ["jo", "lo", "po"]
	word_1 = ["jo", "po"]
		 
	D, B = wagner_fischer(word_1, word_2, timing_1, timing_2)
	bt = naive_backtrace(B)
		 

	alignment_table = align(word_1, word_2, bt, timing_1, timing_2)
	alignment_table

	 
	print("\nAlignment:")
	print(alignment_table)

#

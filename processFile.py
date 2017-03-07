filenames = ['/pruning3.txt']
expList = [];

for filename in filenames:
	indir = '/remote/mlsalt-2016/ct506/MLSALT11'+ filename
	text = open(indir).read();
	exps = text.split('--------------------------------------------------\n')
	for exp in exps:
		if (len(exp)!=0):
			exp = exp.split('\n')
			expList.append(exp[0])
			nodes = 0
			arcs = 0
			latticeN = 0
			for line in exp[1:]:
				if (line != ''):
					arcsNodes = line.split()[5].split('/')
					nodes += int(arcsNodes[0])
					arcs += int(arcsNodes[1])
					latticeN += 1
			expList.append(nodes)
			expList.append(arcs)
			expList.append(latticeN)
			expList.append('\n')

import csv

with open('pruning_3.csv', 'wb') as myfile:
    wr = csv.writer(myfile, delimiter=',' ,quoting=csv.QUOTE_MINIMAL)
    wr.writerow(expList)

filenames = ['/uttLen4.txt']
expList = [];

for filename in filenames:
	indir = '/remote/mlsalt-2016/ct506/MLSALT11'+ filename
	text = open(indir).read();
	exps = text.split('--------------------------------------------------\n')
	for exp in exps:
		if (len(exp)!=0):
			exp = exp.split('\n')
			expList.append(exp[0])
			uttLen = 0
			latticeN = 0
			for line in exp[1:]:
				if (line != ''):
					arcsNodes = line.split()[5]
					uttLen += float(arcsNodes[0])
					latticeN += 1
			expList.append(uttLen)
			expList.append(latticeN)
			expList.append('\n')

import csv

with open('uttLen4.csv', 'wb') as myfile:
    wr = csv.writer(myfile, delimiter=',' ,quoting=csv.QUOTE_MINIMAL)
    wr.writerow(expList)



filenames = ['/acousticAdaptScoring_cn_lm.txt']
expList = [];

for filename in filenames:
	indir = '/remote/mlsalt-2016/ct506/MLSALT11'+ filename
	text = open(indir).read();
	exps = text.split('--------------------------------------\n')
	for exp in exps:
		if (len(exp)!=0):
			exp = exp.split('\n')
			expList.append(exp[0])
			expList.append(exp[1].split('   ')[12])
			expList.append(exp[1].split('   ')[13].split(' |')[1])
			expList.append('\n')

import csv

with open('acousticAdapScoring_cn_lm.csv', 'wb') as myfile:
    wr = csv.writer(myfile, delimiter=',' ,quoting=csv.QUOTE_MINIMAL)
    wr.writerow(expList)

shows = ['eval03_DEV011-20010206-XX1830','eval03_DEV012-20010217-XX1000','eval03_DEV013-20010220-XX2000','eval03_DEV014-20010221-XX1830','eval03_DEV015-20010225-XX0900','eval03_DEV016-20010228-XX2100']

for show in shows:
	indir = 'plp-tglm_int3_'+show+'/'+show+'/rescore/rescore.mlf' 
	text = open(indir).read();
	bestLt = text.split('.\n"')
	dat = [];
	for i in range(len(bestLt)):
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
	outfile = open('plp-tglm_int3_'+show+'/'+show+'4.dat','w')
	outfile.write(" ".join(dat))
	outfile.close()


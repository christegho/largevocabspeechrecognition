
iter = True;
command = '';
for i in range(6):
	command += 'base/bin/LMerge -C lib/cfgs/hlm.cfg -i ' + str(lmdaShows[i,1]) +  ' lms/lm2 -i ' + str(lmdaShows[i,2]) +  ' lms/lm3 -i '+ str(lmdaShows[i,3]) +  ' lms/lm4 -i '+ str(lmdaShows[i,4]) +  ' lms/lm5 '+  'lib/wlists/train.lst lms/lm1 lm_int'+ str(iter) + shows[i] + '\n'


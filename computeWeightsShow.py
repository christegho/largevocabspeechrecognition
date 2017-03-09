import numpy as np
import argparse
def getWeights(inStream, outFile):
	#The following function computes the weights for the different LMs based on the EM 
	#procedure for LM component weights
	streamLength = len([float(line.rstrip('\n')) for line in open(inStream+'/streamlm1')]) 
	streams=np.zeros((5,streamLength))
	for i in range(5):
		streams[i,:] = [float(line.rstrip('\n')) for line in open(inStream+'/streamlm'+str(i+1))]
	lmda = [1/float(15), 2/float(15), 3/float(15), 4/float(15), 5/float(15)]
	lmdai= np.zeros((100,5))
	pa = np.zeros((5,streamLength))
	for i in range(100):
		for ld in range(5):
			pa[ld] = np.divide(lmda[ld]*streams[ld,:], (lmda[0]*streams[0,:] + lmda[1]*streams[1,:] + lmda[2]*streams[2,:] + lmda[3]*streams[3,:] + lmda[4]*streams[4,:]))
			lmda[ld] = sum(pa[ld])/streamLength		
		lmdai[i,:] = lmda
	#print show	
	#print lmda
	command = 'base/bin/LMerge -C lib/cfgs/hlm.cfg -i ' + str(lmda[1]) +  ' lms/lm2 -i ' + str(lmda[2]) +  ' lms/lm3 -i '+ str(lmda[3]) +  ' lms/lm4 -i '+ str(lmda[4]) +  ' lms/lm5 '+  'lib/wlists/train.lst lms/lm1 '+outFile+'/lm_int \n'
	print command


def main() :
    
    parser = argparse.ArgumentParser(description='ROVER.')
    parser.add_argument('--in', dest='inFile', action='store', required=True,
                        help='alpha')
    parser.add_argument('--out', dest='outFile', action='store', required=True,
                        help='alpha')
    
    args = parser.parse_args()
    getWeights(args.inFile, args.outFile)

    
    
if __name__ == '__main__':
    main()

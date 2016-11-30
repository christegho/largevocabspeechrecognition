import matplotlib.pyplot as plt
import numpy as np
shows = ['eval03_DEV011-20010206-XX1830','eval03_DEV012-20010217-XX1000','eval03_DEV013-20010220-XX2000','eval03_DEV014-20010221-XX1830','eval03_DEV015-20010225-XX0900','eval03_DEV016-20010228-XX2100']
lmdaShows = np.zeros((6,5))
showIndex = 0
for show in shows:
	#The following function computes the weights for the different LMs based on the EM 
	#procedure for LM component weights
	streamLength = len([float(line.rstrip('\n')) for line in open(show+'/stream'+show+'lm1')]) 
	streams=np.zeros((5,streamLength))
	for i in range(5):
		streams[i,:] = [float(line.rstrip('\n')) for line in open(show+'/stream'+show+'lm'+str(i+1))]
	lmda = [1/float(15), 2/float(15), 3/float(15), 4/float(15), 5/float(15)]
	lmdai= np.zeros((100,5))
	pa = np.zeros((5,streamLength))
	for i in range(100):
		for ld in range(5):
			pa[ld] = np.divide(lmda[ld]*streams[ld,:], (lmda[0]*streams[0,:] + lmda[1]*streams[1,:] + lmda[2]*streams[2,:] + lmda[3]*streams[3,:] + lmda[4]*streams[4,:]))
			lmda[ld] = sum(pa[ld])/streamLength		
		lmdai[i,:] = lmda
	print show	
	print lmda
	lmdaShows[showIndex,:] = lmda
	showIndex +=1
	plt.figure()
	plt.plot(lmdai)
	plt.xlabel('iterations')
	plt.title(show)
	plt.legend(['lm1', 'lm2', 'lm3', 'lm4', 'lm5'])
	plt.gcf().show()


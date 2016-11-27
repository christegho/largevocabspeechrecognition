import matplotlib.pyplot as plt
import numpy as np

def computeWeights():
#The following function computes the weights for the different LMs based on the EM 
#procedure for LM component weights
 
streams=np.zeros((5,25672))
for i in range(5):
	streams[i,:] = [float(line.rstrip('\n')) for line in open('streamlm'+str(i+1))]

lmda = [ 0.33333333,  0.2       ,  0.13333333,  0.06666667,  0.26666667]
lmdai= np.zeros((100,5))
pa = np.zeros((5,25672))

for i in range(100):
	for ld in range(5):
		pa[ld] = np.divide(lmda[ld]*streams[ld,:], (lmda[0]*streams[0,:] + lmda[1]*streams[1,:] + lmda[2]*streams[2,:] + lmda[3]*streams[3,:] + lmda[4]*streams[4,:]))
		lmda[ld] = sum(pa[ld])/25672		
	lmdai[i,:] = lmda

plt.plot(lmdai)
plt.xlabel('iterations')
plt.legend(['lm1', 'lm2', 'lm3', 'lm4', 'lm5'])
plt.show()


import matplotlib.pyplot as plt
import numpy as np
streams=np.zeros((5,25672))
for i in range(5):
	streams[i,:] = [float(line.rstrip('\n')) for line in open('streamlm'+str(i+1))]

lmda = [.2]*5
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


filenames = ['cnrover3.txt']
indir1 = '/remote/mlsalt-2016/ct506/MLSALT11/'+ filenames[0]
text = open(indir1).read();
lines = text.split('|\n')
systems = {}
for line in lines:
    if line != '':
	sysInfo = line.split('\n')
	systemInfo = sysInfo[0].split(' ')
	scores = sysInfo[1].split(' ')
	if systemInfo[3] not in systems:
		systems[systemInfo[3]] = {}
	if systemInfo[4] not in systems[systemInfo[3]]:
		systems[systemInfo[3]][systemInfo[4]] = {'alp': systemInfo[0], 'scn': systemInfo[1], 'tim': systemInfo[2], 'score':scores[10], 'cnc':scores[13]}
	if (float(scores[10]) < float(systems[systemInfo[3]][systemInfo[4]]['score'])):
		systems[systemInfo[3]][systemInfo[4]] = {'alp': systemInfo[0], 'scn': systemInfo[1], 'tim': systemInfo[2], 'score':scores[10], 'cnc':scores[13]}

minModels = {}
minScore = 60.0
for ref in systems:
    for model in systems[ref]:
	if ref not in minModels:
		minModels[ref] = systems[ref][model]
		minModels[ref]['model'] = model
	if float(systems[ref][model]['score']) < float(minModels[ref]['score']):
		minModels[ref] = systems[ref][model]
		minModels[ref]['model'] = model
		if float(systems[ref][model]['score']) < minScore:
			minScore = float(systems[ref][model]['score'])
			print minScore

import csv

with open('evalminmodels_cn3.txt', 'wb') as f:
    w = csv.writer(f)
    w.writerow(minModels.items())

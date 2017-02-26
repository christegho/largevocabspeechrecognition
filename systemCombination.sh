#1 - a
# From rescore.mlf to score.mlf
for pruning in def 4k def-4 4k-4
do
for model in  plp grph-plp tandem grph-tandem
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
./base/bin/HLEd -i ${model}-adapt-bg/${pruning}/adaptedby-${model1}/dev03_DEV001-20010117-XX2000/decode-${model1}/score.mlf -l '*' /dev/null ${model}-adapt-bg/${pruning}/adaptedby-${model1}/dev03_DEV001-20010117-XX2000/decode-${model1}/rescore.mlf
done
done
done

for model in  plp grph-plp tandem grph-tandem
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
./base/bin/HLEd -i ${model1}-bg/${model}-merge-bg/dev03_DEV001-20010117-XX2000/decode/score.mlf -l '*' /dev/null ${model1}-bg/${model}-merge-bg/dev03_DEV001-20010117-XX2000/decode/rescore.mlf
done
done

for PRUNE in   4000.0
do
for model in  plp grph-plp tandem grph-tandem
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
./base/bin/HLEd -i ${model1}-bg/${model}-merge-bg/PR${PRUNE}/dev03_DEV001-20010117-XX2000/decode/score.mlf -l '*' /dev/null ${model1}-bg/${model}-merge-bg/PR${PRUNE}/dev03_DEV001-20010117-XX2000/decode/rescore.mlf
done
done
done

for model in  plp grph-plp tandem grph-tandem
do
./base/bin/HLEd -i ${model}-bg/dev03_DEV001-20010117-XX2000/decode/score.mlf -l '*' /dev/null ${model}-bg/dev03_DEV001-20010117-XX2000/decode/rescore.mlf
done

for PRUNE in 4000.0 #  250.0 400.0 500.0 600.0 1000.0 2000.0 4000.0
do
for model in  plp grph-plp tandem grph-tandem 
do
./base/bin/HLEd -i ${model}-bg/PR${PRUNE}/dev03_DEV001-20010117-XX2000/decode/score.mlf -l '*' /dev/null ${model}-bg/PR${PRUNE}/dev03_DEV001-20010117-XX2000/decode/rescore.mlf
done
done



#TODO
#1 - b
./base/bin/HResults -t -f -I plp-bg/dev03_DEV001-20010117-XX2000/decode/score.mlf lib/wlists/train.lst grph-plp-bg/dev03_DEV001-20010117-XX2000/decode/rescore.mlf


#####################################################################
#2 a Scoring with Filter
#####################################################################

#####################################################################
#2 Oracle Error
#####################################################################
for model1 in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model2 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model3 in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model4 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for ta in 0.2 0.5 0.8
do
for alpha in  0.2 0.4 0.6 0.8
do
for none in 0 -200 -600 -1000 -1500 -2000
do
if [ "${model1}-${model2}" != "${model3}-${model4}" ]
then
file1=${model1}-adapt-bg/def-4/adaptedby-${model2}
file2=${model3}-adapt-bg/def-4/adaptedby-${model4}
d1=decode-${model2}
d2=decode-${model4}
echo $alpha $none $ta ${model1}-${model2} ${model3}-${model4} >>testingSys.txt
echo $alpha $none $ta ${model1}-${model2} ${model3}-${model4} 
python minEditAlign.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2
./scripts/score.sh copy dev03sub decode >>testingSys.txt
fi
done
done
done
done
done
done
done
#####################################################################
#3 Generate Confusion Networks and Confidence Scores
#####################################################################



for pruning in def 4k def-4 4k-4
do
for model in  plp grph-plp tandem grph-tandem
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
./scripts/cnrescore.sh dev03_DEV001-20010117-XX2000 ${model}-adapt-bg/${pruning}/adaptedby-${model1} decode-${model1} ${model}-adapt-bg/${pruning}/adaptedby-${model1}
done
done
done

for model in  plp grph-plp tandem grph-tandem
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
./scripts/cnrescore.sh dev03_DEV001-20010117-XX2000 ${model1}-bg/${model}-merge-bg decode ${model1}-bg/${model}-merge-bg
done
done

for PRUNE in   4000.0
do
for model in  plp grph-plp tandem grph-tandem
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
./scripts/cnrescore.sh dev03_DEV001-20010117-XX2000 ${model1}-bg/${model}-merge-bg/PR${PRUNE} decode ${model1}-bg/${model}-merge-bg/PR${PRUNE}
done
done
done

for model in  plp grph-plp tandem grph-tandem
do
./scripts/cnrescore.sh dev03_DEV001-20010117-XX2000 ${model}-bg decode ${model}-bg
done

for PRUNE in 4000.0 #  250.0 400.0 500.0 600.0 1000.0 2000.0 4000.0
do
for model in  plp grph-plp tandem grph-tandem 
do
./scripts/cnrescore.sh dev03_DEV001-20010117-XX2000 ${model}-bg/PR${PRUNE} decode ${model}-bg/PR${PRUNE}
done
done

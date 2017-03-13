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
for model1 in  plp grph-plp tandem grph-tandem
do
for model2 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model3 in  plp grph-plp tandem grph-tandem
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

for model1 in  grph-plp
do
for model2 in grph-hybrid
do
for model3 in  grph-tandem
do
for model4 in grph-hybrid
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

for model1 in tandem grph-tandem
do
for model2 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model3 in  plp grph-plp tandem grph-tandem
do
for model4 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for ta in 0.5
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


###################
for model1 in  plp grph-plp tandem grph-tandem
do
for model2 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model3 in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for ta in 0.5
do
for alpha in  0.2 0.4 0.6 0.8
do
for none in 0 -200 -600 -1000 -1500 -2000
do
file1=${model1}-adapt-bg/def-4/adaptedby-${model2}
file2=${model3}-bg/PR4000.0
d1=decode-${model2}
d2=decode
echo $alpha $none $ta ${model1}-${model2} ${model3} >>testingSys.txt
echo $alpha $none $ta ${model1}-${model2} ${model3} 
python minEditAlign.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2
./scripts/score.sh copy dev03sub decode >>testingSys.txt
done
done
done
done
done
done

for model1 in  plp grph-plp tandem grph-tandem
do
for model2 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model3 in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for ta in 0.5
do
for alpha in  0.2 0.4 0.6 0.8
do
for none in 0 -200 -600 -1000 -1500 -2000
do
file2=${model1}-adapt-bg/def-4/adaptedby-${model2}
file1=${model3}-bg/PR4000.0
d2=decode-${model2}
d1=decode
echo $alpha $none $ta ${model3} ${model1}-${model2} >>testingSys.txt
echo $alpha $none $ta ${model3} ${model1}-${model2}
python minEditAlign.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2
./scripts/score.sh copy dev03sub decode >>testingSys.txt
done
done
done
done
done
done


for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model2 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for ta in 0.5
do
for alpha in  0.2 0.4 0.6 0.8
do
for none in 0 -200 -600 -1000 -1500 -2000
do
if [ "${model1}" != "${model2}" ]
then
file1=${model1}-bg/PR4000.0
file2=${model2}-bg/PR4000.0
d1=decode
d2=decode
echo $alpha $none $ta ${model1} ${model2} >>testingSys2.txt
echo $alpha $none $ta ${model1} ${model2}
python minEditAlign.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2
./scripts/score.sh copy dev03sub decode >>testingSys2.txt
fi
done
done
done
done
done


#####################################################################
#3 Generate Confusion Networks and Confidence Scores
#####################################################################



for pruning in def-4
do
for model in  plp grph-plp tandem grph-tandem
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
./scripts/cnrescoreExt.sh -LMMODEL $model dev03_DEV001-20010117-XX2000  ${model}-adapt-bg/${pruning}/adaptedby-${model1} decode-${model1} ${model}-adapt-bg/${pruning}/adaptedby-${model1}/CN
done
done
done

for model in  plp grph-plp tandem grph-tandem  hybrid grph-hybrid
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
./scripts/cnrescore.sh dev03_DEV001-20010117-XX2000 ${model1}-bg/${model}-merge-bg decode ${model1}-bg/${model}-merge-bg
done
done

for PRUNE in   4000.0
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
./scripts/cnrescore.sh dev03_DEV001-20010117-XX2000 ${model1}-bg/${model}-merge-bg/PR${PRUNE} decode ${model1}-bg/${model}-merge-bg/PR${PRUNE}
done
done
done

for model in  plp grph-plp tandem grph-tandem  hybrid grph-hybrid
do
./scripts/cnrescore.sh dev03_DEV001-20010117-XX2000 ${model}-bg decode ${model}-bg
done

for PRUNE in 4000.0 #  250.0 400.0 500.0 600.0 1000.0 2000.0 4000.0
do
for model in  plp grph-plp tandem grph-tandem   hybrid grph-hybrid
do
./scripts/cnrescore.sh dev03_DEV001-20010117-XX2000 ${model}-bg/PR${PRUNE} decode ${model}-bg/PR${PRUNE}
done
done




for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
./scripts/cnrescore.sh dev03_DEV001-20010117-XX2000 ${model1}-bg/${model}-merge-bg decode ${model1}-bg/${model}-merge-bg
done
done

for lmscale in 6 17 21 27 33 39
do
for model in  plp grph-plp tandem grph-tandem  hybrid grph-hybrid
do
./scripts/cnrescore.sh -LMSCALE ${lmscale} dev03_DEV001-20010117-XX2000 ${model}-bg decode ${model}-bg/LM${lmscale}
done
done

for model in  plp grph-plp tandem grph-tandem  hybrid grph-hybrid
do
./scripts/cnrescoreExt.sh -LMMODEL $model dev03_DEV001-20010117-XX2000 ${model}-bg decode ${model}-bg/CN
done

#####################################################
#mapping
#####################################################

for pruning in def-4
do
for model in  plp grph-plp tandem grph-tandem
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
dir=${model}-adapt-bg/${pruning}/adaptedby-${model1}/CN/dev03_DEV001-20010117-XX2000/decode-${model1}_cn
base/conftools/smoothtree-mlf.pl lib/trees/${model}-bg_decode_cn.tree ${dir}/rescore.mlf >> ${dir}/rescore-tree.mlf
done
done
done

for model in  plp grph-plp tandem grph-tandem   hybrid grph-hybrid
do
dir=${model}-bg/CN/dev03_DEV001-20010117-XX2000/decode_cn
base/conftools/smoothtree-mlf.pl lib/trees/${model}-bg_decode_cn.tree ${dir}/rescore.mlf >> ${dir}/rescore-tree.mlf
done

#Scoring with map tree

#scoring
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
echo -------------------------------------------------- >> acousticAdaptScoring_cn_lm_map.txt
echo ${model} default  >> acousticAdaptScoring_cn_lm_map.txt
./scripts/score.sh -CONFTREE lib/trees/${model}-bg_decode_cn.tree ${model}-bg/CN dev03sub decode_cn  >> acousticAdaptScoring_cn_lm_map.txt
done

for pruning in def-4 
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
echo -------------------------------------------------- >> acousticAdaptScoring_cn_lm_map.txt
echo $model $model1 ${pruning} >> acousticAdaptScoring_cn_lm_map.txt
./scripts/score.sh -CONFTREE lib/trees/${model}-bg_decode_cn.tree ${model}-adapt-bg/${pruning}/adaptedby-${model1}/CN dev03sub decode-${model1}_cn >> acousticAdaptScoring_cn_lm_map.txt
done
done
done
#####################################
## Scoring CNs 
#####################################

#scoring
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
echo -------------------------------------------------- >> aa2_cn.txt
echo ${model} default withoutNOFILT >> aa2_cn.txt
./scripts/score.sh ${model}-bg dev03sub decode_cn  >> aa2_cn.txt
done

for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
echo -------------------------------------------------- >> aa2_cn.txt
echo ${model} default  >> aa2_cn.txt
./scripts/score.sh ${model}-bg/CN dev03sub decode_cn  >> aa2_cn.txt
done


#scoring
for lmscale in 6 17 21 27 33 39
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
echo -------------------------------------------------- >> aa2_cn.txt
echo ${model} default withoutNOFILT ${lmscale} >> aa2_cn.txt
./scripts/score.sh ${model}-bg/LM${lmscale} dev03sub decode_cn  >> aa2_cn.txt
done
done


for PRUNE in 4000.0 
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
	echo -------------------------------------------------- >> aa2_cn.txt
	echo ${model} ${PRUNE} >> aa2_cn.txt
	./scripts/score.sh  -NOFILT ${model}-bg/PR${PRUNE} dev03sub decode_cn >> aa2_cn.txt
done
done


for pruning in def-4 
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
echo -------------------------------------- >> acousticAdaptScoring_cn.txt
echo $model $model1 ${pruning}-defaultLM >> acousticAdaptScoring_cn.txt
./scripts/score.sh ${model}-adapt-bg/${pruning}/adaptedby-${model1} dev03sub decode-${model1}_cn >> acousticAdaptScoring_cn.txt
done
done
done

for pruning in def-4 
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
echo -------------------------------------- >> acousticAdaptScoring_cn_lm.txt
echo $model $model1 ${pruning} >> acousticAdaptScoring_cn_lm.txt
./scripts/score.sh ${model}-adapt-bg/${pruning}/adaptedby-${model1}/CN dev03sub decode-${model1}_cn >> acousticAdaptScoring_cn_lm.txt
done
done
done

############################################
#CN ROVER 
############################################
for model1 in  plp grph-plp tandem grph-tandem
do
for model2 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model3 in  plp grph-plp tandem grph-tandem
do
for model4 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for ta in 0.5
do
for alpha in  0.3 0.5 0.8
do
for none in 0 0.2 0.4 0.7 0.9
do
if [ "${model1}-${model2}" != "${model3}-${model4}" ]
then
file1=${model1}-adapt-bg/def-4/adaptedby-${model2}/CN
file2=${model3}-adapt-bg/def-4/adaptedby-${model4}/CN
d1=decode-${model2}_cn
d2=decode-${model4}_cn
echo $alpha $none $ta ${model1}-${model2} ${model3}-${model4} >>testingSys_cn.txt
echo $alpha $none $ta ${model1}-${model2} ${model3}-${model4} 
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2
./scripts/score.sh copy dev03sub decode >>testingSys_cn.txt
fi
done
done
done
done
done
done
done

for model1 in  plp grph-plp tandem grph-tandem
do
for model2 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model3 in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for ta in 0.5
do
for alpha in  0.2 0.4 0.6 0.8
do
for none in 0 0.2 0.4 0.7 0.9
do
file1=${model1}-adapt-bg/def-4/adaptedby-${model2}/CN
file2=${model3}-bg/CN
d1=decode-${model2}_cn
d2=decode_cn
echo $alpha $none $ta ${model1}-${model2} ${model3} >>testingSys_cn.txt
echo $alpha $none $ta ${model1}-${model2} ${model3} 
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2
./scripts/score.sh copy dev03sub decode >>testingSys_cn.txt
done
done
done
done
done
done

for model1 in  plp grph-plp tandem grph-tandem
do
for model2 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model3 in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for ta in 0.5
do
for alpha in  0.2 0.4 0.6 0.8
do
for none in 0 0.2 0.4 0.7 0.9
do
file2=${model1}-adapt-bg/def-4/adaptedby-${model2}
file1=${model3}-bg/CN
d2=decode-${model2}_cn
d1=decode_cn
echo $alpha $none $ta ${model3} ${model1}-${model2} >>testingSys_cn.txt
echo $alpha $none $ta ${model3} ${model1}-${model2}
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2
./scripts/score.sh copy dev03sub decode >>testingSys_cn.txt
done
done
done
done
done
done


for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model2 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for ta in 0.5
do
for alpha in  0.2 0.4 0.6 0.8
do
for none in 0 0.2 0.4 0.7 0.9
do
if [ "${model1}" != "${model2}" ]
then
file1=${model1}-bg/CN
file2=${model2}-bg/CN
d1=decode_cn
d2=decode_cn
echo $alpha $none $ta ${model1} ${model2} >>testingSys_cn.txt
echo $alpha $none $ta ${model1} ${model2}
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2
./scripts/score.sh copy dev03sub decode >>testingSys_cn.txt
fi
done
done
done
done
done

##################################################################################
##CNC #TODO
##################################################################################

for model1 in grph-hybrid
do
for model2 in hybrid 
do
for ta in -0.5 -0.3
do
for alpha in  0.2 0.4 0.6 0.8
do
for none in 0.01 0.2 0.4 0.7 0.9
do
if [ "${model1}" != "${model2}" ]
then
file1=${model1}-bg/CN
file2=${model2}-bg/CN
d1=decode_cn
d2=decode_cn
echo $alpha $none $ta ${model1} ${model2} >>CNC.txt
echo $alpha $none $ta ${model1} ${model2}
python cnc.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2
./scripts/score.sh copy1 dev03sub decode >>CNC.txt
fi
done
done
done
done
done

###########################################3
#COST function

for model1 in  plp grph-plp tandem grph-tandem
do
for model2 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model3 in  hybrid grph-hybrid
do
for ta in 0.5
do
for alpha in  0.4 0.2
do
for none in 0.4 0.2 
do
for del in 2 4 7
do
for sub in 2 4 7
do
for ins in 2 4 7
do
file1=${model1}-adapt-bg/def-4/adaptedby-${model2}/CN
file2=${model3}-bg/CN
d1=decode-${model2}_cn
d2=decode_cn
echo $alpha $none $ta ${model1}-${model2} ${model3} $sub $del $ins >>testingSys_cn2.txt
echo $alpha $none $ta ${model1}-${model2} ${model3} $sub $del $ins
python minEditAlign_cn2.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2 --del $del --ins $ins --sub $sub  
./scripts/score.sh copy dev03sub decode >>testingSys_cn2.txt
done
done
done
done
done 
done
done
done
done

for model1 in  tandem grph-tandem
do
for model2 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model3 in  hybrid grph-hybrid
do
for ta in 0.5
do
for alpha in  0.4 0.2
do
for none in 0.4 0.2 
do
for del in 2 4 7
do
for sub in 2 4 7
do
for ins in 2 4 7
do
file1=${model1}-adapt-bg/def-4/adaptedby-${model2}/CN
file2=${model3}-bg/CN
d1=decode-${model2}_cn
d2=decode_cn
echo $alpha $none $ta ${model1}-${model2} ${model3} $sub $del $ins >>testingSys_cn2.txt
echo $alpha $none $ta ${model1}-${model2} ${model3} $sub $del $ins
python minEditAlign_cn2.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2 --del $del --ins $ins --sub $sub  
./scripts/score.sh copy dev03sub decode >>testingSys_cn2.txt
done
done
done
done
done 
done
done
done
done


##########################
#CN ROVER Mapping
##########################
#IP
for model1 in  plp grph-plp tandem grph-tandem
do
for model2 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model3 in  tandem
do
for model4 in  hybrid grph-hybrid
do
for ta in 0.5
do
for alpha in  0.3 0.5 0.6 0.8
do
for none in  0.2 0.4 0.7 0.9
do
if [ "${model1}-${model2}" != "${model3}-${model4}" ]
then
file1=${model1}-adapt-bg/def-4/adaptedby-${model2}/CN
file2=${model3}-adapt-bg/def-4/adaptedby-${model4}/CN
d1=decode-${model2}_cn
d2=decode-${model4}_cn
echo $alpha $none $ta ${model1}-${model2} ${model3}-${model4} >>testingSys_cn.txt
echo $alpha $none $ta ${model1}-${model2} ${model3}-${model4} 
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2
./scripts/score.sh copy dev03sub decode >>testingSys_cn.txt
fi
done
done
done
done
done
done
done

#Done
for model1 in  plp grph-plp tandem grph-tandem
do
for model2 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model3 in grph-tandem hybrid grph-hybrid
do
for ta in 0.5
do
for alpha in  0.2 0.4 0.6 0.8
do
for none in 0.2 0.4 0.7 0.9
do
file1=${model1}-adapt-bg/def-4/adaptedby-${model2}/CN
file2=${model3}-bg/CN
d1=decode-${model2}_cn
d2=decode_cn
echo $alpha $none $ta ${model1}-${model2} ${model3} >>testingSys_cn.txt
echo $alpha $none $ta ${model1}-${model2} ${model3} 
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2
./scripts/score.sh copy dev03sub decode >>testingSys_cn.txt
done
done
done
done
done
done
#In prog
for model1 in  tandem 
do
for model2 in  hybrid grph-hybrid
do
for model3 in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for ta in 0.5
do
for alpha in  0.2 0.4 0.6 0.8
do
for none in  0.2 0.4 0.7 0.9
do
file2=${model1}-adapt-bg/def-4/adaptedby-${model2}/CN
file1=${model3}-bg/CN
d2=decode-${model2}_cn
d1=decode_cn
echo $alpha $none $ta ${model3} ${model1}-${model2} >>testingSys_cn.txt
echo $alpha $none $ta ${model3} ${model1}-${model2}
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2
./scripts/score.sh copy dev03sub decode >>testingSys_cn.txt
done
done
done
done
done
done


for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model2 in hybrid grph-hybrid
do
for ta in 0.5
do
for alpha in  0.2 0.4 0.6 0.8
do
for none in 0.2 0.4 0.7 0.9
do
if [ "${model1}" != "${model2}" ]
then
file1=${model1}-bg/CN
file2=${model2}-bg/CN
d1=decode_cn
d2=decode_cn
echo $alpha $none $ta ${model1} ${model2} >>testingSys_cn.txt
echo $alpha $none $ta ${model1} ${model2}
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2
./scripts/score.sh copy dev03sub decode >>testingSys_cn.txt
fi
done
done
done
done
done


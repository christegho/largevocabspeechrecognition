###########################################
# determinise the lattices
###########################################
for show in $(seq 101 212)
do
for model in  plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
./scripts/mergelatsExt.sh -BEAMPRUNE 4000.0 -SYS ${model} YTBElect_YTB${show}-XXXXXXXX-XXXXXX lattices decode ${model}-bg
done
done



for show in $(seq 101 212)
do
for PRUNE in 4000.0
do
for model in  tandem plp hybrid grph-hybrid #grph-plp grph-tandem
do
./scripts/hmmrescoreExt.sh -PRUNE ${PRUNE} YTBElect_YTB${show}-XXXXXXXX-XXXXXX ${model}-bg merge ${model}-bg ${model}
done
done
done



#################################################################################################################
#2) Using the 1-best hypothesis generated from the bigram lattice, produce \cas- caded CMLLR and MLLR transforms.
#################################################################################################################
#Rescore determinized lattices with original and other acoustic models for cross adaptation

for show in $(seq 101 212)
do
for model in  hybrid grph-hybrid #grph-plp grph-tandem plp tandem 
do
for model1 in plp tandem  #grph-plp grph-tandem hybrid grph-hybrid
do
./scripts/hmmrescore.sh YTBElect_YTB${show}-XXXXXXXX-XXXXXX ${model}-bg merge ${model1}-bg/${model}-merge-bg ${model1}
done
done
done

for show in $(seq 101 212)
do
for model in  plp #grph-plp grph-tandem plp tandem 
do
for model1 in plp  #grph-plp grph-tandem hybrid grph-hybrid
do
./scripts/hmmrescore.sh YTBElect_YTB${show}-XXXXXXXX-XXXXXX ${model}-bg merge ${model1}-bg/${model}-merge-bg ${model1}
done
done
done



###########################################
#Adapt and cross adapt - hypothesis obtained from rescoring model lattices using model 1
###########################################
#TODO
for show in $(seq 101 212)
do
for model in  plp  tandem  #grph-plp grph-tandem
do
for model1 in  hybrid grph-hybrid #grph-plp grph-tandem tandem plp
do
./scripts/hmmadaptExt.sh -OUTPASS adapt-${model1} YTBElect_YTB${show}-XXXXXXXX-XXXXXX ${model1}-bg/${model}-merge-bg decode ${model}-adapt-bg/def-4/adaptedby-${model1} ${model}
done
done
done
#Done
for show in $(seq 101 212)
do
for model in  plp 
do
for model1 in  plp
do
./scripts/hmmadaptExt.sh -OUTPASS adapt-${model1} YTBElect_YTB${show}-XXXXXXXX-XXXXXX ${model1}-bg/${model}-merge-bg decode ${model}-adapt-bg/def-4/adaptedby-${model1} ${model}
done
done
done
###########################################
#These transforms can then be used to rescore lattices:
###########################################

for show in $(seq 101 212)
do
for model in  plp  tandem  #grph-plp grph-tandem
do
for model1 in  hybrid grph-hybrid #grph-plp grph-tandem tandem plp
do
./scripts/hmmrescoreExt.sh -PRUNE 4000.0 -ADAPT ${model}-adapt-bg/def-4/adaptedby-${model1} adapt-${model1} -OUTPASS decode-${model1} YTBElect_YTB${show}-XXXXXXXX-XXXXXX ${model}-bg merge ${model}-adapt-bg/def-4/adaptedby-${model1} ${model}
done
done
done

for show in $(seq 101 212)
do
for model in  plp 
do
for model1 in  plp
do
./scripts/hmmrescoreExt.sh -PRUNE 4000.0 -ADAPT ${model}-adapt-bg/def-4/adaptedby-${model1} adapt-${model1} -OUTPASS decode-${model1} YTBElect_YTB${show}-XXXXXXXX-XXXXXX ${model}-bg merge ${model}-adapt-bg/def-4/adaptedby-${model1} ${model}
done
done
done


###########################################
#Language Modeling
###########################################
#Produce .dat file
for show in $(seq 101 212)
do
for model in   grph-hybrid #plp grph-plp tandem grph-tandem hybrid
do
mkdir ${model}-bg/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode/streams
done
done

for show in $(seq 101 212)
do
for model in  plp  tandem  #grph-plp grph-tandem
do
for model1 in  hybrid grph-hybrid #grph-plp grph-tandem tandem plp
do
mkdir ${model}-adapt-bg/def-4/adaptedby-${model1}/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode-${model1}/streams
done
done
done


for show in $(seq 101 212)
do
for model in  plp 
do
for model1 in  plp
do
mkdir ${model}-adapt-bg/def-4/adaptedby-${model1}/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode-${model1}/streams
done
done
done

for show in $(seq 101 212)
do
for model in   grph-hybrid #plp grph-plp tandem grph-tandem hybrid
do
in=${model}-bg/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode/rescore.mlf
out=${model}-bg/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode/dat.dat
python processFileToDat.py --in $in --out $out
done
done

for show in $(seq 101 212)
do
for model in  plp  tandem  #grph-plp grph-tandem
do
for model1 in  hybrid grph-hybrid #grph-plp grph-tandem tandem plp
do
in=${model}-adapt-bg/def-4/adaptedby-${model1}/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode-${model1}/rescore.mlf
out=${model}-adapt-bg/def-4/adaptedby-${model1}/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode-${model1}/dat.dat
python processFileToDat.py --in $in --out $out
done
done
done



for show in $(seq 101 212)
do
for model in  plp  
do
for model1 in  plp
do
in=${model}-adapt-bg/def-4/adaptedby-${model1}/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode-${model1}/rescore.mlf
out=${model}-adapt-bg/def-4/adaptedby-${model1}/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode-${model1}/dat.dat
python processFileToDat.py --in $in --out $out
done
done
done

for show in $(seq 101 212)
do
for model in   grph-hybrid #plp grph-plp tandem grph-tandem hybrid
do
for lm in lm1 lm2 lm3 lm4 lm5
do
outStream=${model}-bg/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode/streams/stream${lm} 
out=${model}-bg/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode/dat.dat
base/bin/LPlex -C lib/cfgs/hlm.cfg -s $outStream -u -t lms/${lm} $out 
done
done
done

for show in $(seq 101 212)
do
for model in  plp  tandem  #grph-plp grph-tandem
do
for model1 in  hybrid grph-hybrid #grph-plp grph-tandem tandem plp
do
for lm in lm1 lm2 lm3 lm4 lm5
do
outStream=${model}-adapt-bg/def-4/adaptedby-${model1}/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode-${model1}/streams/stream${lm} 
out=${model}-adapt-bg/def-4/adaptedby-${model1}/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode-${model1}/dat.dat
base/bin/LPlex -C lib/cfgs/hlm.cfg -s $outStream -u -t lms/${lm} $out 
done
done
done
done


for show in $(seq 101 212)
do
for model in  plp
do
for model1 in  plp
do
for lm in lm1 lm2 lm3 lm4 lm5
do
outStream=${model}-adapt-bg/def-4/adaptedby-${model1}/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode-${model1}/streams/stream${lm} 
out=${model}-adapt-bg/def-4/adaptedby-${model1}/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode-${model1}/dat.dat
base/bin/LPlex -C lib/cfgs/hlm.cfg -s $outStream -u -t lms/${lm} $out 
done
done
done
done


for show in $(seq 101 212)
do
for model in   grph-hybrid #plp grph-plp tandem grph-tandem hybrid
do
inStream=${model}-bg/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode/streams
out=${model}-bg/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode
python computeWeightsShow.py --in $inStream --out $out >> cmds.txt
done
done

for show in $(seq 101 212)
do
for model in  plp  tandem  #grph-plp grph-tandem
do
for model1 in  hybrid grph-hybrid #grph-plp grph-tandem tandem plp
do
inStream=${model}-adapt-bg/def-4/adaptedby-${model1}/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode-${model1}/streams
out=${model}-adapt-bg/def-4/adaptedby-${model1}/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode-${model1}
python computeWeightsShow.py --in $inStream --out $out >> cmds.txt
done
done
done


for show in $(seq 101 212)
do
for model in  plp  
do
for model1 in  plp
do
for lm in lm1 lm2 lm3 lm4 lm5
do
outStream=${model}-adapt-bg/def-4/adaptedby-${model1}/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode-${model1}/streams/stream${lm} 
out=${model}-adapt-bg/def-4/adaptedby-${model1}/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode-${model1}/dat.dat
base/bin/LPlex -C lib/cfgs/hlm.cfg -s $outStream -u -t lms/${lm} $out 
done
done
done
done


#run cmds.txt





for show in $(seq 101 212)
do
for model in   grph-hybrid #plp grph-plp tandem grph-tandem hybrid
do	
echo $model $show $lmscale 
lmint=${model}-bg/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode/lm_int
lat=${model}-bg
./scripts/lmrescoreExt.sh -LMMODEL ${model} -OUTPASS lmrescore YTBElect_YTB${show}-XXXXXXXX-XXXXXX lattices decode $lmint $lat TRUE 
done
done
done


for show in $(seq 101 212)
do
for model in  plp  tandem  #grph-plp grph-tandem
do
for model1 in  hybrid grph-hybrid #grph-plp grph-tandem tandem plp
do	
echo $model $show $lmscale 
lmint=${model}-adapt-bg/def-4/adaptedby-${model1}/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode-${model1}/lm_int
lat=${model}-adapt-bg/def-4/adaptedby-${model1}
./scripts/lmrescoreExt2.sh -LMMODEL ${model} -OUTPASS lmrescore YTBElect_YTB${show}-XXXXXXXX-XXXXXX $lat decode-${model1} $lmint $lat TRUE 
done
done
done


for show in $(seq 101 212)
do
for model in  plp
do
for model1 in  plp
do	
echo $model $show $lmscale 
lmint=${model}-adapt-bg/def-4/adaptedby-${model1}/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode-${model1}/lm_int
lat=${model}-adapt-bg/def-4/adaptedby-${model1}
./scripts/lmrescoreExt2.sh -LMMODEL ${model} -OUTPASS lmrescore YTBElect_YTB${show}-XXXXXXXX-XXXXXX $lat decode-${model1} $lmint $lat TRUE 
done
done
done

#########################################################################################
# CN Rescore 
#########################################################################################
for model in  plp  tandem  #grph-plp grph-tandem
do
for model1 in  hybrid grph-hybrid #grph-plp grph-tandem tandem plp
do
for show in $(seq 101 212)
do
./scripts/cnrescoreExt.sh -LMMODEL $model YTBElect_YTB${show}-XXXXXXXX-XXXXXX ${model}-adapt-bg/def-4/adaptedby-${model1} lmrescore ${model}-adapt-bg/def-4/adaptedby-${model1}
done
done
done

for model in  plp  
do
for model1 in  plp
do
for show in $(seq 101 212)
do
./scripts/cnrescoreExt.sh -LMMODEL $model YTBElect_YTB${show}-XXXXXXXX-XXXXXX ${model}-adapt-bg/def-4/adaptedby-${model1} lmrescore ${model}-adapt-bg/def-4/adaptedby-${model1}
done
done
done

for model in   grph-hybrid #plp grph-plp tandem grph-tandem hybrid
do
for show in $(seq 101 212)
do
./scripts/cnrescoreExt.sh -LMMODEL $model YTBElect_YTB${show}-XXXXXXXX-XXXXXX ${model}-bg lmrescore ${model}-bg
done
done
done

#####################################################
#mapping
#####################################################

for model in  plp  tandem  #grph-plp grph-tandem
do
for model1 in  hybrid grph-hybrid #grph-plp grph-tandem tandem plp
do
for show in $(seq 101 212)
do
dir=${model}-adapt-bg/def-4/adaptedby-${model1}/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/lmrescore_cn
base/conftools/smoothtree-mlf.pl lib/trees/${model}-bg_decode_cn.tree ${dir}/rescore.mlf >> ${dir}/rescore-tree.mlf
done
done
done

for model in  plp 
do
for model1 in plp
do
for show in $(seq 101 212)
do
dir=${model}-adapt-bg/def-4/adaptedby-${model1}/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/lmrescore_cn
base/conftools/smoothtree-mlf.pl lib/trees/${model}-bg_decode_cn.tree ${dir}/rescore.mlf >> ${dir}/rescore-tree.mlf
done
done
done

for show in $(seq 101 212)
do
for model in   grph-hybrid #plp grph-plp tandem grph-tandem hybrid
do
dir=${model}-bg/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/lmrescore_cn
base/conftools/smoothtree-mlf.pl lib/trees/${model}-bg_decode_cn.tree ${dir}/rescore.mlf >> ${dir}/rescore-tree.mlf
done
done



##########################
#CN ROVER Mapping
##########################
#('tandem-grph-hybrid', {'scn': '0.4', 'tim': '0.5', 'score': ' 9.8', 'cnc': '  0.264 ', 'model': 'hybrid', 'alp': '0.4'})
#('tandem-grph-tandem', {'scn': '0.4', 'tim': '0.5', 'score': ' 9.9', 'cnc': '  0.258 ', 'model': 'hybrid', 'alp': '0.4'})
#('tandem-hybrid', {'scn': '0.7', 'tim': '0.5', 'score': ' 9.9', 'cnc': '  0.272 ', 'model': 'grph-hybrid', 'alp': '0.4'})
#('tandem-grph-plp', {'scn': '0.7', 'tim': '0.5', 'score': ' 9.9', 'cnc': '  0.259 ', 'model': 'hybrid', 'alp': '0.4'})
for model1 in  plp  grph-plp grph-tandem 
do
for model2 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model3 in  hybrid grph-hybrid
do
for ta in 0.5
do
for alpha in  0.3 0.5 0.6 0.8
do
for none in  0.2 0.4 0.7 0.9
do
file1=${model1}-adapt-bg/def-4/adaptedby-${model2}
file2=${model3}-bg/
d1=lmrescore_cn
d2=lmrescore_cn
echo $alpha $none $ta ${model1}-${model2} ${model3} >> cnrover.txt
echo $alpha $none $ta ${model1}-${model2} ${model3} 
for show in $(seq 101 212)
do
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2 --show /YTBElect_YTB${show}-XXXXXXXX-XXXXXX/ --out cnrover
done
./scripts/score.sh cnrover YTBEeval lmrescore_cn >> cnrover.txt
done
done
done
done
done
done


for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model2 in  hybrid grph-hybrid
do
for ta in 0.5
do
for alpha in  0.3 0.5 0.6 0.8
do
for none in  0.2 0.4 0.7 0.9
do
file1=${model1}-bg/
file2=${model2}-bg/
d1=lmrescore_cn
d2=lmrescore_cn
echo $alpha $none $ta ${model1} ${model2} >> cnrover.txt
echo $alpha $none $ta ${model1} ${model2} 
for show in $(seq 101 212)
do
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2 --show /YTBElect_YTB${show}-XXXXXXXX-XXXXXX/
done
./scripts/score.sh cnrover YTBEeval decode >> cnrover.txt
done
done
done
done
done
done


for model1 in  tandem
do
for model2 in grph-hybrid
do
for model3 in grph-hybrid
do
for ta in 0.5
do
for alpha in  0.8
do
for none in  0.2
do
file1=${model1}-adapt-bg/def-4/adaptedby-${model2}
file2=${model3}-bg/
d1=lmrescore_cn
d2=lmrescore_cn
echo $alpha $none $ta ${model1}-${model2} ${model3} >> cnrover2.txt
echo $alpha $none $ta ${model1}-${model2} ${model3} 
for show in $(seq 101 212)
do
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2 --show /YTBElect_YTB${show}-XXXXXXXX-XXXXXX/ --out sys1
done
./scripts/score.sh sys1 YTBEeval lmrescore_cn >> cnrover2.txt
done
done
done
done
done
done


for model1 in  tandem
do
for model2 in hybrid###########################################
# determinise the lattices
###########################################
for show in $(seq 101 212)
do
for model in  plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
./scripts/mergelatsExt.sh -BEAMPRUNE 4000.0 -SYS ${model} YTBElect_YTB${show}-XXXXXXXX-XXXXXX lattices decode ${model}-bg
done
done



for show in $(seq 101 212)
do
for PRUNE in 4000.0
do
for model in  grph-plp tandem grph-tandem plp hybrid grph-hybrid
do
./scripts/hmmrescoreExt.sh -PRUNE ${PRUNE} YTBElect_YTB${show}-XXXXXXXX-XXXXXX ${model}-bg merge ${model}-bg ${model}
done
done
done

for PRUNE in 4000.0 
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
	echo -------------------------------------------------- >> eval.txt
	echo ${model} ${PRUNE} >> eval.txt
	./scripts/score.sh ${model}-bg YTBEeval decode >> eval.txt
done
done


#################################################################################################################
#2) Using the 1-best hypothesis generated from the bigram lattice, produce \cas- caded CMLLR and MLLR transforms.
#################################################################################################################
#Rescore determinized lattices with original and other acoustic models for cross adaptation
for show in $(seq 101 212)
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
./scripts/hmmrescore.sh YTBElect_YTB${show}-XXXXXXXX-XXXXXX ${model}-bg merge ${model1}-bg/${model}-merge-bg ${model1}
done
done
done

#################################################################################################################
#2) Using the 1-best hypothesis generated from the bigram lattice, produce \cas- caded CMLLR and MLLR transforms.
#################################################################################################################
#Rescore determinized lattices with original and other acoustic models for cross adaptation
for show in $(seq 101 212)
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
./scripts/hmmrescore.sh YTBElect_YTB${show}-XXXXXXXX-XXXXXX ${model}-bg merge ${model1}-bg/${model}-merge-bg ${model1}
done
done
done

###########################################
#Adapt and cross adapt - hypothesis obtained from rescoring model lattices using model 1
###########################################
#In progress
for show in $(seq 101 212)
do
for model in  plp grph-plp tandem grph-tandem
do
for model1 in  grph-plp grph-tandem tandem   plp hybrid grph-hybrid
do
./scripts/hmmadaptExt.sh -OUTPASS adapt-${model1} YTBElect_YTB${show}-XXXXXXXX-XXXXXX ${model1}-bg/${model}-merge-bg decode ${model}-adapt-bg/def-4/adaptedby-${model1} ${model}
done
done
done
###########################################
#These transforms can then be used to rescore lattices:
###########################################

for show in $(seq 101 212)
do
for model in  plp grph-plp tandem grph-tandem 
do
for model1 in  grph-plp tandem grph-tandem  plp hybrid grph-hybrid
do
./scripts/hmmrescoreExt.sh -PRUNE 4000.0 -ADAPT ${model}-adapt-bg/def-4/adaptedby-${model1} adapt-${model1} -OUTPASS decode-${model1} YTBElect_YTB${show}-XXXXXXXX-XXXXXX ${model}-bg merge ${model}-adapt-bg/def-4/adaptedby-${model1} ${model}
done
done
done

#scoring
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
echo -------------------------------------------------- >> eval.txt
echo $model $model1 $pruning >> eval.txt
./scripts/score.sh ${model}-adapt-bg/def-4/adaptedby-${model1} YTBEeval decode-${model1} >> eval.txt
done
done

###########################################
#Language Modeling
###########################################
#Produce .dat file
for show in $(seq 101 212)
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
mkdir ${model}-bg/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode/streams
done
done

for show in $(seq 101 212)
do
for model in  plp grph-plp tandem grph-tandem 
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
mkdir ${model}-adapt-bg/def-4/adaptedby-${model1}/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode-${model1}/streams
done
done
done

for show in $(seq 101 212)
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
in=${model}-bg/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode/rescore.mlf
out=${model}-bg/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode/dat.dat
python processFileToDat.py --in $in --out $out
done
done

for show in $(seq 101 212)
do
for model in  plp grph-plp tandem grph-tandem 
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
in=${model}-adapt-bg/def-4/adaptedby-${model1}/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode-${model1}/rescore.mlf
out=${model}-adapt-bg/def-4/adaptedby-${model1}/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode-${model1}/dat.dat
python processFileToDat.py --in $in --out $out
done
done
done

for show in $(seq 101 212)
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for lm in lm1 lm2 lm3 lm4 lm5
do
outStream=${model}-bg/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode/streams/stream${lm} 
out=${model}-bg/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode/dat.dat
base/bin/LPlex -C lib/cfgs/hlm.cfg -s $outStream -u -t lms/${lm} $out 
done
done
done

for show in $(seq 101 212)
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for lm in lm1 lm2 lm3 lm4 lm5
do
outStream=${model}-adapt-bg/def-4/adaptedby-${model1}/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode-${model1}/streams/stream${lm} 
out=${model}-adapt-bg/def-4/adaptedby-${model1}/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode-${model1}/dat.dat
base/bin/LPlex -C lib/cfgs/hlm.cfg -s $outStream -u -t lms/${lm} $out 
done
done
done
done

for show in $(seq 101 212)
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
inStream=${model}-bg/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode/streams
out=${model}-bg/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode
python computeWeightsShow.py --in $inStream --out $out >> cmds.txt
done
done

for show in $(seq 101 212)
do
for model in  plp grph-plp tandem grph-tandem 
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
inStream=${model}-adapt-bg/def-4/adaptedby-${model1}/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode-${model1}/streams
out=${model}-adapt-bg/def-4/adaptedby-${model1}/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode-${model1}
python computeWeightsShow.py --in $inStream --out $out >> cmds.txt
done
done
done

#run cmds.txt

for lmscale in 6.0 12.0 16. 18.0 24.0 36.0
do
for show in $(seq 101 212)
do
for model in  grph-plp tandem grph-tandem hybrid grph-hybrid
do	
echo $model $show $lmscale
lmint=${model}-bg/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode/lm_int
lat=${model}-bg
./scripts/lmrescore.sh -LMSCALE ${lmscale} -OUTPASS rescore-${lmscale} YTBElect_YTB${show}-XXXXXXXX-XXXXXX lattices decode $lmint $lat TRUE
done
done
done

for lmscale in  6.0 18.0 24.0
do
for show in $(seq 101 212)
do
for model in  plp grph-plp tandem grph-tandem
do
for model1 in plp grph-plp tandem grph-tandem hybrid grph-hybrid
do	
echo $model $show $lmscale 
lmint=${model}-adapt-bg/def-4/adaptedby-${model1}/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode-${model1}/lm_int
lat=${model}-adapt-bg/def-4/adaptedby-${model1}
./scripts/lmrescore.sh -LMSCALE ${lmscale} -OUTPASS rescore-${lmscale} YTBElect_YTB${show}-XXXXXXXX-XXXXXX $lat decode-${model1} $lmint $lat TRUE 
done
done
done
done


for lmscale in 6.0 12.0 16. 18.0 24.0 36.0
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
echo -------------------------------------------------- >> lmrescoreYTB.txt
echo ${model}  ${lmscale} >> lmrescoreYTB.txt
./scripts/score.sh ${model}-bg YTBEeval rescore-${lmscale}  >> lmrescoreYTB.txt
done
done

for lmscale in 6.0 18.0 24.0
do
for model in  plp grph-plp tandem grph-tandem 
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
echo -------------------------------------------------- >> lmrescoreYTB.txt
echo ${model} ${model1}  ${lmscale} >> lmrescoreYTB.txt
./scripts/score.sh ${model}-adapt-bg/def-4/adaptedby-${model1} YTBEeval rescore-${lmscale}  >> lmrescoreYTB.txt
done
done
done

for show in $(seq 101 212)
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do	
echo $model $show $lmscale 
lmint=${model}-bg/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode/lm_int
lat=${model}-bg
./scripts/lmrescoreExt.sh -LMMODEL ${model} -OUTPASS lmrescore YTBElect_YTB${show}-XXXXXXXX-XXXXXX lattices decode $lmint $lat TRUE 
done
done
done


for show in $(seq 101 212)
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do	
echo $model $show $lmscale 
lmint=${model}-adapt-bg/def-4/adaptedby-${model1}/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/decode-${model1}/lm_int
lat=${model}-adapt-bg/def-4/adaptedby-${model1}
./scripts/lmrescoreExt2.sh -LMMODEL ${model} -OUTPASS lmrescore YTBElect_YTB${show}-XXXXXXXX-XXXXXX $lat decode-${model1} $lmint $lat TRUE 
done
done
done


for model in  grph-plp tandem grph-tandem hybrid grph-hybrid
do
echo -------------------------------------------------- >> lmrescoreYTB.txt
echo ${model} >> lmrescoreYTB.txt
./scripts/score.sh ${model}-bg YTBEeval lmrescore  >> lmrescoreYTB.txt
done



for model in  plp grph-plp tandem grph-tandem 
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
echo -------------------------------------------------- >> lmrescoreYTB.txt
echo ${model} ${model1}  >> lmrescoreYTB.txt
./scripts/score.sh ${model}-adapt-bg/def-4/adaptedby-${model1} YTBEeval lmrescore  >> lmrescoreYTB.txt
done
done
#########################################################################################
# CN Rescore 
#########################################################################################
for model in  plp grph-plp tandem grph-tandem
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for show in $(seq 101 212)
do
./scripts/cnrescoreExt.sh -LMMODEL $model YTBElect_YTB${show}-XXXXXXXX-XXXXXX ${model}-adapt-bg/def-4/adaptedby-${model1} lmrescore ${model}-adapt-bg/def-4/adaptedby-${model1}
done
done
done

for model in  plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for show in $(seq 101 212)
do
./scripts/cnrescoreExt.sh -LMMODEL $model YTBElect_YTB${show}-XXXXXXXX-XXXXXX ${model}-bg lmrescore ${model}-bg
done
done
done

#####################################################
#mapping
#####################################################

for model in  plp grph-plp tandem grph-tandem
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for show in $(seq 101 212)
do
dir=${model}-adapt-bg/def-4/adaptedby-${model1}/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/lmrescore_cn
base/conftools/smoothtree-mlf.pl lib/trees/${model}-bg_decode_cn.tree ${dir}/rescore.mlf >> ${dir}/rescore-tree.mlf
done
done
done
for show in $(seq 101 212)
do
for model in  plp grph-plp tandem grph-tandem   hybrid grph-hybrid
do
dir=${model}-bg/YTBElect_YTB${show}-XXXXXXXX-XXXXXX/lmrescore_cn
base/conftools/smoothtree-mlf.pl lib/trees/${model}-bg_decode_cn.tree ${dir}/rescore.mlf >> ${dir}/rescore-tree.mlf
done
done

#Scoring with map tree

#scoring
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
echo -------------------------------------------------- >> eval_cn_lm_map.txt
echo ${model}  >> eval_cn_lm_map.txt
./scripts/score.sh -CONFTREE lib/trees/${model}-bg_decode_cn.tree ${model}-bg YTBEeval lmrescore_cn  >> eval_cn_lm_map.txt
done


for model in  plp grph-plp tandem grph-tandem 
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
echo -------------------------------------------------- >> eval_cn_lm_map.txt
echo $model $model1 >> eval_cn_lm_map.txt
./scripts/score.sh -CONFTREE lib/trees/${model}-bg_decode_cn.tree ${model}-adapt-bg/def-4/adaptedby-${model1} YTBEeval lmrescore_cn >> eval_cn_lm_map.txt
done
done

##########################
#CN ROVER Mapping
##########################
#('tandem-grph-hybrid', {'scn': '0.4', 'tim': '0.5', 'score': ' 9.8', 'cnc': '  0.264 ', 'model': 'hybrid', 'alp': '0.4'})
#('tandem-grph-tandem', {'scn': '0.4', 'tim': '0.5', 'score': ' 9.9', 'cnc': '  0.258 ', 'model': 'hybrid', 'alp': '0.4'})
#('tandem-hybrid', {'scn': '0.7', 'tim': '0.5', 'score': ' 9.9', 'cnc': '  0.272 ', 'model': 'grph-hybrid', 'alp': '0.4'})
#('tandem-grph-plp', {'scn': '0.7', 'tim': '0.5', 'score': ' 9.9', 'cnc': '  0.259 ', 'model': 'hybrid', 'alp': '0.4'})
for model1 in  plp  grph-plp grph-tandem 
do
for model2 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model3 in  hybrid grph-hybrid
do
for ta in 0.5
do
for alpha in  0.3 0.5 0.6 0.8
do
for none in  0.2 0.4 0.7 0.9
do
file1=${model1}-adapt-bg/def-4/adaptedby-${model2}
file2=${model3}-bg/
d1=lmrescore_cn
d2=lmrescore_cn
echo $alpha $none $ta ${model1}-${model2} ${model3} >> cnrover.txt
echo $alpha $none $ta ${model1}-${model2} ${model3} 
for show in $(seq 101 212)
do
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2 --show /YTBElect_YTB${show}-XXXXXXXX-XXXXXX/ --out cnrover
done
./scripts/score.sh cnrover YTBEeval lmrescore_cn >> cnrover.txt
done
done
done
done
done
done


for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model2 in  hybrid grph-hybrid
do
for ta in 0.5
do
for alpha in  0.3 0.5 0.6 0.8
do
for none in  0.2 0.4 0.7 0.9
do
file1=${model1}-bg/
file2=${model2}-bg/
d1=lmrescore_cn
d2=lmrescore_cn
echo $alpha $none $ta ${model1} ${model2} >> cnrover.txt
echo $alpha $none $ta ${model1} ${model2} 
for show in $(seq 101 212)
do
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2 --show /YTBElect_YTB${show}-XXXXXXXX-XXXXXX/
done
./scripts/score.sh cnrover YTBEeval decode >> cnrover.txt
done
done
done
done
done
done


for model1 in  tandem
do
for model2 in grph-hybrid
do
for model3 in grph-hybrid
do
for ta in 0.5
do
for alpha in  0.8
do
for none in  0.2
do
file1=${model1}-adapt-bg/def-4/adaptedby-${model2}
file2=${model3}-bg/
d1=lmrescore_cn
d2=lmrescore_cn
echo $alpha $none $ta ${model1}-${model2} ${model3} >> cnrover2.txt
echo $alpha $none $ta ${model1}-${model2} ${model3} 
for show in $(seq 101 212)
do
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2 --show /YTBElect_YTB${show}-XXXXXXXX-XXXXXX/ --out sys1
done
./scripts/score.sh sys1 YTBEeval lmrescore_cn >> cnrover2.txt
done
done
done
done
done
done


for model1 in  tandem
do
for model2 in hybrid
do
for model3 in grph-hybrid
do
for ta in 0.5
do
for alpha in 0.8
do
for none in  0.2
do
file1=${model1}-adapt-bg/def-4/adaptedby-${model2}
file2=${model3}-bg/
d1=lmrescore_cn/rescore-tree.mlf
d2=lmrescore_cn/rescore-tree.mlf
echo $alpha $none $ta ${model1}-${model2} ${model3} #>> cnrover2.txt
echo $alpha $none $ta ${model1}-${model2} ${model3} 
for show in $(seq 101 212)
do
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2 --show /YTBElect_YTB${show}-XXXXXXXX-XXXXXX/ --out sys2
done
./scripts/score.sh sys2 YTBEeval lmrescore_cn #>> cnrover2.txt
done
done
done
done
done
done


for model1 in  plp
do
for model2 in grph-hybrid
do
for model3 in grph-hybrid
do
for ta in 0.5
do
for alpha in 0.8
do
for none in  0.2
do
file1=${model1}-adapt-bg/def-4/adaptedby-${model2}
file2=${model3}-bg/
d1=lmrescore_cn/rescore-tree.mlf
d2=lmrescore_cn/rescore-tree.mlf
echo $alpha $none $ta ${model1}-${model2} ${model3} #>> cnrover2.txt
echo $alpha $none $ta ${model1}-${model2} ${model3} 
for show in $(seq 101 212)
do
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2 --show /YTBElect_YTB${show}-XXXXXXXX-XXXXXX/ --out sys6
done
./scripts/score.sh sys6 YTBEeval lmrescore_cn #>> cnrover2.txt
done
done
done
done
done
done



#TODO
for ta in 0.5
do
for alpha in  0.5
do
for none in  0.2
do
file1=sys1/
file2=sys6/
d1=lmrescore_cn/rescore.mlf
d2=lmrescore_cn/rescore.mlf
echo $alpha $none $ta ${model1}-${model2} ${model3} >> cnrover4.txt
echo $alpha $none $ta ${model1}-${model2} ${model3} 
for show in $(seq 101 212)
do
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2 --show /YTBElect_YTB${show}-XXXXXXXX-XXXXXX/ --out sys5
done
./scripts/score.sh sys5 YTBEeval lmrescore_cn >> cnrover4.txt
done
done
done


for model1 in  plp  grph-plp tandem grph-tandem
do
for model2 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for ta in 0.5
do
for alpha in  0.3 0.5 0.6 0.8
do
for none in  0.2 0.4 0.7 0.9
do
file1=sys1/
file2=${model1}-adapt-bg/def-4/adaptedby-${model2}
d1=lmrescore_cn/rescore.mlf
d2=lmrescore_cn/rescore-tree.mlf
echo $alpha $none $ta ${model1}-${model2} sys1 >> cnrover3.txt
echo $alpha $none $ta ${model1}-${model2} sys1
for show in $(seq 101 212)
do
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2 --show /YTBElect_YTB${show}-XXXXXXXX-XXXXXX/ --out sys3
done
./scripts/score.sh sys3 YTBEeval lmrescore_cn >> cnrover3.txt
done
done
done
done
done

for model1 in  plp  
do
for model2 in plp  
do
for ta in 0.5
do
for alpha in  0.6
do
for none in  0.2
do
file1=sys1/
file2=${model1}-adapt-bg/def-4/adaptedby-${model2}
d1=lmrescore_cn/rescore.mlf
d2=lmrescore_cn/rescore-tree.mlf
echo $alpha $none $ta ${model1}-${model2} sys1 #>> cnrover5.txt
echo $alpha $none $ta ${model1}-${model2} sys1 
for show in $(seq 101 212)
do
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2 --show /YTBElect_YTB${show}-XXXXXXXX-XXXXXX/ --out sys4
done
./scripts/score.sh sys4 YTBEeval lmrescore_cn #>> cnrover5.txt
done
done
done

for model1 in  grph-tandem  
do
for model2 in hybrid  
do
for ta in 0.5
do
for alpha in  0.6
do
for none in  0.2
do
file1=sys1/
file2=${model1}-adapt-bg/def-4/adaptedby-${model2}
d1=lmrescore_cn/rescore.mlf
d2=lmrescore_cn/rescore-tree.mlf
echo $alpha $none $ta ${model1}-${model2} sys1 #>> cnrover5.txt
echo $alpha $none $ta ${model1}-${model2} sys1 
for show in $(seq 101 212)
do
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2 --show /YTBElect_YTB${show}-XXXXXXXX-XXXXXX/ --out sys7
done
./scripts/score.sh sys7 YTBEeval lmrescore_cn #>> cnrover5.txt
done
done
done



for model1 in  plp  grph-plp tandem grph-tandem
do
for model2 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for ta in 0.5
do
for alpha in  0.3 0.5 0.6 0.8
do
for none in  0.2 0.4 0.7 0.9
do
file1=sys6/
file2=${model1}-adapt-bg/def-4/adaptedby-${model2}
d1=lmrescore_cn/rescore.mlf
d2=lmrescore_cn/rescore-tree.mlf
echo $alpha $none $ta ${model1}-${model2} sys1 >> cnrover6.txt
echo $alpha $none $ta ${model1}-${model2} sys1 
for show in $(seq 101 212)
do                                                                                      
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2 --show /YTBElect_YTB${show}-XXXXXXXX-XXXXXX/ --out sys7
done
./scripts/score.sh sys7 YTBEeval lmrescore_cn >> cnrover6.txt
done
done
done
done
done


for model1 in  plp  grph-plp tandem grph-tandem
do
for model2 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for ta in 0.5
do
for alpha in  0.3 0.5 0.6 0.8
do
for none in  0.2 0.4 0.7 0.9
do
file1=sys7/
file2=${model1}-adapt-bg/def-4/adaptedby-${model2}
d1=lmrescore_cn/rescore.mlf
d2=lmrescore_cn/rescore-tree.mlf
echo $alpha $none $ta ${model1}-${model2} sys1 >> cnrover7.txt
echo $alpha $none $ta ${model1}-${model2} sys1 
for show in $(seq 101 212)
do
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2 --show /YTBElect_YTB${show}-XXXXXXXX-XXXXXX/ --out sys8
done
./scripts/score.sh sys8 YTBEeval lmrescore_cn >> cnrover7.txt
done
done
done
done
done


for ta in 0.5
do
for alpha in  0.3 0.5 0.6 0.8
do
for none in  0.2 0.4 0.7 0.9
do
file1=sys7/
file2=sys4/
d1=lmrescore_cn/rescore.mlf
d2=lmrescore_cn/rescore.mlf
echo $alpha $none $ta ${model1}-${model2} ${model3} >> cnrover5.txt
echo $alpha $none $ta ${model1}-${model2} ${model3} 
for show in $(seq 101 212)
do
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2 --show /YTBElect_YTB${show}-XXXXXXXX-XXXXXX/ --out sys9
done
./scripts/score.sh sys9 YTBEeval lmrescore_cn >> cnrover5.txt
done
done
done
do
for model3 in grph-hybrid
do
for ta in 0.5
do
for alpha in 0.8
do
for none in  0.2
do
file1=${model1}-adapt-bg/def-4/adaptedby-${model2}
file2=${model3}-bg/
d1=lmrescore_cn/rescore-tree.mlf
d2=lmrescore_cn/rescore-tree.mlf
echo $alpha $none $ta ${model1}-${model2} ${model3} #>> cnrover2.txt
echo $alpha $none $ta ${model1}-${model2} ${model3} 
for show in $(seq 101 212)
do
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2 --show /YTBElect_YTB${show}-XXXXXXXX-XXXXXX/ --out sys2
done
./scripts/score.sh sys2 YTBEeval lmrescore_cn #>> cnrover2.txt
done
done
done
done
done
done


for model1 in  plp
do
for model2 in grph-hybrid
do
for model3 in grph-hybrid
do
for ta in 0.5
do
for alpha in 0.8
do
for none in  0.2
do
file1=${model1}-adapt-bg/def-4/adaptedby-${model2}
file2=${model3}-bg/
d1=lmrescore_cn/rescore-tree.mlf
d2=lmrescore_cn/rescore-tree.mlf
echo $alpha $none $ta ${model1}-${model2} ${model3} #>> cnrover2.txt
echo $alpha $none $ta ${model1}-${model2} ${model3} 
for show in $(seq 101 212)
do
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2 --show /YTBElect_YTB${show}-XXXXXXXX-XXXXXX/ --out sys6
done
./scripts/score.sh sys6 YTBEeval lmrescore_cn #>> cnrover2.txt
done
done
done
done
done
done



#TODO
for ta in 0.5
do
for alpha in  0.5
do
for none in  0.2
do
file1=sys1/
file2=sys6/
d1=lmrescore_cn/rescore.mlf
d2=lmrescore_cn/rescore.mlf
echo $alpha $none $ta ${model1}-${model2} ${model3} >> cnrover4.txt
echo $alpha $none $ta ${model1}-${model2} ${model3} 
for show in $(seq 101 212)
do
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2 --show /YTBElect_YTB${show}-XXXXXXXX-XXXXXX/ --out sys5
done
./scripts/score.sh sys5 YTBEeval lmrescore_cn >> cnrover4.txt
done
done
done


for model1 in  plp  grph-plp tandem grph-tandem
do
for model2 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for ta in 0.5
do
for alpha in  0.3 0.5 0.6 0.8
do
for none in  0.2 0.4 0.7 0.9
do
file1=sys1/
file2=${model1}-adapt-bg/def-4/adaptedby-${model2}
d1=lmrescore_cn/rescore.mlf
d2=lmrescore_cn/rescore-tree.mlf
echo $alpha $none $ta ${model1}-${model2} sys1 >> cnrover3.txt
echo $alpha $none $ta ${model1}-${model2} sys1
for show in $(seq 101 212)
do
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2 --show /YTBElect_YTB${show}-XXXXXXXX-XXXXXX/ --out sys3
done
./scripts/score.sh sys3 YTBEeval lmrescore_cn >> cnrover3.txt
done
done
done
done
done

for model1 in  plp  
do
for model2 in plp  
do
for ta in 0.5
do
for alpha in  0.6
do
for none in  0.2
do
file1=sys1/
file2=${model1}-adapt-bg/def-4/adaptedby-${model2}
d1=lmrescore_cn/rescore.mlf
d2=lmrescore_cn/rescore-tree.mlf
echo $alpha $none $ta ${model1}-${model2} sys1 #>> cnrover5.txt
echo $alpha $none $ta ${model1}-${model2} sys1 
for show in $(seq 101 212)
do
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2 --show /YTBElect_YTB${show}-XXXXXXXX-XXXXXX/ --out sys4
done
./scripts/score.sh sys4 YTBEeval lmrescore_cn #>> cnrover5.txt
done
done
done

for model1 in  grph-tandem  
do
for model2 in hybrid  
do
for ta in 0.5
do
for alpha in  0.6
do
for none in  0.2
do
file1=sys1/
file2=${model1}-adapt-bg/def-4/adaptedby-${model2}
d1=lmrescore_cn/rescore.mlf
d2=lmrescore_cn/rescore-tree.mlf
echo $alpha $none $ta ${model1}-${model2} sys1 #>> cnrover5.txt
echo $alpha $none $ta ${model1}-${model2} sys1 
for show in $(seq 101 212)
do
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2 --show /YTBElect_YTB${show}-XXXXXXXX-XXXXXX/ --out sys7
done
./scripts/score.sh sys7 YTBEeval lmrescore_cn #>> cnrover5.txt
done
done
done



for model1 in  plp  grph-plp tandem grph-tandem
do
for model2 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for ta in 0.5
do
for alpha in  0.3 0.5 0.6 0.8
do
for none in  0.2 0.4 0.7 0.9
do
file1=sys6/
file2=${model1}-adapt-bg/def-4/adaptedby-${model2}
d1=lmrescore_cn/rescore.mlf
d2=lmrescore_cn/rescore-tree.mlf
echo $alpha $none $ta ${model1}-${model2} sys1 >> cnrover6.txt
echo $alpha $none $ta ${model1}-${model2} sys1 
for show in $(seq 101 212)
do                                                                                      
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2 --show /YTBElect_YTB${show}-XXXXXXXX-XXXXXX/ --out sys7
done
./scripts/score.sh sys7 YTBEeval lmrescore_cn >> cnrover6.txt
done
done
done
done
done


for model1 in  plp  grph-plp tandem grph-tandem
do
for model2 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
for ta in 0.5
do
for alpha in  0.3 0.5 0.6 0.8
do
for none in  0.2 0.4 0.7 0.9
do
file1=sys7/
file2=${model1}-adapt-bg/def-4/adaptedby-${model2}
d1=lmrescore_cn/rescore.mlf
d2=lmrescore_cn/rescore-tree.mlf
echo $alpha $none $ta ${model1}-${model2} sys1 >> cnrover7.txt
echo $alpha $none $ta ${model1}-${model2} sys1 
for show in $(seq 101 212)
do
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2 --show /YTBElect_YTB${show}-XXXXXXXX-XXXXXX/ --out sys8
done
./scripts/score.sh sys8 YTBEeval lmrescore_cn >> cnrover7.txt
done
done
done
done
done


for ta in 0.5
do
for alpha in  0.3 0.5 0.6 0.8
do
for none in  0.2 0.4 0.7 0.9
do
file1=sys7/
file2=sys4/
d1=lmrescore_cn/rescore.mlf
d2=lmrescore_cn/rescore.mlf
echo $alpha $none $ta ${model1}-${model2} ${model3} >> cnrover5.txt
echo $alpha $none $ta ${model1}-${model2} ${model3} 
for show in $(seq 101 212)
do
python minEditAlign_cn.py --alpha $alpha --none $none --ta $ta --file1 $file1 --file2 $file2 --d1 $d1 --d2 $d2 --show /YTBElect_YTB${show}-XXXXXXXX-XXXXXX/ --out sys9
done
./scripts/score.sh sys9 YTBEeval lmrescore_cn >> cnrover5.txt
done
done
done

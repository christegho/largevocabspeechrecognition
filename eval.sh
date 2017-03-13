

###########################################
# determinise the lattices
###########################################
for show in 01 02 03 04 05 06 07 08 09 10
do
for model in  grph-plp tandem grph-tandem hybrid grph-hybrid
do
./scripts/1bestlatsExt.sh -SYS ${model} YTBElect_YTB0${show}-XXXXXXXX-XXXXXX lattices decode ${model}-bg
done
done

for show in 01 02 03 04 05 06 07 08 09 10
do
for model in  plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
./scripts/mergelatsExt.sh -SYS ${model} YTBElect_YTB0${show}-XXXXXXXX-XXXXXX lattices decode ${model}-bg
./scripts/mergelatsExt.sh -BEAMPRUNE 4000.0 -SYS ${model} YTBElect_YTB0${show}-XXXXXXXX-XXXXXX lattices decode ${model}-bg/PR4000.0
done
done

#Rescore
for show in 01 02 03 04 05 06 07 08 09 10
do
for model in  grph-plp tandem grph-tandem plp hybrid grph-hybrid
do
./scripts/hmmrescore.sh YTBElect_YTB0${show}-XXXXXXXX-XXXXXX ${model}-bg merge ${model}-bg ${model}
done
done

for show in 01 02 03 04 05 06 07 08 09 10
do
for PRUNE in 4000.0
do
for model in  grph-plp tandem grph-tandem plp hybrid grph-hybrid
do
./scripts/hmmrescoreExt.sh -PRUNE ${PRUNE} YTBElect_YTB0${show}-XXXXXXXX-XXXXXX ${model}-bg merge ${model}-bg/PR${PRUNE} ${model}
done
done
done

#scoring
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
echo -------------------------------------------------- >> eval.txt
echo ${model} default >> eval.txt
./scripts/score.sh ${model}-bg YTBEdevsub decode  >> eval.txt
done

for PRUNE in 4000.0 
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
	echo -------------------------------------------------- >> eval.txt
	echo ${model} ${PRUNE} >> eval.txt
	./scripts/score.sh ${model}-bg/PR${PRUNE} YTBEdevsub decode >> eval.txt
done
done


#################################################################################################################
#2) Using the 1-best hypothesis generated from the bigram lattice, produce \cas- caded CMLLR and MLLR transforms.
#################################################################################################################
#Rescore determinized lattices with original and other acoustic models for cross adaptation
for show in 01 02 03 04 05 06 07 08 09 10
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
./scripts/hmmrescore.sh YTBElect_YTB0${show}-XXXXXXXX-XXXXXX ${model}-bg merge ${model1}-bg/${model}-merge-bg ${model1}
done
done
done
###########################################
#Adapt and cross adapt - hypothesis obtained from rescoring model lattices using model 1
###########################################

for show in 01 02 03 04 05 06 07 08 09 10
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model1 in  grph-plp grph-tandem tandem   plp hybrid grph-hybrid
do
./scripts/hmmadaptExt.sh -OUTPASS adapt-${model1} YTBElect_YTB0${show}-XXXXXXXX-XXXXXX ${model1}-bg/${model}-merge-bg decode ${model}-adapt-bg/def-4/adaptedby-${model1} ${model}
done
done
done
###########################################
#These transforms can then be used to rescore lattices:
###########################################

for show in 01 02 03 04 05 06 07 08 09 10
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model1 in  grph-plp tandem grph-tandem  plp hybrid grph-hybrid
do
./scripts/hmmrescoreExt.sh -PRUNE 4000.0 -ADAPT ${model}-adapt-bg/def-4/adaptedby-${model1} adapt-${model1} -OUTPASS decode-${model1} YTBElect_YTB0${show}-XXXXXXXX-XXXXXX ${model}-bg merge ${model}-adapt-bg/def-4/adaptedby-${model1} ${model}
done
done
done

#scoring
for pruning in def-4
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
echo -------------------------------------------------- >> eval.txt
echo $model $model1 $pruning >> eval.txt
./scripts/score.sh ${model}-adapt-bg/${pruning}/adaptedby-${model1} YTBEdevsub decode-${model1} >> eval.txt
done
done
done
###########################################
#Fine Tuning LM #DO NOT DO FOR TEST
###########################################
for lmscale in 6.0 17.0 21.0 27.0 33.0 39.0
do
for show in 01 02 03 04 05 06 07 08 09 10
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model1 in  grph-plp tandem grph-tandem  plp hybrid grph-hybrid
do
./scripts/hmmrescoreExt.sh -PRUNE 4000.0 -LMSCALE ${lmscale} -ADAPT ${model}-adapt-bg/def-4/adaptedby-${model1} adapt-${model1} -OUTPASS decode-${model1} YTBElect_YTB0${show}-XXXXXXXX-XXXXXX ${model}-bg merge ${model}-adapt-bg/def-4/adaptedby-${model1}/LM${lmscale} ${model}
done
done
done
done

for lmscale in 6.0 17.0 21.0 27.0 33.0 39.0
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model1 in  grph-plp tandem grph-tandem  plp hybrid grph-hybrid
do
./scripts/hmmrescoreExt.sh -PRUNE 4000.0 -LMSCALE ${lmscale} -ADAPT ${model}-adapt-bg/def-4/adaptedby-${model1} adapt-${model1} -OUTPASS decode-${model1} dev03_DEV001-20010117-XX2000 ${model}-bg merge ${model}-adapt-bg/def-4/adaptedby-${model1}/LM${lmscale} ${model}
done
done
done


for lmscale in 6.0 17.0 21.0 27.0 33.0 39.0
do
for show in 01 02 03 04 05 06 07 08 09 10
do
for PRUNE in 4000.0
do
for model in  grph-plp tandem grph-tandem plp hybrid grph-hybrid
do
./scripts/hmmrescoreExt.sh -PRUNE ${PRUNE} YTBElect_YTB0${show}-XXXXXXXX-XXXXXX ${model}-bg merge ${model}-bg/PR${PRUNE}/LM${lmscale} ${model}
done
done
done
done


for lmscale in 6.0 17.0 21.0 27.0 33.0 39.0
do
for PRUNE in 4000.0
do
for model in  grph-plp tandem grph-tandem plp hybrid grph-hybrid
do
./scripts/hmmrescoreExt.sh -PRUNE ${PRUNE} dev03_DEV001-20010117-XX2000 ${model}-bg merge ${model}-bg/PR${PRUNE}/LM${lmscale} ${model}
done
done
done

#scoring

for lmscale in 6.0 17.0 21.0 27.0 33.0 39.0
do
for show in 01 02 03 04 05 06 07 08 09 10
do
for PRUNE in 4000.0 
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
	echo -------------------------------------------------- >> evalLM.txt
	echo ${model} ${PRUNE} ${lmscale} >> evalLM.txt
	./scripts/score.sh ${model}-bg/PR${PRUNE}/LM${lmscale} YTBEdevsub decode >> evalLM.txt
done
done
done
done

for pruning in def-4
do
for lmscale in 6.0 17.0 21.0 27.0 33.0 39.0
do
for model in  plp grph-plp tandem grph-tandem 
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
echo -------------------------------------------------- >> evalLM.txt
echo $model $model1 $pruning ${lmscale} >> evalLM.txt
./scripts/score.sh ${model}-adapt-bg/${pruning}/adaptedby-${model1}/LM${lmscale} YTBEdevsub decode-${model1} >> evalLM.txt
done
done
done
done
done


for lmscale in 6.0 17.0 21.0 27.0 33.0 39.0
do
for PRUNE in 4000.0 
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
echo -------------------------------------------------- >> devLM.txt
echo ${model} ${PRUNE} ${lmscale} >> devLM.txt
./scripts/score.sh ${model}-bg/PR${PRUNE}/LM${lmscale} dev03sub decode >> devLM.txt
done
done
done

for pruning in def-4
do
for lmscale in  33.0 39.0 #6.0 17.0 21.0 27.0
do
for model in  plp grph-plp tandem grph-tandem
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
echo -------------------------------------------------- >> devLM.txt
echo $model $model1 $pruning ${lmscale} >> devLM.txt
./scripts/score.sh ${model}-adapt-bg/${pruning}/adaptedby-${model1}/LM${lmscale} dev03sub decode-${model1} >> devLM.txt
done
done
done
done

###########################################
#Language Modeling
###########################################
#Produce .dat file
for show in 01 02 03 04 05 06 07 08 09 10
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
mkdir ${model}-bg/PR4000.0/YTBElect_YTB0${show}-XXXXXXXX-XXXXXX/decode/streams
done
done

for show in 01 02 03 04 05 06 07 08 09 10
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
in=${model}-bg/PR4000.0/YTBElect_YTB0${show}-XXXXXXXX-XXXXXX/decode/rescore.mlf
out=${model}-bg/PR4000.0/YTBElect_YTB0${show}-XXXXXXXX-XXXXXX/decode/dat.dat
python processFileToDat.py --in $in --out $out
done
done



for show in 01 02 03 04 05 06 07 08 09 10
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for lm in lm1 lm2 lm3 lm4 lm5
do
outStream=${model}-bg/PR4000.0/YTBElect_YTB0${show}-XXXXXXXX-XXXXXX/decode/streams/stream${lm} 
out=${model}-bg/PR4000.0/YTBElect_YTB0${show}-XXXXXXXX-XXXXXX/decode/dat.dat
base/bin/LPlex -C lib/cfgs/hlm.cfg -s $outStream -u -t lms/${lm} $out 
done
done
done

for show in 01 02 03 04 05 06 07 08 09 10
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
inStream=${model}-bg/PR4000.0/YTBElect_YTB0${show}-XXXXXXXX-XXXXXX/decode/streams
out=${model}-bg/PR4000.0/YTBElect_YTB0${show}-XXXXXXXX-XXXXXX/decode
python computeWeightsShow.py --in $inStream --out $out >> cmds.txt
done
done

#run cmds.txt
for lmscale in 6.0 #12.0 16. 18.0 24.0 36.0
do
for show in 01 02 03 04 05 06 07 08 09 10
do
for model in  plp #grph-plp tandem grph-tandem hybrid grph-hybrid
do	
echo $model $show $lmscale >> eval_lmint.txt
lmint=${model}-bg/PR4000.0/YTBElect_YTB0${show}-XXXXXXXX-XXXXXX/decode/lm_int
lat=${model}-bg/PR4000.0
./scripts/lmrescore.sh -LMSCALE ${lmscale} -OUTPASS rescore-${lmscale} YTBElect_YTB0${show}-XXXXXXXX-XXXXXX lattices decode $lmint $lat FALSE >> eval_lmint.txt
done
done
done



for lmscale in 6.0 
do
for PRUNE in 4000.0 
do
for model in  plp #grph-plp tandem grph-tandem hybrid grph-hybrid
do
echo -------------------------------------------------- >> lmrescoreYTB.txt
echo ${model} ${PRUNE} ${lmscale} >> lmrescoreYTB.txt
./scripts/score.sh ${model}-bg/PR${PRUNE} YTBEdevsub rescore-${lmscale}  >> lmrescoreYTB.txt
done
done
done


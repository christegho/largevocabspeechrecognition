

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
./scripts/mergelats.sh -SYS ${model} YTBElect_YTB0${show}-XXXXXXXX-XXXXXX lattices decode ${model}-bg
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
./scripts/score.sh ${model}-bg dev03sub decode  >> eval.txt
done

for PRUNE in 4000.0 #  250.0 400.0 500.0 600.0 1000.0 2000.0 4000.0
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
	echo -------------------------------------------------- >> eval.txt
	echo ${model} ${PRUNE} >> eval.txt
	./scripts/score.sh ${model}-bg/PR${PRUNE} dev03sub decode >> eval.txt
done
done

#################################################################################################################
#2) Using the 1-best hypothesis generated from the bigram lattice, produce \cas- caded CMLLR and MLLR transforms.
#################################################################################################################
#Rescore determinized lattices with original and other acoustic models for cross adaptation
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
./scripts/hmmrescore.sh dev03_DEV001-20010117-XX2000 ${model}-bg merge ${model1}-bg/${model}-merge-bg ${model1}
done
done

###########################################
#Adapt and cross adapt - hypothesis obtained from rescoring model lattices using model 1
###########################################
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model1 in  grph-plp grph-tandem tandem   plp hybrid grph-hybrid
do
	./scripts/hmmadaptExt.sh -OUTPASS adapt-${model1} dev03_DEV001-20010117-XX2000 ${model1}-bg/${model}-merge-bg decode ${model}-adapt-bg/def-4/adaptedby-${model1} ${model}
done
done

###########################################
#These transforms can then be used to rescore lattices:
###########################################
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model1 in  grph-plp tandem grph-tandem  plp hybrid grph-hybrid
do
./scripts/hmmrescoreExt.sh -PRUNE 4000.0 -ADAPT ${model}-adapt-bg/def-4/adaptedby-${model1} adapt-${model1} -OUTPASS decode-${model1} dev03_DEV001-20010117-XX2000 ${model}-bg merge ${model}-adapt-bg/def-4/adaptedby-${model1} ${model}
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
./scripts/score.sh ${model}-adapt-bg/${pruning}/adaptedby-${model1} dev03sub decode-${model1} >> eval.txt
done
done
done
###########################################
#Fine Tuning INS and LM #TODO
###########################################
for lmscale in 6 17 21 27 33 39
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model1 in  grph-plp tandem grph-tandem  plp hybrid grph-hybrid
do
./scripts/hmmrescoreExt.sh -PRUNE 4000.0 -LMSCALE ${lmscale} -ADAPT ${model}-adapt-bg/def-4/adaptedby-${model1} adapt-${model1} -OUTPASS decode-${model1} dev03_DEV001-20010117-XX2000 ${model}-bg merge ${model}-adapt-bg/def-4/adaptedby-${model1}/LM${lmscale} ${model}
done
done
done

for PRUNE in 4000.0
do
for model in  grph-plp tandem grph-tandem plp hybrid grph-hybrid
do
./scripts/hmmrescoreExt.sh -PRUNE ${PRUNE} dev03_DEV001-20010117-XX2000 ${model}-bg merge ${model}-bg/PR${PRUNE} ${model}
done
done

#scoring
for lmscale in 6 17 21 27 33 39
do
for PRUNE in 4000.0 
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
	echo -------------------------------------------------- >> eval.txt
	echo ${model} ${PRUNE} >> eval.txt
	./scripts/score.sh ${model}-bg/PR${PRUNE} dev03sub decode >> eval.txt
done
done

for pruning in def-4
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
echo -------------------------------------------------- >> eval.txt
echo $model $model1 $pruning >> eval.txt
./scripts/score.sh ${model}-adapt-bg/${pruning}/adaptedby-${model1} dev03sub decode-${model1} >> eval.txt
done
done
done



#scoring
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
echo -------------------------------------------------- >> aa2.txt
echo ${model} default >> aa2.txt
./scripts/score.sh -NOFILT ${model}-bg dev03sub decode  >> aa2.txt
done

for PRUNE in 4000.0 #  250.0 400.0 500.0 600.0 1000.0 2000.0 4000.0
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
	echo -------------------------------------------------- >> aa2.txt
	echo ${model} ${PRUNE} >> aa2.txt
	./scripts/score.sh  -NOFILT ${model}-bg/PR${PRUNE} dev03sub decode >> aa2.txt
done
done

#scoring 
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
echo -------------------------------------------------- >> aa32.txt
echo ${model} ${model1} default >> aa32.txt
./scripts/score.sh  -NOFILT ${model}-bg/${model1}-merge-bg dev03sub decode  >> aa32.txt
done
done

#scoring
for PRUNE in   4000.0
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
	echo -------------------------------------------------- >> aa32.txt
	echo ${model} ${model1} ${PRUNE} >> aa32.txt
	./scripts/score.sh  -NOFILT ${model}-bg/${model1}-merge-bg/PR${PRUNE} dev03sub decode >> aa32.txt
done
done
done

for pruning in def 4k def-4 4k-4
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
echo -------------------------------------- >> acousticAdaptScoring.txt
echo $model $model1 $pruning >> acousticAdaptScoring.txt
./scripts/score.sh  -NOFILT ${model}-adapt-bg/${pruning}/adaptedby-${model1} dev03sub decode-${model1} >> acousticAdaptScoring.txt
done
done
done

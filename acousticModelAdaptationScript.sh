#1) determinise the lattices
for model in  grph-plp tandem grph-tandem
do
./scripts/1bestlatsExt.sh -SYS ${model} dev03_DEV001-20010117-XX2000  lattices decode ${model}-bg
done

for model in  grph-plp tandem grph-tandem
do
./scripts/mergelatsExt.sh -BEAMPRUNE 1000.0 -SYS ${model} dev03_DEV001-20010117-XX2000 lattices decode ${model}-bg
done

./scripts/mergelats.sh dev03_DEV001-20010117-XX2000 lattices decode plp-bg


./scripts/hmmrescore.sh dev03_DEV001-20010117-XX2000 plp-bg merge plp-bg plp

for model in  grph-plp tandem grph-tandem
do
./scripts/hmmrescore.sh dev03_DEV001-20010117-XX2000 plp-bg merge ${model}-bg ${model}
done

for PRUNE in 1000.0 250.0 400.0 500.0 600.0 2000.0 4000.0
do
for model in  grph-plp tandem grph-tandem plp
do
	./scripts/hmmrescoreExt.sh -PRUNE ${PRUNE} dev03_DEV001-20010117-XX2000 plp-bg merge ${model}-bg/PR${PRUNE} ${model}
done
done

egrep -c File plp-bg/dev03_DEV001-20010117-XX2000/decode/LOG

for model in  plp grph-plp tandem grph-tandem
do
echo -------------------------------------------------- >> aa2.txt
echo ${model} default >> aa2.txt
./scripts/score.sh ${model}-bg dev03sub decode  >> aa2.txt
done

for PRUNE in   250.0 400.0 500.0 600.0 1000.0 2000.0 4000.0
do
for model in  plp grph-plp tandem grph-tandem
do
	echo -------------------------------------------------- >> aa2.txt
	echo ${model} ${PRUNE} >> aa2.txt
	time ./scripts/score.sh ${model}-bg/PR${PRUNE} dev03sub decode >> aa2.txt
done
done

	
for PRUNE in 250.0 400.0 500.0 600.0 1000.0 2000.0 4000.0 
do
for model in  plp grph-plp tandem grph-tandem
do
	echo -------------------------------------------------- >> pruning2.txt
	echo -------------------------------------------------- >> uttLen2.txt
	echo ${model} ${PRUNE} >> pruning2.txt
	echo ${model} ${PRUNE} >> uttLen2.txt
	grep -C 0 'lattice pruned from'  ${model}-bg/PR${PRUNE}/dev03_DEV001-20010117-XX2000/decode/LOG >> pruning2.txt
	grep -C 0 'utterance length'  ${model}-bg/PR${PRUNE}/dev03_DEV001-20010117-XX2000/decode/LOG >> uttLen2.txt

done
done


#################################################################################################################
#2) Using the 1-best hypothesis generated from the bigram lattice, produce \cas- caded CMLLR and MLLR transforms.
#################################################################################################################
for model in  plp grph-plp tandem grph-tandem
do
for model1 in  grph-plp tandem grph-tandem  plp
do
	./scripts/hmmadapt.sh dev03_DEV001-20010117-XX2000 ${model}-bg decode ${model}-adapt-bg/def/adaptedby-${model1} ${model1}
done
done

for model in  plp grph-plp tandem grph-tandem
do
for model1 in   grph-plp tandem grph-tandem  plp
do
	./scripts/hmmadapt.sh dev03_DEV001-20010117-XX2000 ${model}-bg/PR4000.0 decode ${model}-adapt-bg/4k/adaptedby-${model1} ${model1}
done
done

for model in  plp grph-plp tandem grph-tandem
do
for model1 in  grph-plp grph-tandem tandem   plp
do
	./scripts/hmmadaptExt.sh dev03_DEV001-20010117-XX2000 ${model}-bg decode ${model}-adapt-bg/def-4/adaptedby-${model1} ${model1}
done
done

for model in  plp grph-plp tandem grph-tandem
do
for model1 in   grph-plp tandem grph-tandem  plp
do
	./scripts/hmmadaptExt.sh dev03_DEV001-20010117-XX2000 ${model}-bg/PR4000.0 decode ${model}-adapt-bg/4k-4/adaptedby-${model1} ${model1}
done
done
#TODO
f=dev03_DEV001-20010117-XX2000
for pruning in def-4 4k-4
do
for model in  plp grph-plp tandem grph-tandem
do
for model1 in   grph-plp tandem grph-tandem  plp
do
	echo -------------------------------------------------- >> logTX.txt
	echo ${model} ${pruning} >> logTX.txt

	grep -C 0 'Reestimation complete - average log prob per frame'  ${model}-adapt-bg/${pruning}/adaptedby-${model1}/${f}/adapt/LOG.cmllr >> logTX.txt
	grep -C 0 'Reestimation complete - average log prob per frame'  ${model}-adapt-bg/${pruning}/adaptedby-${model1}/${f}/adapt/LOG1.mllr >> logTX.txt
	grep -C 0 'Reestimation complete - average log prob per frame'  ${model}-adapt-bg/${pruning}/adaptedby-${model1}/${f}/adapt/LOG2.mllr >> logTX.txt
	grep -C 0 'Reestimation complete - average log prob per frame'  ${model}-adapt-bg/${pruning}/adaptedby-${model1}/${f}/adapt/LOG3.mllr >> logTX.txt
	grep -C 0 'Reestimation complete - average log prob per frame'  ${model}-adapt-bg/${pruning}/adaptedby-${model1}/${f}/adapt/LOG4.mllr >> logTX.txt
	grep -C 0 'Reestimation complete - average log prob per frame'  ${model}-adapt-bg/${pruning}/adaptedby-${model1}/${f}/adapt/LOG.mllr >> logTX.txt
done
done
done


#TODO
#These transforms can then be used to rescore lattices:
for model in  plp grph-plp tandem grph-tandem
do
for model1 in  tandem   plp
do
./scripts/hmmrescoreExt.sh -PRUNE 4000.0 -ADAPT ${model}-adapt-bg/def/adaptedby-${model1} adapt dev03_DEV001-20010117-XX2000 plp-bg merge ${model}-adapt-bg/def/adaptedby-${model1} ${model}
done
done

for model in  plp #grph-plp tandem grph-tandem
do
for model1 in  tandem   plp
do
./scripts/hmmrescoreExt.sh -PRUNE 4000.0 -ADAPT ${model}-adapt-bg/def-4/adaptedby-${model1} adapt dev03_DEV001-20010117-XX2000 plp-bg merge ${model}-adapt-bg/def-4/adaptedby-${model1} ${model}
done
done

for model in  plp grph-plp tandem grph-tandem
do
for model1 in  tandem   plp
do
./scripts/hmmrescoreExt.sh -PRUNE ${model}-adapt-bg/4k/adaptedby-${model1} adapt dev03_DEV001-20010117-XX2000 plp-bg merge ${model}-adapt-bg/4k/adaptedby-${model1} ${model}
done
done

for model in  plp grph-plp tandem grph-tandem
do
for model1 in  tandem   plp
do
./scripts/hmmrescoreExt.sh -PRUNE ${model}-adapt-bg/4k-4/adaptedby-${model1} adapt dev03_DEV001-20010117-XX2000 plp-bg merge ${model}-adapt-bg/4k-4/adaptedby-${model1} ${model}
done
done

#TODO
for pruning in def-4 4k-4
do
for model in  plp grph-plp tandem grph-tandem
do
for model1 in  tandem   plp
do
echo $model
./scripts/score.sh ${model}-adapt-bg/${pruning}/adaptedby-${model1} dev03sub decode
done


for pruning in def-4 4k-4 def 4k
do
for model in  plp grph-plp tandem grph-tandem
do
for model1 in  tandem   plp
do
echo $model
cd /home/ct506/MLSALT11/${model}-adapt-bg/${pruning}/adaptedby-${model1}/$f/adapt
cp  -r /home/ct506/MLSALT11/plp-bg/dev03_DEV001-20010117-XX2000/decode/lattices .
done
done
done

for pruning in def-4 4k-4 def 4k
do
for model in  plp grph-plp tandem grph-tandem
do
for model1 in    plp
do
echo $model
	cd /home/ct506/MLSALT11/${model}-adapt-bg/${pruning}/adaptedby-${model1}/$f/adapt/xforms
	for n in range(15):
	do
	mv DEV001-0F00${n}-20010117-XX2000-en.cmllr  DEV001-0000${n}-20010117-XX2000-en.cmllr
	done
	mv DEV001-0F00${n}-20010117-XX2000-en.cmllr  DEV001-0000${n}-20010117-XX2000-en.cmllr
done
done
done

for pruning in def-4 4k-4 def 4k
do
for model in  plp grph-plp tandem grph-tandem
do
for model1 in  tandem   plp
do
echo $model
	cd /home/ct506/MLSALT11/${model}-adapt-bg/${pruning}/adaptedby-${model1}/$f/adapt/xforms
	for n in range(15):
	do
	mv DEV001-0F00${n}-20010117-XX2000-en.cmllr  DEV001-0000${n}-20010117-XX2000-en.cmllr
	done
done
done
done


#3) system, cross adaptation.  First the lattices can be rescored using the graphemic PLP system
for model in  grph-plp tandem grph-tandem hybrid grph-hybrid #plp
do
#./scripts/hmmrescore.sh dev03_DEV001-20010117-XX2000 plp-bg merge grph-plp-bg grph-plp
./scripts/hmmrescore.sh dev03_DEV001-20010117-XX2000 plp-bg merge ${model}-bg ${model}
done

for model in  grph-plp tandem grph-tandem hybrid grph-hybrid #plp
do
echo $model
	./scripts/score.sh ${model}-bg dev03sub decode
done

#TODO: Lattice directory missing: grph-tandem-bg/dev03_DEV001-20010117-XX2000/merge/lattices

#4) These  graphemic  system  hypothesis  transforms  can  then  be  used  to  rescore lattices:
#./scripts/hmmrescore.sh -ADAPT plp-adapt-bg adapt-grph-plp -OUTPASS decode-grph-plp dev03_DEV001-20010117-XX2000 plp-bg merge plp-adapt-bg plp
for model in  grph-plp tandem grph-tandem plp
do
for model2 in  grph-plp tandem grph-tandem hybrid grph-hybrid plp
do
	./scripts/hmmrescore.sh -ADAPT ${model}-adapt-bg adapt-${model2} -OUTPASS decode-${model2} dev03_DEV001-20010117-XX2000 ${model}-bg merge ${model}-adapt-bg ${model}
done
done
#TODO
for model in  grph-plp #tandem grph-tandem hybrid grph-hybrid #plp
do
echo $model
	./scripts/score.sh plp-adapt-bg dev03sub decode-$model
done

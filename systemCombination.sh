
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
./base/bin/HLEd -i ${model1}-bg/${model}-merge-bg/dev03_DEV001-20010117-XX2000/decode/score.mlf -l '*' ${model1}-bg/${model}-merge-bg/dev03_DEV001-20010117-XX2000/decode/rescore.mlf
done
done


for PRUNE in   4000.0
do
for model in  plp grph-plp tandem grph-tandem
do
for model1 in plp  grph-plp tandem grph-tandem hybrid grph-hybrid
do
./base/bin/HLEd -i ${model1}-bg/${model}-merge-bg/PR${PRUNE}/dev03_DEV001-20010117-XX2000/decode/score.mlf -l '*' ${model1}-bg/${model}-merge-bg/PR${PRUNE}/dev03_DEV001-20010117-XX2000/decode/rescore.mlf
done
done
done

for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
./base/bin/HLEd -i ${model}-bg/dev03_DEV001-20010117-XX2000/decode/score.mlf -l '*' ${model}-bg/dev03_DEV001-20010117-XX2000/decode/rescore.mlf
done

for PRUNE in 4000.0 #  250.0 400.0 500.0 600.0 1000.0 2000.0 4000.0
do
for model in  plp grph-plp tandem grph-tandem hybrid grph-hybrid
do
./base/bin/HLEd -i ${model}-bg/PR${PRUNE}/dev03_DEV001-20010117-XX2000/decode/score.mlf -l '*' ${model}-bg/PR${PRUNE}/dev03_DEV001-20010117-XX2000/decode/rescore.mlf
done
done




./base/bin/HResults -t -f -I plp-bg/dev03_DEV001-20010117-XX2000/decode/score.mlf lib/wlists/train.lst grph-plp-bg/dev03_DEV001-20010117-XX2000/decode/rescore.mlf

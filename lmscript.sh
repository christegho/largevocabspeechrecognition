#language modeling script

ln -s /usr/local/teach/MLSALT11/Speech/{lib,lms,lattices,base,hmms,scripts} MLSALT11

cp -r /usr/local/teach/MLSALT11/Speech/scripts  .

./scripts/1bestlats.sh dev03_DEV001-20010117-XX2000  lattices decode plp-bg

./scripts/score.sh plp-bg dev03sub 1best/LM12.0_IN-10.0

for lm in lm1 lm2 lm3 lm4 lm5
do
	for show in dev03_DEV001-20010117-XX2000 dev03_DEV002-20010120-XX1830 dev03_DEV003-20010122-XX2100 dev03_DEV004-20010125-XX1830 dev03_DEV007-20010128-XX1400 dev03_DEV010-20010131-XX2000
	do	
	echo $show $lm >> lm.txt
	./scripts/lmrescore.sh $show lattices decode \ lms/$lm plp-tg$lm FALSE >> lm.txt
done
done

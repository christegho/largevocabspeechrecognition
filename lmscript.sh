#language modeling script done

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

#scoring
for lm in lm1 lm2 lm3 lm4 lm5
do	
	echo $lm >> lm.txt
	./scripts/score.sh plp-tg$lm dev03 rescore >> lm.txt
done


#compute perplexity
for lm in lm1 lm2 lm3 lm4 lm5
do
	echo $lm >> lm.txt
	base/bin/LPlex -C lib/cfgs/hlm.cfg -u -t lms/$lm lib/texts/dev03.dat >>lm.txt
done

#interpolation - compute weights
for lm in lm1 lm2 lm3 lm4 lm5
do
	base/bin/LPlex -C lib/cfgs/hlm.cfg -s stream$lm -u -t lms/$lm lib/texts/dev03.dat 
done


#Evaluate performance after interpolation
base/bin/LMerge -C lib/cfgs/hlm.cfg -i 0.124 lms/lm2 -i 0.144 lms/lm3 -i 0.099 lms/lm4 -i 0.291 lms/lm5 lib/wlists/train.lst lms/lm1 lm_int

for show in dev03_DEV001-20010117-XX2000 dev03_DEV002-20010120-XX1830 dev03_DEV003-20010122-XX2100 dev03_DEV004-20010125-XX1830 dev03_DEV007-20010128-XX1400 dev03_DEV010-20010131-XX2000
	do	
	echo $show lm_int >> lm.txt
	./scripts/lmrescore.sh $show lattices decode \ lm_int plp-tglm_int FALSE >> lm.txt
done

echo lm_int  >> lm.txt
./scripts/score.sh plp-tglm_int  dev03 rescore >> lm.txt

base/bin/LPlex -C lib/cfgs/hlm.cfg -u -t lm_int lib/texts/dev03.dat >>lm.txt

for show in eval03_DEV011-20010206-XX1830 eval03_DEV012-20010217-XX1000 eval03_DEV013-20010220-XX2000 eval03_DEV014-20010221-XX1830 eval03_DEV015-20010225-XX0900 eval03_DEV016-20010228-XX2100
do	

	./scripts/lmrescore.sh $show lattices decode \ lm_int plp-tglm_int FALSE 
done


echo lm_int eval03 
./scripts/score.sh plp-tglm_int  eval03 rescore 

for show in eval03_DEV011-20010206-XX1830 eval03_DEV012-20010217-XX1000 eval03_DEV013-20010220-XX2000 eval03_DEV014-20010221-XX1830 eval03_DEV015-20010225-XX0900 eval03_DEV016-20010228-XX2100

	do
	echo lm_int  eval03  $show  >>lm.txt
	base/bin/LPlex -C lib/cfgs/hlm.cfg -u -t lm_int lib/texts/$show.dat  >>lm.txt
done


#show specific interpolation
for show in  eval03_DEV011-20010206-XX1830 eval03_DEV012-20010217-XX1000 eval03_DEV013-20010220-XX2000 eval03_DEV014-20010221-XX1830 eval03_DEV015-20010225-XX0900 eval03_DEV016-20010228-XX2100
do
for lm in lm1 lm2 lm3 lm4 lm5
do
	base/bin/LPlex -C lib/cfgs/hlm.cfg -s stream$show$lm -u -t lms/$lm plp-tglm_int/$show.dat 
done
done

for show in  eval03_DEV011-20010206-XX1830 eval03_DEV012-20010217-XX1000 eval03_DEV013-20010220-XX2000 eval03_DEV014-20010221-XX1830 eval03_DEV015-20010225-XX0900 eval03_DEV016-20010228-XX2100
do
	mkdir $show
done

base/bin/LMerge -C lib/cfgs/hlm.cfg -i 0.08245508 lms/lm2 -i 0.22638773 lms/lm3 -i 0.06825285 lms/lm4 -i 0.17751581 lms/lm5 lib/wlists/train.lst lms/lm1 lm_inteval03_DEV011-20010206-XX1830
base/bin/LMerge -C lib/cfgs/hlm.cfg -i 0.03367852 lms/lm2 -i 0.15862806 lms/lm3 -i 0.05707789 lms/lm4 -i 0.40238722 lms/lm5 lib/wlists/train.lst lms/lm1 lm_inteval03_DEV012-20010217-XX1000
base/bin/LMerge -C lib/cfgs/hlm.cfg -i 0.07465908 lms/lm2 -i 0.11504686 lms/lm3 -i 0.1447565 lms/lm4 -i 0.27217506 lms/lm5 lib/wlists/train.lst lms/lm1 lm_inteval03_DEV013-20010220-XX2000
base/bin/LMerge -C lib/cfgs/hlm.cfg -i 0.0538853 lms/lm2 -i 0.23133703 lms/lm3 -i 0.09826272 lms/lm4 -i 0.19548814 lms/lm5 lib/wlists/train.lst lms/lm1 lm_inteval03_DEV014-20010221-XX1830
base/bin/LMerge -C lib/cfgs/hlm.cfg -i 0.13375443 lms/lm2 -i 0.14475769 lms/lm3 -i 0.06893803 lms/lm4 -i 0.40826878 lms/lm5 lib/wlists/train.lst lms/lm1 lm_inteval03_DEV015-20010225-XX0900
base/bin/LMerge -C lib/cfgs/hlm.cfg -i 0.22496165 lms/lm2 -i 0.07626963 lms/lm3 -i 0.208407 lms/lm4 -i 0.09053861 lms/lm5 lib/wlists/train.lst lms/lm1 lm_inteval03_DEV016-20010228-XX2100


for show in eval03_DEV011-20010206-XX1830 eval03_DEV012-20010217-XX1000 eval03_DEV013-20010220-XX2000 eval03_DEV014-20010221-XX1830 eval03_DEV015-20010225-XX0900 eval03_DEV016-20010228-XX2100
do
for show1 in eval03_DEV011-20010206-XX1830 eval03_DEV012-20010217-XX1000 eval03_DEV013-20010220-XX2000 eval03_DEV014-20010221-XX1830 eval03_DEV015-20010225-XX0900 eval03_DEV016-20010228-XX2100

do	

	./scripts/lmrescore.sh $show1 lattices decode \ lm_int$show plp-tglm_int_$show FALSE 
done
done

for show in eval03_DEV011-20010206-XX1830 eval03_DEV012-20010217-XX1000 eval03_DEV013-20010220-XX2000 eval03_DEV014-20010221-XX1830 eval03_DEV015-20010225-XX0900 eval03_DEV016-20010228-XX2100
for show in eval03_DEV012-20010217-XX1000 
	do
	echo lm_int$show eval03  $show 
	./scripts/score.sh plp-tglm_int_$show  eval03 rescore 
	#base/bin/LPlex -C lib/cfgs/hlm.cfg -u -t lm_int$show plp-tglm_int/$show.dat  >>lm.txt
done

for show in eval03_DEV011-20010206-XX1830 eval03_DEV012-20010217-XX1000 eval03_DEV013-20010220-XX2000 eval03_DEV014-20010221-XX1830 eval03_DEV015-20010225-XX0900 eval03_DEV016-20010228-XX2100
	do
	echo ----------------------------------- >>lm.txt
	echo plp_tglm_int1/lm_int$show  eval03  $show  >>lm.txt
	base/bin/LPlex -C lib/cfgs/hlm.cfg -u -t plp_tglm_int1/lm_int$show lib/texts/$show.dat  >>lm.txt
done

for show in eval03_DEV011-20010206-XX1830 eval03_DEV012-20010217-XX1000 eval03_DEV013-20010220-XX2000 eval03_DEV014-20010221-XX1830 eval03_DEV015-20010225-XX0900 eval03_DEV016-20010228-XX2100

	do
	echo ----------------------------------- >>lm.txt
	echo lm_int  eval03 1bestHyp PP $show  >>lm.txt
	base/bin/LPlex -C lib/cfgs/hlm.cfg -u -t lm_int plp-tglm_int/$show.dat  >>lm.txt
done

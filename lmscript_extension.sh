#show specific interpolation Iteration 2
iter=4
for show in  eval03_DEV011-20010206-XX1830 eval03_DEV012-20010217-XX1000 eval03_DEV013-20010220-XX2000 eval03_DEV014-20010221-XX1830 eval03_DEV015-20010225-XX0900 eval03_DEV016-20010228-XX2100
do
for lm in lm1 lm2 lm3 lm4 lm5
do
	base/bin/LPlex -C lib/cfgs/hlm.cfg -s streams/${show}/stream${iter}${show}${lm} -u -t lms/${lm} plp-tglm_int3_${show}/${show}${iter}.dat 
done
done



base/bin/LMerge -C lib/cfgs/hlm.cfg -i 0.0746795188925 lms/lm2 -i 0.244080310175 lms/lm3 -i 0.0586687664592 lms/lm4 -i 0.160111031709 lms/lm5 lib/wlists/train.lst lms/lm1 lm_int2eval03_DEV011-20010206-XX1830
base/bin/LMerge -C lib/cfgs/hlm.cfg -i 0.0202395700149 lms/lm2 -i 0.158913886876 lms/lm3 -i 0.0493228580507 lms/lm4 -i 0.418618905244 lms/lm5 lib/wlists/train.lst lms/lm1 lm_int2eval03_DEV012-20010217-XX1000
base/bin/LMerge -C lib/cfgs/hlm.cfg -i 0.0653191564981 lms/lm2 -i 0.111714900055 lms/lm3 -i 0.152214871469 lms/lm4 -i 0.271097538773 lms/lm5 lib/wlists/train.lst lms/lm1 lm_int2eval03_DEV013-20010220-XX2000
base/bin/LMerge -C lib/cfgs/hlm.cfg -i 0.0436566477903 lms/lm2 -i 0.250129876801 lms/lm3 -i 0.102857123393 lms/lm4 -i 0.17981612942 lms/lm5 lib/wlists/train.lst lms/lm1 lm_int2eval03_DEV014-20010221-XX1830
base/bin/LMerge -C lib/cfgs/hlm.cfg -i 0.137749784539 lms/lm2 -i 0.143444682009 lms/lm3 -i 0.0609941228633 lms/lm4 -i 0.427647862818 lms/lm5 lib/wlists/train.lst lms/lm1 lm_int2eval03_DEV015-20010225-XX0900
base/bin/LMerge -C lib/cfgs/hlm.cfg -i 0.247708356447 lms/lm2 -i 0.062992033951 lms/lm3 -i 0.226400603748 lms/lm4 -i 0.0615639058488 lms/lm5 lib/wlists/train.lst lms/lm1 lm_int2eval03_DEV016-20010228-XX2100

iter=4
for show in eval03_DEV011-20010206-XX1830 eval03_DEV012-20010217-XX1000 eval03_DEV013-20010220-XX2000 eval03_DEV014-20010221-XX1830 eval03_DEV015-20010225-XX0900 eval03_DEV016-20010228-XX2100
do
for show1 in eval03_DEV011-20010206-XX1830 eval03_DEV012-20010217-XX1000 eval03_DEV013-20010220-XX2000 eval03_DEV014-20010221-XX1830 eval03_DEV015-20010225-XX0900 eval03_DEV016-20010228-XX2100
do	

	./scripts/lmrescore.sh $show lattices decode \ lm_int${iter}${show1} plp-tglm_int${iter}_${show1} FALSE 
done
done


for show in eval03_DEV011-20010206-XX1830 eval03_DEV012-20010217-XX1000 eval03_DEV013-20010220-XX2000 eval03_DEV014-20010221-XX1830 eval03_DEV015-20010225-XX0900 eval03_DEV016-20010228-XX2100
#for show in eval03_DEV016-20010228-XX2100
	do
	echo lm_int$show eval03  $show 
	#./scripts/score.sh plp-tglm_int${iter}_$show  eval03 rescore 
	base/bin/LPlex -C lib/cfgs/hlm.cfg -u -t lm_int${iter}$show plp-tglm_int3_${show}/${show}${iter}.dat  >>lm.txt
done

############################################################################################################
#Interpolation with true transcriptions
iter=True
for show in  eval03_DEV011-20010206-XX1830 eval03_DEV012-20010217-XX1000 eval03_DEV013-20010220-XX2000 eval03_DEV014-20010221-XX1830 eval03_DEV015-20010225-XX0900 eval03_DEV016-20010228-XX2100
do
for lm in lm1 lm2 lm3 lm4 lm5
do
	base/bin/LPlex -C lib/cfgs/hlm.cfg -s streams/${show}/stream${iter}${show}${lm} -u -t lms/${lm} lib/texts/${show}.dat
done
done

array([[ 0.54313916,  0.09474766,  0.09576071,  0.09413864,  0.17221331],
       [ 0.3537339 ,  0.03684993,  0.10699796,  0.05401004,  0.4484088 ],
       [ 0.40437983,  0.12929331,  0.10976363,  0.07082774,  0.28573433],
       [ 0.45725402,  0.08068923,  0.13600563,  0.11771865,  0.20833179],
       [ 0.17859488,  0.13547223,  0.15404762,  0.06507504,  0.46680953],
       [ 0.39909903,  0.32791436,  0.10737439,  0.12018713,  0.04542287]])


base/bin/LMerge -C lib/cfgs/hlm.cfg -i 0.0947476625776 lms/lm2 -i 0.0957607053641 lms/lm3 -i 0.0941386351477 lms/lm4 -i 0.172213310238 lms/lm5 lib/wlists/train.lst lms/lm1 lm_intTrueeval03_DEV011-20010206-XX1830
base/bin/LMerge -C lib/cfgs/hlm.cfg -i 0.0368499327881 lms/lm2 -i 0.106997962104 lms/lm3 -i 0.0540100439047 lms/lm4 -i 0.448408804254 lms/lm5 lib/wlists/train.lst lms/lm1 lm_intTrueeval03_DEV012-20010217-XX1000
base/bin/LMerge -C lib/cfgs/hlm.cfg -i 0.12929330565 lms/lm2 -i 0.109763625047 lms/lm3 -i 0.070827739203 lms/lm4 -i 0.285734332345 lms/lm5 lib/wlists/train.lst lms/lm1 lm_intTrueeval03_DEV013-20010220-XX2000
base/bin/LMerge -C lib/cfgs/hlm.cfg -i 0.0806892339647 lms/lm2 -i 0.136005630294 lms/lm3 -i 0.117718653053 lms/lm4 -i 0.208331787307 lms/lm5 lib/wlists/train.lst lms/lm1 lm_intTrueeval03_DEV014-20010221-XX1830
base/bin/LMerge -C lib/cfgs/hlm.cfg -i 0.135472234532 lms/lm2 -i 0.154047619867 lms/lm3 -i 0.0650750398527 lms/lm4 -i 0.466809526325 lms/lm5 lib/wlists/train.lst lms/lm1 lm_intTrueeval03_DEV015-20010225-XX0900
base/bin/LMerge -C lib/cfgs/hlm.cfg -i 0.327914363527 lms/lm2 -i 0.107374386583 lms/lm3 -i 0.120187132877 lms/lm4 -i 0.0454228682103 lms/lm5 lib/wlists/train.lst lms/lm1 lm_intTrueeval03_DEV016-20010228-XX2100


iter=True
for show in eval03_DEV011-20010206-XX1830 eval03_DEV012-20010217-XX1000 eval03_DEV013-20010220-XX2000 eval03_DEV014-20010221-XX1830 eval03_DEV015-20010225-XX0900 eval03_DEV016-20010228-XX2100
do
for show1 in eval03_DEV011-20010206-XX1830 eval03_DEV012-20010217-XX1000 eval03_DEV013-20010220-XX2000 eval03_DEV014-20010221-XX1830 eval03_DEV015-20010225-XX0900 eval03_DEV016-20010228-XX2100
do	

	./scripts/lmrescore.sh $show lattices decode \ lm_int${iter}${show1} plp-tglm_int${iter}_${show1} FALSE 
done
done


for show in eval03_DEV011-20010206-XX1830 eval03_DEV012-20010217-XX1000 eval03_DEV013-20010220-XX2000 eval03_DEV014-20010221-XX1830 eval03_DEV015-20010225-XX0900 eval03_DEV016-20010228-XX2100
#for show in eval03_DEV016-20010228-XX2100
	do
	echo ------------------------------------------------ >>lm.txt
	echo ------------------------------------------------ >>lm.txt
	echo lm_int$show eval03 TRUE $show 
	./scripts/score.sh plp-tglm_int${iter}_$show  eval03 rescore 
	base/bin/LPlex -C lib/cfgs/hlm.cfg -u -t lm_int${iter}$show lib/texts/${show}.dat  >>lm.txt
done

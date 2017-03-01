#!/bin/tcsh
#$ -S /bin/tcsh

# default parameters
set LMSCALE=12.0
set INSPEN=0.0
set LMMODEL=plp

set ALLARGS=($*)
set CHANGED
if ( $#argv > 1 ) then
while ( $?CHANGED )
  unset CHANGED
  if ( "$argv[1]" == "-OUTPASS" )  then
    set CHANGED
    shift argv
    set OUTPASS = $argv[1]
    shift argv
  endif
  if ( "$argv[1]" == "-LMSCALE" )  then
    set CHANGED
    shift argv
    set LMSCALE = $argv[1]
    shift argv
  endif
  if ( "$argv[1]" == "-LMMODEL" )  then
    set CHANGED
    shift argv
    set LMMODEL = $argv[1]
    shift argv
  endif
  if ( "$argv[1]" == "-INSPEN" )  then
    set CHANGED
    shift argv
    set INSPEN = $argv[1]
    shift argv
  endif
end
endif

if (( $#argv != 4)) then
   echo "usage: `basename $0` [-OUTPASS TGT_cn] [-INSPEN 0.0] [-LMSCALE 12.0] TESTSET SRC PASS TGT"
   exit 0
endif


if ( $LMMODEL == "plp" ) then
    set LMSCALE=17.0
else if (( $LMMODEL == "tandem" ) || ( $LMMODEL == "tandem-sat" ))then
    set LMSCALE=39.0
else if ( $LMMODEL == "hybrid" ) then
    if ( $?ADAPTSRC ) then 
        echo "Adaptation not supported for hybrid systems"
        exit 0
    endif
    set LMSCALE=21.0
else if ( $LMMODEL == "grph-plp" ) then
    set LMSCALE=17.0
else if ( $LMMODEL == "grph-tandem" ) then
    set LMSCALE=39.0
else if ( $LMMODEL == "grph-hybrid" ) then
    if ( $?ADAPTSRC ) then 
        echo "Adaptation not supported for hybrid systems"
        exit 0
    endif
    set LMSCALE=21.0
else
    echo "Unknown system kind: $SYSTEM"
    exit 0
endif

set TESTSET = $1
set SRC     = $2
set PASS    = $3
set TGT     = $4

# cache the command so know what's run
if (! -d CMDs/$TGT/$TESTSET ) mkdir -p CMDs/$TGT/$TESTSET
set TRAINSET=cnrescore
echo "------------------------------------" >> CMDs/$TGT/$TESTSET/${TRAINSET}.cmds
echo "$0 $ALLARGS" >> CMDs/${TGT}/$TESTSET/${TRAINSET}.cmds
echo "------------------------------------" >> CMDs/$TGT/$TESTSET/${TRAINSET}.cmds

if ( ! -d $SRC/${TESTSET}/$PASS/lattices ) then
    echo "Lattice directory missing: $SRC/${TESTSET}/$PASS/lattices"
    exit 0
endif

set SCP       = lib/flists/${TESTSET}.scp
set CNDICT    = lib/dicts/train.lv.dct
set DICT      = lib/dicts/train.hv.dct
set HLCONF    = base/bin/HLConf
set HLED      = base/bin/HLEd
set HVITE     = base/bin/HVite
set CFG       = lib/cfgs/hlconf.cfg
set MERGE     = base/tools/mergemlfs

if (! -d $SRC/$TESTSET) then 
  echo "Lattice directory $SRC/$TESTSET doesn't exist"
  exit 0;
endif

if ( $?OUTPASS ) then 
   set WORKDIR = $TGT/${TESTSET}/${OUTPASS}
else 
   set WORKDIR = $TGT/${TESTSET}/${PASS}_cn
endif
if (! -d ${WORKDIR} ) then
    mkdir -p ${WORKDIR}/lattices
    mkdir -p ${WORKDIR}/flists
else 
    echo "Directory exists: ${TGT}/${TESTSET}/${PASS}_cn"
    echo "Delete to run"
    exit 0
endif

find $SRC/$TESTSET/$PASS/lattices -follow -name '*.lat.gz' -print | sed 's/\.lat\.gz/\.lat/g'  > $WORKDIR/lattices.scp
set LATSCP = $WORKDIR/lattices.scp
set CNSCALE=`echo $LMSCALE | awk '{printf("%f",1/$1)}'`

cat > ${TGT}/${TESTSET}/${PASS}_cn/run.bat <<EOF 
#!/bin/bash

#\$ -S /bin/bash

$HLCONF -A -D -V -i ${WORKDIR}/lattices.mlf -C $CFG -T 1 \
-a $CNSCALE -s 1.0 -r 1.0 -p $INSPEN -z -Z -l $WORKDIR/lattices \
-S $LATSCP $CNDICT >& ${WORKDIR}/LOG

$HLED -A -D -V -i $WORKDIR/align.mlf -l '*' -X rec lib/edfiles/delsil.led $WORKDIR/lattices.mlf  > $WORKDIR/LOG.hled

# some MLF labels  may not exist - generate the list of files that have MLF entries
./scripts/mlf2scp $WORKDIR/align.mlf $SCP ${WORKDIR}/flists/${TESTSET}.scp

$HVITE -A -D -i $WORKDIR/time+sil.mlf -H hmms/MMF.plp -T 1 -C lib/cfgs/hvite.cfg \
-X rec -t 250.0 250.0 1000.1 \
-b \<s\> -a -I $WORKDIR/align.mlf -S ${WORKDIR}/flists/${TESTSET}.scp $DICT hmms/xwrd.clustered.plp >& $WORKDIR/LOG.align

$HLED -A -D -V -i $WORKDIR/time.mlf -l '*' -X rec lib/edfiles/delsil.led $WORKDIR/time+sil.mlf  > $WORKDIR/LOG.hled2

paste $WORKDIR/time.mlf $WORKDIR/align.mlf | awk '{if (NF>2) {printf("%d %d %s %f\n",\$1,\$2,\$3,\$NF)} else {print \$2}}' > ${WORKDIR}/rescore.mlf

EOF

chmod u+x ${TGT}/${TESTSET}/${PASS}_cn/run.bat
qsub -cwd -o ${TGT}/${TESTSET}/${PASS}_cn/run.LOG -j y ${TGT}/${TESTSET}/${PASS}_cn/run.bat




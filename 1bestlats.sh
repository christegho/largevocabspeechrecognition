#!/bin/tcsh
#$ -S /bin/tcsh

# default parameters
set LMSCALE=12.0
set INSPEN=-10.0
set OUTPASS=1best

set ALLARGS=($*)
set CHANGED
if ( $#argv > 1 ) then
while ( $?CHANGED )
  unset CHANGED
  if ( "$argv[1]" == "-LMSCALE" )  then
    set CHANGED
    shift argv
    set LMSCALE = $argv[1]
    shift argv
  endif
  if ( "$argv[1]" == "-INSPEN" )  then
    set CHANGED
    shift argv
    set INSPEN = $argv[1]
    shift argv
  endif
  if ( "$argv[1]" == "-OUTPASS" )  then
    set CHANGED
    shift argv
    set OUTPASS = $argv[1]
    shift argv
  endif
end
endif

if ( $#argv != 4 ) then
   echo "usage: `basename $0` [-LMSCALE 12.0] [-INSPEN -10.0] [-OUTPASS 1best] TESTSET SRC PASS TGT"
   exit 0
endif

set TESTSET=$1
set SRC=$2
set PASS=$3
set TGT=$4

# cache the command so know what's run
if (! -d CMDs/$TGT/$TESTSET) mkdir -p CMDs/$TGT/$TESTSET
set TRAINSET=1bestlats
echo "------------------------------------" >> CMDs/$TGT/$TESTSET/${TRAINSET}.cmds
echo "$0 $ALLARGS" >> CMDs/${TGT}/$TESTSET/${TRAINSET}.cmds
echo "------------------------------------" >> CMDs/$TGT/$TESTSET/${TRAINSET}.cmds

if (! -d $SRC/$TESTSET/$PASS/lattices) then 
  echo "Lattice directory missing: $SRC/$TESTSET/$PASS/lattices"
  exit 0;
endif

set WORKDIR=$TGT/$TESTSET/$OUTPASS/LM${LMSCALE}_IN${INSPEN}

if ( ! -d $WORKDIR ) then
    mkdir -p $WORKDIR/flists
else
    echo "Directory exists: $WORKDIR"
    echo "Delete to run"
    exit 0
endif

set SCP       = lib/flists/${TESTSET}.scp 
set DICT      = lib/dicts/train.lv.dct
set HLRESCORE = base/bin/HLRescore 
set CFG       = lib/cfgs/hlrescore.cfg

cat > $WORKDIR/run.bat  <<EOF 
#!/bin/bash

#\$ -S /bin/bash

# some lattices may not exist - generate the list of lattices to avoid HDecode crashing
 ./scripts/lats2scp $SRC/${TESTSET}/$PASS/lattices $SCP ${WORKDIR}/flists/${TESTSET}.scp

# run the lattice rescoring
$HLRESCORE -A -D -V -T 7 -C $CFG -f \
-s $LMSCALE -p $INSPEN -i $WORKDIR/rescore.mlf -L $SRC/$TESTSET/$PASS/lattices \
-S ${WORKDIR}/flists/${TESTSET}.scp $DICT >& $WORKDIR/LOG

EOF

chmod u+x $WORKDIR/run.bat
qsub -cwd -o $WORKDIR/run.LOG -j y $WORKDIR/run.bat


#!/bin/tcsh
#$ -S /bin/tcsh

set BEAMPRUNE = 100.0
set ARCPRUNE = 200.0
set LMSCALE=12.0
set INSPEN=-10.0
set OUTPASS=merge

set ALLARGS=($*)
set CHANGED
if ( $#argv > 1 ) then
while ( $?CHANGED )
  unset CHANGED
  if ( "$argv[1]" == "-BEAMPRUNE" )  then
    set CHANGED
    shift argv
    set BEAMPRUNE = $argv[1]
    shift argv
  endif
  if ( "$argv[1]" == "-ARCPRUNE" )  then
    set CHANGED
    shift argv
    set ARCPRUNE = $argv[1]
    shift argv
  endif
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
   echo "usage: `basename $0` [-OUTPASS merge] [-LMSCALE 12.0] [-INSPEN -10.0] [-BEAMPRUNE 100.0] [-ARCPRUNE 200.0] TESTSET SRC PASS TGT"
   exit 0
endif

set TESTSET=$1
set SRC=$2
set PASS=$3
set TGT=$4

# cache the command so know what's run
if (! -d CMDs/$TGT/$TESTSET) mkdir -p CMDs/$TGT/$TESTSET
set TRAINSET=mergelats
echo "------------------------------------" >> CMDs/$TGT/$TESTSET/${TRAINSET}.cmds
echo "$0 $ALLARGS" >> CMDs/${TGT}/$TESTSET/${TRAINSET}.cmds
echo "------------------------------------" >> CMDs/$TGT/$TESTSET/${TRAINSET}.cmds

if (! -d $SRC/$TESTSET/$PASS/lattices) then 
  echo "Lattice directory issing: $SRC/$TESTSET/$PASS/lattices"
  exit 0;
endif

set WORKDIR=$TGT/$TESTSET/$OUTPASS
if ( ! -d $WORKDIR ) then 
    mkdir -p $WORKDIR/lattices
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

cat > $WORKDIR/run.bat <<EOF 
#!/bin/bash

#\$ -S /bin/bash

# some lattices may not exist - generate the list of lattices to avoid HLRescore crashing
 ./scripts/lats2scp $SRC/${TESTSET}/$PASS/lattices $SCP ${WORKDIR}/flists/${TESTSET}.scp

# some lattices may not exist - generate the list of lattices to avoid HLRescore crashing
$HLRESCORE -A -D -V -T 7 -C $CFG -w -q tvaldm -m f \
-t $BEAMPRUNE $ARCPRUNE \
-s $LMSCALE -p $INSPEN -l $WORKDIR/lattices \
-L $SRC/${TESTSET}/$PASS/lattices \
-S ${WORKDIR}/flists/${TESTSET}.scp $DICT >& $WORKDIR/LOG

EOF

chmod u+x $WORKDIR/run.bat
qsub -cwd -o $WORKDIR/run.LOG -j y $WORKDIR/run.bat

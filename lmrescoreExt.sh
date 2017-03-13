#!/bin/tcsh
#$ -S /bin/tcsh

# default parameters
set LMSCALE=12.0
set INSPEN=-10.0
set OUTPASS=rescore
set LMMODEL=hybrid

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
 if ( "$argv[1]" == "-LMMODEL" )  then
    set CHANGED
    shift argv
    set LMMODEL = $argv[1]
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


if ( $LMMODEL == "plp" ) then
    set LMSCALE=16.0
else if (( $LMMODEL == "tandem" ) || ( $LMMODEL == "tandem-sat" ))then
    set LMSCALE=12.0
else if ( $LMMODEL == "hybrid" ) then
    set LMSCALE=12.0
else if ( $LMMODEL == "grph-plp" ) then
    set LMSCALE=12.0
else if ( $LMMODEL == "grph-tandem" ) then
    set LMSCALE=12.0
else if ( $LMMODEL == "grph-hybrid" ) then
    set LMSCALE=12.0
else
    echo "Unknown system kind: $SYSTEM"
    exit 0
endif

if (( $#argv != 6)) then
   echo "usage: `basename $0` [-INSPEN -10.0] [-LMSCALE 12.0] [-OUTPASS rescore] TESTSET SRC PASS LM TGT GENLAT[TRUE|FALSE]"
   exit 0
endif

set TESTSET = $1
set SRC     = $2
set PASS    = $3
set TGLM    = $4
set TGT     = $5

# cache the command so know what's run
if (! -d CMDs/$TGT/$TESTSET ) mkdir -p CMDs/$TGT/$TESTSET
set TRAINSET=lmrescore
echo "------------------------------------" >> CMDs/$TGT/$TESTSET/${TRAINSET}.cmds
echo "$0 $ALLARGS" >> CMDs/${TGT}/$TESTSET/${TRAINSET}.cmds
echo "------------------------------------" >> CMDs/$TGT/$TESTSET/${TRAINSET}.cmds

if ( ! -d $SRC/${TESTSET}/$PASS/lattices ) then
    echo "Lattice directory missing: $SRC/${TESTSET}/$PASS/lattices"
    exit 0
endif

set DICT      = lib/dicts/train.lv.dct
set HLRESCORE = base/bin/HLRescore
set CFG       = lib/cfgs/hlrescore.cfg

if (! -d $SRC/$TESTSET) then 
  echo "Lattice directory $SRC/$TESTSET doesn't exist"
  exit 0;
endif

set WORKDIR = $TGT/${TESTSET}/$OUTPASS
if (! -d ${WORKDIR} ) then
    mkdir -p ${WORKDIR}/flists
else 
    echo "Directory exists: $WORKDIR"
    echo "Delete to run"
    exit 0
endif

if ( $6 == "TRUE" ) then
  set LATOPTS=( -w -l ${WORKDIR}/lattices)
  mkdir -p ${WORKDIR}/lattices
else 
  set LATOPTS=
endif

cat > $WORKDIR/run.bat <<EOF 
#!/bin/bash

#\$ -S /bin/bash

# some lattices may not exist - generate the list of lattices to avoid HLRescore crashing
 ./scripts/lats2scp $SRC/${TESTSET}/$PASS/lattices lib/flists/${TESTSET}.scp ${WORKDIR}/flists/${TESTSET}.scp

# some lattices may not exist - generate the list of lattices to avoid HLRescore crashing
$HLRESCORE -A -D -V -T 7 -q tvalr -C $CFG  -n $TGLM $LATOPTS \
-s $LMSCALE -p $INSPEN -t 200.0 1000.0 -u 200.0 1000.0 \
-L $SRC/${TESTSET}/$PASS/lattices -f -i ${WORKDIR}/rescore.mlf \
-S ${WORKDIR}/flists/${TESTSET}.scp $DICT >& ${WORKDIR}/LOG

EOF

chmod u+x $WORKDIR/run.bat
qsub -cwd -o $WORKDIR/run.LOG -j y $WORKDIR/run.bat




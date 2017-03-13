#!/bin/tcsh
#$ -S /bin/tcsh

set ALLARGS=($*)
set CHANGED
set INMLF = rescore.mlf
if ( $#argv > 1 ) then
while ( $?CHANGED )
  unset CHANGED
  if ( "$argv[1]" == "-CONFTREE" )  then
    set CHANGED
    shift argv
    set CONFTREE = $argv[1]
    shift argv
  endif
  if ( "$argv[1]" == "-CTM" )  then
    set CHANGED
    shift argv
    set INCTM = $argv[1]
    shift argv
  endif
  if ( "$argv[1]" == "-MLF" )  then
    set CHANGED
    shift argv
    set INMLF = $argv[1]
    shift argv
  endif
end
endif

# Check Number of Args 
if ( $#argv != 3)   then
   echo "Usage: $0 [-CONFTREE tree] [-CTM ctm] srcdir testset pass"
   exit 1
endif

set SRC = $1
set TYPE = $2
set PASS = $3

if (! -d CMDs/$SRC ) mkdir -p CMDs/$SRC
set TRAINSET=score
echo "------------------------------------" >> CMDs/$SRC/${TRAINSET}.cmds
echo "$0 $ALLARGS" >> CMDs/$SRC/${TRAINSET}.cmds
echo "------------------------------------" >> CMDs/$SRC/${TRAINSET}.cmds

set FPASS=`echo $SRC/$PASS | sed 's/\//_/g'`
set OUTSCOREDIR=scoring/sclite/$TYPE

if (! -d $OUTSCOREDIR/work/$FPASS ) mkdir -p $OUTSCOREDIR/work/$FPASS

set MLF=$OUTSCOREDIR/${FPASS}.mlf
set CTM=$OUTSCOREDIR/${FPASS}.ctm
set LOG=$OUTSCOREDIR/${FPASS}.LOG
set workdir=$OUTSCOREDIR/work/$FPASS

if (-f $LOG) \rm $LOG

setenv SCORINGDIR /usr/local/teach/MLSALT11/Speech/scoring
set SCOREOPT=(dtl sgml)
    
if ( $?INCTM ) then
   cp $INCTM $CTM
   /usr/local/teach/MLSALT11/Speech/NIST/sctk-2.4.8/bin/sclite -r ${SCORINGDIR}/lib/stms/${TYPE}.stm stm -h $CTM ctm -D -o all ${SCOREOPT} | tail
else

# First collect all the MLFs together, or normalise the specified MLF
# note - repeated normalisation is not an issue
if ( -f ${workdir}/${FPASS}.orig ) then 
    rm ${workdir}/${FPASS}.orig
endif
foreach i (`cat lib/testlists/${TYPE}.lst`)
      cat $SRC/$i/$PASS/${INMLF}  | sed 's/\.lab/\.rec/g' | egrep -v '<s>' | egrep -v '</s>'  >> ${workdir}/${FPASS}.orig
end

./base/bin/HLEd -A -D -V -l '*' -C base/lib/cfgs/hled.cfg -i $MLF /dev/null ${workdir}/${FPASS}.orig > $LOG

if ( $?CONFTREE ) then
    mv $MLF ${MLF}.orig
    ./base/conftools/smoothtree-mlf.pl $CONFTREE ${MLF}.orig > $MLF
endif

# Having generated the MLF this is the stage to use the scoring config if specified
base/stools/scoremlf $TYPE ${TYPE}_${FPASS} ${MLF} >& scoring/sclite/${TYPE}_${FPASS}.LOG

endif

\rm filterctm.LOG
egrep Avg scoring/sclite/${TYPE}_${FPASS}*sys

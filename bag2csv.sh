#!/bin/bash
function bagger {
  echo Processing $1
  local FILENAME=$1
  local BAGNAME=${FILENAME%.*}
  mkdir -p $(pwd)/$BAGNAME
  for TOPIC in `rostopic list -b $1`; do
    echo Starting ${BAGNAME}-${TOPIC:1}
    rostopic echo -p -b $1 $TOPIC > $(pwd)/$BAGNAME/${BAGNAME}${TOPIC//\//_}.csv ;
    echo Done ${BAGNAME}-${TOPIC:1}
  done
  echo Done extracting data from $1 to CSVs to $(pwd)/$BAGNAME/.
}

if [ $# -gt 0 ]
then
  for BAGS in $@
  do
    bagger $BAGS
  done
else
  BAGFILES=(*.bag)
  if [ ${#BAGFILES[@]} -gt 0 ] && [ "${BAGFILES[0]}" != "*.bag" ]
  then
    echo Found ${BAGFILES[@]}
    for BAGS in ${BAGFILES[@]}
    do
      bagger $BAGS
    done
  else
    echo "No rosbags provided."
  fi
fi

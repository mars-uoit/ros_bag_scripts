#!/bin/bash

# Software License Agreement (New BSD)
# ---------------
# Copyright © 2014 Tony Baltovski All rights reserved.

# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright notice, this
#   list of conditions and the following disclaimer in the documentation and/or
#   other materials provided with the distribution.
# * Neither the name of “University of Ontario Institute of Technology” nor the
#   names of its contributors may be used to endorse or promote products derived
#   from this software without specific priorwritten permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS” AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

function unbagger {
  echo Processing $1
  local FILENAME=$1
  local BAGNAME=${FILENAME%.*}
  mkdir -p $(pwd)/$BAGNAME
  for TOPIC in `rostopic list -b $1`; do
    echo Starting ${BAGNAME}-${TOPIC:1}
    rostopic echo -p -b $1 $TOPIC > $(pwd)/$BAGNAME/${BAGNAME}${TOPIC//\//_}.csv &
    echo Done ${BAGNAME}-${TOPIC:1}
  done
  wait
  echo Done extracting data from $1 to CSVs to $(pwd)/$BAGNAME/.
}

if [ $# -gt 0 ]
then
  for BAGS in $@
  do
    unbagger $BAGS
  done
else
  BAGFILES=(*.bag)
  if [ ${#BAGFILES[@]} -gt 0 ] && [ "${BAGFILES[0]}" != "*.bag" ]
  then
    echo Found ${BAGFILES[@]}
    for BAGS in ${BAGFILES[@]}
    do
      unbagger $BAGS
    done
  else
    echo "No rosbags provided."
  fi
fi

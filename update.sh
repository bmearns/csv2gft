#!/bin/bash
#
# Update Fusion Table with limabean project data and record in change table
#
# Ben Mearns 

# Global Declarations
declare -rx DATESTRING=$(date +%m%d%y)
declare -rx DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
declare -rx DATAFILE=$DIR/data/$DATESTRING.csv
declare -rx CHANGETABLE_ID=1HAvac1Iy4LsNqBkezgVJX04hwcKvWh4sGpNo7u8
declare -rx DATATABLE_ID=1poH7Gdu_7R3NiCA_EonEMwyf90KY_zrujddYCX4

# Need to be in ftapi to run Fusion Table executables
cd $DIR/ftapi/

# Sanity Checks
function checkChanges(){ ./ftsql.sh "SELECT * from $CHANGETABLE_ID where change = $DATESTRING" ; }

if test ! -e "$DATAFILE" ; then
      printf "Today's data file $DATAFILE does not exist. \n"
      exit
fi

if [ "$(checkChanges)" != "change" ] ; then
      printf "Changes for today have already been commited. \n";
      exit
fi

# Update Fusion Table with limabean project data and record in change table
cat $DATAFILE | ./ftupload.sh $DATATABLE_ID
./ftsql.sh "INSERT INTO $CHANGETABLE_ID (change) VALUES ('$DATESTRING')"
echo "Updates sent to Fusion Tables successfully"

# Cleanup
exit 0  # all is well

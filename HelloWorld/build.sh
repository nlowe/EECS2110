#!/usr/bin/bash
# Save the old include var if Set
OLD_INCLUDE=$INCLUDE

JWASM=$(which jwasm)
SOURCE="program.asm"
OUTPUT="program.EXE"
INCLUDE="../lib/"

if [ ! -x "$JWASM" ]; then
  echo "jwasm could not be found"
  exit -1
fi

export INCLUDE

$JWASM -nologo -mz $SOURCE -Fo $OUTPUT
rc=$?

export INCLUDE=$OLD_INCLUDE

if [[ $rc != 0 ]]; then
  echo "Build failed with exit code $rc!"
  exit $rc
fi

DOSBOX=$(which dosbox)

if [ ! -x "$DOSBOX" ]; then
  echo "dosbox could not be found. Cannot test program"
  exit -3
fi

$DOSBOX program.EXE

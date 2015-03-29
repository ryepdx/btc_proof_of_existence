#!/bin/bash

function b58encode () {
    # Swiped from http://www.commandlinefu.com/commands/view/13182/bitcoin-brainwallet-base58-encoder
    local b58_lookup_table=({1..9} {A..H} {J..N} {P..Z} {a..k} {m..z});
    bc<<<"obase=58;ibase=16;${1^^}"|(read -a s; for b58_index in "${s[@]}" ; do printf %s ${b58_lookup_table[ 10#"$b58_index" ]}; done); 
}

RIPE=`echo -n 00 && rhash --sha256 $1 | cut -d' ' -f1 | xxd -r -p | rhash --ripemd160 - | cut -d' ' -f1`
CHECKSUM=`echo -n $RIPE | xxd -r -p | rhash --sha256 - | cut -d' ' -f1 | xxd -r -p | rhash --sha256 - | cut -c1-8`
echo -n 1 && b58encode $RIPE$CHECKSUM && echo

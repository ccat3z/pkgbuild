#! /bin/bash

set -e -o pipefail

BINARY=$1

hex () {
    printf "0x%X" "$1"
}

echo "Patch $BINARY"

section_dynstr_offset=0x$(readelf -S "$BINARY" | grep ".dynstr" | awk '{print $6}')
section_version_r_offset=0x$(readelf -S "$BINARY" | grep ".gnu.version_r" | awk '{print $6}')

# typedef struct {
#     Elfxx_Half    vn_version;
#     Elfxx_Half    vn_cnt;
#     Elfxx_Word    vn_file;
#     Elfxx_Word    vn_aux;
#     Elfxx_Word    vn_next;
# } Elfxx_Verneed;
ncurses_verneed_offset=$(hex $(("$section_version_r_offset" + "$(readelf -V "$BINARY" | sed -n 's/^ *\(0x[0-9a-f]*\): .*File: libtinfo.so.[56].*$/\1/p')")))
# Elfxx_Verneed.vn_file
ncurses_file_offset=$(hex $(("$section_dynstr_offset" + "0x$(xxd -s $(("$ncurses_verneed_offset" + 4)) -l 4 -e "$BINARY" | awk '{print $2}')")))

# typedef struct {
#     Elfxx_Word    vna_hash;
#     Elfxx_Half    vna_flags;
#     Elfxx_Half    vna_other;
#     Elfxx_Word    vna_name;
#     Elfxx_Word    vna_next;
# } Elfxx_Vernaux;
ncurses_verdaux_offset=$(hex $(("$section_version_r_offset" + "$(readelf -V "$BINARY" | sed -n 's/^ *\(0x[0-9a-f]*\): *Name: NCURSES6\{0,1\}_TINFO_5.0.19991023.*$/\1/p')")))
# Elfxx_Vernaux.vn_name
ncurses_name_offset=$(hex $(("$section_dynstr_offset" + "0x$(xxd -s $(("$ncurses_verdaux_offset" + 8)) -l 4 -e "$BINARY" | awk '{print $2}')")))

printf 'libtinfo.so.5\x00' | dd conv=notrunc of="$BINARY" bs=1 seek=$(("$ncurses_file_offset")) 2> /dev/null

printf 'NCURSES_TINFO_5.0.19991023\x00\x00' | dd conv=notrunc of="$BINARY" bs=1 seek=$(("$ncurses_name_offset")) 2> /dev/null
# ElfHash("NCURSES_TINFO_5.0.19991023") = 0x02a6c531
printf '\x13\xc5\xa6\x02' | dd conv=notrunc of="$BINARY" bs=1 seek=$(("$ncurses_verdaux_offset")) 2> /dev/null

#!/bin/sh

 (( $# == 0 )) && {
   echo "*** Usage: $0 wcoss|dell|cray|theia|intel_general|gnu_general [debug|build] [[local]install[only]]"
   exit 1
 }

 sys=${1,,}
 [[ $sys == wcoss || $sys == dell || $sys == cray ||\
    $sys == theia || $sys == intel_general || $sys == gnu_general ]] || {
   echo "*** Usage: $0 wcoss|dell|cray|theia|intel_general|gnu_general [debug|build] [[local]install[only]]"
   exit 1
 }
 debg=false
 inst=false
 skip=false
 local=false
 (( $# > 1 )) && {
   [[ ${2,,} == build ]] && debg=false
   [[ ${2,,} == debug ]] && debg=true
   [[ ${2,,} == install ]] && inst=true
   [[ ${2,,} == localinstall ]] && { local=true; inst=true; }
   [[ ${2,,} == installonly ]] && { inst=true; skip=true; }
   [[ ${2,,} == localinstallonly ]] && { local=true; inst=true; skip=true; }
 }
 (( $# > 2 )) && {
   [[ ${3,,} == build ]] && debg=false
   [[ ${3,,} == debug ]] && debg=true
   [[ ${3,,} == install ]] && inst=true
   [[ ${3,,} == localinstall ]] && { local=true; inst=true; }
   [[ ${3,,} == installonly ]] && { inst=true; skip=true; }
   [[ ${3,,} == localinstallonly ]] && { local=true; inst=true; skip=true; }
 }
 if [[ ${sys} == "intel_general" ]]; then
   sys6=${sys:6}
   source ./Conf/W3nco_${sys:0:5}_${sys6^}.sh
 elif [[ ${sys} == "gnu_general" ]]; then
   sys4=${sys:4}
   source ./Conf/W3nco_${sys:0:3}_${sys4^}.sh
 else
   source ./Conf/W3nco_intel_${sys^}.sh
 fi
 [[ -z $W3NCO_VER || -z $W3NCO_LIB4 ]] && {
   echo "??? W3NCO: module/environment not set."
   exit 1
 }

 source ./Conf/Collect_info.sh
 source ./Conf/Gen_cfunction.sh

set -x
 w3ncoLib4=$(basename ${W3NCO_LIB4})
 w3ncoLib8=$(basename ${W3NCO_LIB8})
 w3ncoLibd=$(basename ${W3NCO_LIBd})

#################
 cd src
#################

 $skip || {
#-------------------------------------------------------------------
# Start building libraries
#
 echo
 echo "   ... build default (i4/r4) w3nco library ..."
 echo
   make clean LIB=$w3ncoLib4
   FFLAGS4="$I4R4 $FFLAGS"
   collect_info w3nco 4 OneLine4 LibInfo4
   w3ncoInfo4=w3nco_info_and_log4.txt
   $debg && make debug FFLAGS="$FFLAGS4" LIB=$w3ncoLib4 &> $w3ncoInfo4 \
         || make build FFLAGS="$FFLAGS4" LIB=$w3ncoLib4 &> $w3ncoInfo4
   make message MSGSRC="$(gen_cfunction $w3ncoInfo4 OneLine4 LibInfo4)" \
                LIB=$w3ncoLib4

 echo
 echo "   ... build default (i4/r8) w3nco library ..."
 echo
   make clean LIB=$w3ncoLib8
   FFLAGS4="$I8R8 $FFLAGS"
   collect_info w3nco 8 OneLine8 LibInfo8
   w3ncoInfo8=w3nco_info_and_log8.txt
   $debg && make debug FFLAGS="$FFLAGS8" LIB=$w3ncoLib8 &> $w3ncoInfo8 \
         || make build FFLAGS="$FFLAGS8" LIB=$w3ncoLib8 &> $w3ncoInfo8
   make message MSGSRC="$(gen_cfunction $w3ncoInfo8 OneLine8 LibInfo8)" \
                LIB=$w3ncoLib8

 echo
 echo "   ... build default (i4/r8) w3nco library ..."
 echo
   make clean LIB=$w3ncoLibd
   FFLAGSd="$I4R8 $FFLAGS"
   collect_info w3nco d OneLined LibInfod
   w3ncoInfod=w3nco_info_and_logd.txt
   $debg && make debug FFLAGS="$FFLAGSd" LIB=$w3ncoLibd &> $w3ncoInfod \
         || make build FFLAGS="$FFLAGSd" LIB=$w3ncoLibd &> $w3ncoInfod
   make message MSGSRC="$(gen_cfunction $w3ncoInfod OneLined LibInfod)" \
                LIB=$w3ncoLibd
 }

 $inst && {
#
#     Install libraries and source files 
#
   $local && {
              LIB_DIR4=..
              LIB_DIR8=..
              LIB_DIRd=..
             } || {
                   LIB_DIR4=$(dirname ${W3NCO_LIB4})
                   LIB_DIR8=$(dirname ${W3NCO_LIB8})
                   LIB_DIRd=$(dirname ${W3NCO_LIBd})
                  }
   [ -d $LIB_DIR4 ] || mkdir -p $LIB_DIR4
   [ -d $LIB_DIR8 ] || mkdir -p $LIB_DIR8
   [ -d $LIB_DIRd ] || mkdir -p $LIB_DIRd
   SRC_DIR=$W3NCO_SRC
   $local && SRC_DIR=
   [ -d $SRC_DIR ] || mkdir -p $SRC_DIR
   make clean LIB=
   make install LIB=$w3ncoLib4 LIB_DIR=$LIB_DIR4 SRC_DIR=
   make install LIB=$w3ncoLib8 LIB_DIR=$LIB_DIR8 SRC_DIR=
   make install LIB=$w3ncoLibd LIB_DIR=$LIB_DIRd SRC_DIR=$SRC_DIR
 }


#!/bin/bash

 : ${THISDIR:=$(dirname $(readlink -f -n ${BASH_SOURCE[0]}))}
 CDIR=$PWD; cd $THISDIR

 source ./Conf/Analyse_args.sh
 source ./Conf/Collect_info.sh
 source ./Conf/Gen_cfunction.sh
 source ./Conf/Reset_version.sh

 if [[ ${sys} == "intel_general" ]]; then
   sys6=${sys:6}
   source ./Conf/W3nco_${sys:0:5}_${sys6^}.sh
   rinst=false
 elif [[ ${sys} == "gnu_general" ]]; then
   sys4=${sys:4}
   source ./Conf/W3nco_${sys:0:3}_${sys4^}.sh
   rinst=false
 else
   source ./Conf/W3nco_intel_${sys^}.sh
 fi
 $CC --version &> /dev/null || {
   echo "??? W3NCO: compilers not set." >&2
   exit 1
 }
 [[ -z ${W3NCO_VER+x} || -z ${W3NCO_LIB4+x} ]] && {
   [[ -z ${libver+x} || -z ${libver} ]] && {
     echo "??? W3NCO: \"libver\" not set." >&2
     exit
   }
   W3NCO_LIB4=lib${libver}_4.a
   W3NCO_LIB8=lib${libver}_8.a
   W3NCO_LIBd=lib${libver}_d.a
   W3NCO_VER=v${libver##*_v}
 }

set -x
 w3ncoLib4=$(basename ${W3NCO_LIB4})
 w3ncoLib8=$(basename ${W3NCO_LIB8})
 w3ncoLibd=$(basename ${W3NCO_LIBd})

#################
 cd src
#################

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
   FFLAGS8="$I8R8 $FFLAGS"
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

 $inst && {
#
#     Install libraries and source files 
#
   $local && {
     instloc=..
     LIB_DIR=$instloc/lib
     [ -d $LIB_DIR ] || { mkdir -p $LIB_DIR; }
     LIB_DIR4=$LIB_DIR
     LIB_DIR8=$LIB_DIR
     LIB_DIRd=$LIB_DIR
     SRC_DIR=
   } || {
     $rinst && {
       LIB_DIR4=$(dirname ${W3NCO_LIB4})
       LIB_DIR8=$(dirname ${W3NCO_LIB8})
       LIB_DIRd=$(dirname ${W3NCO_LIBd})
       SRC_DIR=$W3NCO_SRC
     } || {
       LIB_DIR=$instloc/lib
       LIB_DIR4=$LIB_DIR
       LIB_DIR8=$LIB_DIR
       LIB_DIRd=$LIB_DIR
       SRC_DIR=$instloc/src
       [[ $instloc == .. ]] && SRC_DIR=
     }
     [ -d $LIB_DIR4 ] || mkdir -p $LIB_DIR4
     [ -d $LIB_DIR8 ] || mkdir -p $LIB_DIR8
     [ -d $LIB_DIRd ] || mkdir -p $LIB_DIRd
     [ -z $SRC_DIR ] || { [ -d $SRC_DIR ] || mkdir -p $SRC_DIR; }
   }

   make clean LIB=
   make install LIB=$w3ncoLib4 LIB_DIR=$LIB_DIR4 SRC_DIR=
   make install LIB=$w3ncoLib8 LIB_DIR=$LIB_DIR8 SRC_DIR=
   make install LIB=$w3ncoLibd LIB_DIR=$LIB_DIRd SRC_DIR=$SRC_DIR
 }


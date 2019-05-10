# *** manually set environments (for intel compiler) of w3nco ***

# !!! module environment (*THEIA*) !!!
 module load intel/18.1.163

 ANCHORDIR=..
 export COMP=ips
 export W3NCO_VER=v2.0.6
 export W3NCO_SRC=
 export W3NCO_LIB4=$ANCHORDIR/libw3nco_${W3NCO_VER}_4.a
 export W3NCO_LIB8=$ANCHORDIR/libw3nco_${W3NCO_VER}_8.a
 export W3NCO_LIBd=$ANCHORDIR/libw3nco_${W3NCO_VER}_d.a

 export CC=icc
 export FC=ifort
 export CPP=cpp
 export OMPCC="$CC -qopenmp"
 export OMPFC="$FC -qopenmp"
 export MPICC=mpiicc
 export MPIFC=mpiifort

 export DEBUG="-g -O0"
 export CFLAGS="-O3 -fPIC"
 export FFLAGS="-O3 -fPIC"
 export FPPCPP="-cpp"
 export FREEFORM="-free"
 export CPPFLAGS="-P -traditional-cpp"
 export MPICFLAGS="-O3 -fPIC"
 export MPIFFLAGS="-O3 -fPIC"
 export MODPATH="-module "
 export I4R4="-integer-size 32 -real-size 32"
 export I4R8="-integer-size 32 -real-size 64"
 export I8R8="-integer-size 64 -real-size 64"

 export CPPDEFS=""
 export CFLAGSDEFS="-DUNDERSCORE -DLINUX"
 export FFLAGSDEFS=""

 export USECC="YES"
 export USEFC="YES"
 export DEPS=""

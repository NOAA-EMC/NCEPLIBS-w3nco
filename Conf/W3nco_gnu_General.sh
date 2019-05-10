# *** manually set environments (for gnu compiler) of w3nco ***

# !!! module environment (*THEIA*) !!!
 module load gcc/6.2.0

 ANCHORDIR=..
 export COMP=gnu
 export W3NCO_VER=v2.0.6
 export W3NCO_SRC=
 export W3NCO_LIB4=$ANCHORDIR/libw3nco_${W3NCO_VER}_4.a
 export W3NCO_LIB8=$ANCHORDIR/libw3nco_${W3NCO_VER}_8.a
 export W3NCO_LIBd=$ANCHORDIR/libw3nco_${W3NCO_VER}_d.a

 export CC=gcc
 export FC=gfortran
 export CPP=cpp
 export OMPCC="$CC -fopenmp"
 export OMPFC="$FC -fopenmp"
 export MPICC=mpigcc
 export MPIFC=mpigfortran

 export DEBUG="-g -O0"
 export CFLAGS="-O3 -fPIC"
 export FFLAGS="-O3 -fno-range-check -fPIC"
 export FREEFORM="-ffree-form"
 export FPPCPP="-cpp"
 export CPPFLAGS="-P -traditional-cpp"
 export MPICFLAGS="-O3 -fPIC"
 export MPIFFLAGS="-O3 -fPIC"
 export MODPATH="-J"
 export I4R4=""
 export I4R8="-fdefault-real-8"
 export I8R8="-fdefault-integer-8 -fdefault-real-8"

 export CPPDEFS=""
 export CFLAGSDEFS="-DUNDERSCORE -DLINUX"
 export FFLAGSDEFS=""

 export USECC="YES"
 export USEFC="YES"
 export DEPS=""

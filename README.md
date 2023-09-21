# W3NCO

This library contains Fortran 90 decoder/encoder routines for GRIB
edition 1. **This library is deprecated and will not be in the next
release of NCEPLIBS**. All code will be migrated to the
[NCEPLIBS-w3emc](https://github.com/NOAA-EMC/NCEPLIBS-w3emc) library
with full backward compatibility maintained. Only build systems will
have to change as a result of this code move.

This is part of
the [NCEPLIBS](https://github.com/NOAA-EMC/NCEPLIBS) project.

To submit bug reports, feature requests, or other code-related issues including installation and usage questions, please create a [GitHub issue](https://github.com/NOAA-EMC/NCEPLIBS-w3nco/issues). For general NCEPLIBS inquiries, contact [Edward Hartnett](mailto:edward.hartnett@noaa.gov) (secondary point of contact [Alex Richert](mailto:alexander.richert@noaa.gov)).

## Authors

NCEP/EMC developers.

Code manager: Boi Vuong

## Installing
```
Download W3NCO Code from GitHub.com
git clone -b w3nco_v2.2.0 --recursive https://github.com/NOAA-EMC/NCEPLIBS-w3nco.git
cd NCEPLIBS-w3nco
```
#### Create a directory where to build W3NCO library
```
mkdir build
cd build
```
#### Load the following modules 
```
module load intel/18.0.1.163
module load impi/18.0.1
module load cmake/3.16.2
module use -a /usrx/local/nceplibs/dev/NCEPLIBS/modulefiles

export CC=icc
export CXX=icpc
export FC=ifort

If the chosen compiler is not the default compiler on the system,
set the environment variables: export CC=..., export CXX=..., 
export FC=..., before invoking cmake.

Note: Windows systems is not supported at this time.

```
#### Run cmake
```
cmake .. -DCMAKE_INSTALL_PREFIX=path_to_install (where you want to install W3NCO)

If -DCMAKE_INSTALL_PREFIX= is omitted, the libraries will be installed in directory 
install underneath the build directory.

make
make install

```

## Disclaimer

The United States Department of Commerce (DOC) GitHub project code is
provided on an "as is" basis and the user assumes responsibility for
its use. DOC has relinquished control of the information and no longer
has responsibility to protect the integrity, confidentiality, or
availability of the information. Any claims against the Department of
Commerce stemming from the use of its GitHub project will be governed
by all applicable Federal law. Any reference to specific commercial
products, processes, or services by service mark, trademark,
manufacturer, or otherwise, does not constitute or imply their
endorsement, recommendation or favoring by the Department of
Commerce. The Department of Commerce seal and logo, or the seal and
logo of a DOC bureau, shall not be used in any manner to imply
endorsement of any commercial product or activity by DOC or the United
States Government.


# actually prefer using 3.18 to have nice lapack imported target
cmake_minimum_required(VERSION 3.13)

#
# Allow find_package() to use <PackageName>_ROOT variables,
# either cmake variable or environment variables
# see https://cmake.org/cmake/help/latest/policy/CMP0074.html
#
if(NOT CMAKE_VERSION VERSION_LESS 3.12)
  cmake_policy(SET CMP0074 NEW)
endif()

project(MOLGW
  LANGUAGES C CXX Fortran
  VERSION 2.5
  HOMEPAGE_URL https://github.com/bruneval/molgw
  DESCRIPTION "Many-body perturbation theory for atoms, molecules, and clusters")

# default local cmake macro repository
list(INSERT CMAKE_MODULE_PATH 0 "${CMAKE_CURRENT_SOURCE_DIR}/cmake")


#
# Enforce user to use a build directory outside of source tree
#
if (${MOLGW_SOURCE_DIR} STREQUAL ${MOLGW_BINARY_DIR})
  message(FATAL_ERROR "In-place build not allowed! Please use a separate build directory.")
endif ()

#
# Set default compile optimization flag
#
set(MOLGW_BUILD_TYPE "Release" CACHE STRING
    "Optimization flags: set to Debug, Release, RelWithDebInfo, or MinSizeRel")

if (NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE "${MOLGW_BUILD_TYPE}" CACHE INTERNAL "" FORCE)
  # Set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
    "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif ()

#
# Export compile command to json (for editors like emacs, clion, etc...)
#
set(CMAKE_EXPORT_COMPILE_COMMANDS on)


################################################
# checking for optional external dependencies :
# - MPI
# - Scalapack (MKL or Netlib)
# - Libxc
# - libint
# - python
#
# For each external dependency, you can instruct
# cmake to search for a particular directory
# using either env variable or cmake variable
# <PackageName>_ROOT
################################################

# we will use MODULE mode (via pkg-config) of package detection
find_package(PkgConfig REQUIRED)

#
# MPI
#
set(MPI_DETERMINE_LIBRARY_VERSION TRUE)
find_package(MPI)
if(MPI_FOUND)
  add_compile_definitions(HAVE_MPI)
endif()

# determine mpi vendor (MPI_VENDOR)
# valid values are : OpenMPI, MPICH or IntelMPI
include(get_mpi_vendor)
get_mpi_vendor()

#
# OpenMP
#
find_package(OpenMP)

#
# SCALAPACK : NETLIB or MKL
#
# Important notes regarding MKL:
#
# USE_MKL_SCALAPACK : default value FALSE.
# If USE_MKL_SCALAPACK is TRUE then enable scalapack/mkl
#
# User must provide env variable MKL_ROOT if SCALAPACK/MKL
# is wanted.
#
# Other variables of interest that are used to initialize
# MKL_BLAS_FLAVOR_DEFAULT and MKL_SCALAPACK_FLAVOR_DEFAULT
# - MKL_XX_BIT (32bit or 64bit)
# - MKL_THREADING_TYPE (omp or seq)
#
# User can override directly MKL_BLAS_FLAVOR and MKL_SCALAPACK_FLAVOR
#
option(USE_MKL_SCALAPACK "Enable SCALAPACK from MKL" FALSE)

if (NOT USE_MKL_SCALAPACK)

  #
  # SCALAPACK/Netlib
  #

  # first try the MODULE mode (using pkg-config)
  # if not found try CONFIG mode
  # output: target library scalapack

  # Notes:
  # default scalapack library names are scalapack,
  # scalapack-openmpi and scalapack-mpich
  # e.g. on Ubuntu scalapack possible names are scalapack-openmpi,
  # scalapack-mpich
  #
  # if your scalapack has a different name, you can set variable
  # scalapack_name on the cmake configure command line,
  # and it will be check first in pkg_search_modules

  pkg_search_module(ScalapackPkg QUIET IMPORTED_TARGET ${scalapack_name} scalapack scalapack-openmpi scalapack-mpich)

  # On ubuntu 20.04, we must use pkg-config because the cmake config file is ill-formed
  # so here the logic is to first try to detect netlib/scalapack throught pkg-config
  # if not found, then try with cmake-config
  set(scalapack_found_using_pkg_config FALSE)
  set(scalapack_found_using_cmake_target FALSE)

  if(ScalapackPkg_FOUND)

    message("scalapack/netlib found via pkg-config")
    set(scalapack_FOUND TRUE)
    set(scalapack_found_using_pkg_config TRUE)
    add_library(scalapack ALIAS PkgConfig::ScalapackPkg)
    set(USING_SCALAPACK_NETLIB TRUE)

  else(ScalapackPkg_FOUND)

    message("scalapack/netlib not found via pkg-config")

    # if we are here, it means scalapack/netlib was not found by the MODULE mode
    # let try CONFIG mode
    find_package(scalapack CONFIG)
    if(scalapack_FOUND)
      message("scalapack/netlib found via cmake config")
      set(scalapack_found_using_cmake_target TRUE)
    else()
      message("scalapack/netlib not found. Please adjust variable scalapack_DIR / scalapack_ROOT")
    endif()

  endif(ScalapackPkg_FOUND)

  if(scalapack_FOUND)
    add_compile_definitions(HAVE_SCALAPACK)
  endif()

else()

  #
  # SCALAPACK / MKL
  #
  find_package(MKL)

  if(MKL_FOUND)

    #
    # check if user set MKL_SCALAPACK_FLAVOR / MKL_BLAS_FLAVOR
    #

    if (NOT DEFINED MKL_SCALAPACK_FLAVOR)
      set(MKL_SCALAPACK_FLAVOR "${MKL_SCALAPACK_FLAVOR_DEFAULT}" CACHE STRING "MKL_SCALAPACK_FLAVOR, default : ${MKL_SCALAPACK_FLAVOR_DEFAULT}")
    endif()

    # list of valid value for MKL_SCALAPACK_FLAVOR
    # used to cross-check that MKL_SCALAPACK_FLAVOR has a valid value
    set_property(CACHE MKL_SCALAPACK_FLAVOR PROPERTY
      STRINGS
      scalapack_mpich_intel_32bit_seq_st
      scalapack_ompi_intel_32bit_seq_st
      scalapack_mpich_intel_32bit_omp_st
      scalapack_ompi_intel_32bit_omp_st
      scalapack_mpich_intel_32bit_tbb_st
      scalapack_ompi_intel_32bit_tbb_st
      scalapack_mpich_intel_64bit_seq_st
      scalapack_ompi_intel_64bit_seq_st
      scalapack_mpich_intel_64bit_omp_st
      scalapack_ompi_intel_64bit_omp_st
      scalapack_mpich_intel_64bit_tbb_st
      scalapack_ompi_intel_64bit_tbb_st
      scalapack_mpich_intel_32bit_seq_dyn
      scalapack_ompi_intel_32bit_seq_dyn
      scalapack_mpich_intel_32bit_omp_dyn
      scalapack_ompi_intel_32bit_omp_dyn
      scalapack_mpich_intel_32bit_tbb_dyn
      scalapack_ompi_intel_32bit_tbb_dyn
      scalapack_mpich_intel_64bit_seq_dyn
      scalapack_ompi_intel_64bit_seq_dyn
      scalapack_mpich_intel_64bit_omp_dyn
      scalapack_ompi_intel_64bit_omp_dyn
      scalapack_mpich_intel_64bit_tbb_dyn
      scalapack_ompi_intel_64bit_tbb_dyn)

    # cross-check that mkl/scalapack target actually exists
    if(TARGET mkl::${MKL_SCALAPACK_FLAVOR})
      set(MKL_SCALAPACK_FLAVOR_FOUND TRUE)
    else()
      set(MKL_SCALAPACK_FLAVOR_FOUND FALSE)
      message(FATAL_ERROR "Warning: MKL_SCALAPACK_FLAVOR = ${MKL_SCALAPACK_FLAVOR} not found")
    endif()

    # set MKL_BLAS_FLAVOR according to MKL_SCALAPACK_FLAVOR
    if (NOT DEFINED MKL_BLAS_FLAVOR)
      set(MKL_BLAS_FLAVOR "${MKL_BLAS_FLAVOR_DEFAULT}" CACHE STRING "MKL_BLAS_FLAVOR, default : ${MKL_BLAS_FLAVOR_DEFAULT}")
    endif()

    # list of valid value for MKL_SCALAPACK_FLAVOR
    set_property(CACHE MKL_BLAS_FLAVOR PROPERTY
      STRINGS
      mkl_intel_32bit_seq_st
      mkl_intel_32bit_omp_st
      mkl_intel_32bit_tbb_st
      mkl_gf_32bit_seq_st
      mkl_gf_32bit_omp_st
      mkl_gf_32bit_tbb_st
      mkl_intel_64bit_seq_st
      mkl_intel_64bit_omp_st
      mkl_intel_64bit_tbb_st
      mkl_gf_64bit_seq_st
      mkl_gf_64bit_omp_st
      mkl_gf_64bit_tbb_st
      mkl_intel_32bit_seq_dyn
      mkl_intel_32bit_omp_dyn
      mkl_intel_32bit_tbb_dyn
      mkl_gf_32bit_seq_dyn
      mkl_gf_32bit_omp_dyn
      mkl_gf_32bit_tbb_dyn
      mkl_intel_64bit_seq_dyn
      mkl_intel_64bit_omp_dyn
      mkl_intel_64bit_tbb_dyn
      mkl_gf_64bit_seq_dyn
      mkl_gf_64bit_omp_dyn
      mkl_gf_64bit_tbb_dyn)

    # cross-check that mkl/scalapack target actually exists
    if(TARGET mkl::${MKL_BLAS_FLAVOR})
      set(MKL_BLAS_FLAVOR_FOUND TRUE)
    else()
      set(MKL_BLAS_FLAVOR_FOUND FALSE)
      message("Warning: MKL_BLAS_FLAVOR = ${MKL_BLAS_FLAVOR} not found")
    endif()

    if(SCALAPACK_MKL_FOUND)
      add_compile_definitions(HAVE_SCALAPACK)
      add_compile_definitions(HAVE_MKL)
    endif()

    # get properties for print summary (see below)
    get_target_property(MKL_BLAS_HEADERS mkl::${MKL_BLAS_FLAVOR} INTERFACE_INCLUDE_DIRECTORIES)
    get_target_property(MKL_BLAS_LIBRARIES mkl::${MKL_BLAS_FLAVOR} INTERFACE_LINK_LIBRARIES)

    get_target_property(MKL_SCALAPACK_HEADERS mkl::${MKL_SCALAPACK_FLAVOR} INTERFACE_INCLUDE_DIRECTORIES)
    get_target_property(MKL_SCALAPACK_LIBRARIES mkl::${MKL_SCALAPACK_FLAVOR} INTERFACE_LINK_LIBRARIES)

    # usually MKL_SCALAPACK_HEADERS is empty
    if (${MKL_SCALAPACK_HEADERS} STREQUAL "MKL_SCALAPACK_HEADERS-NOTFOUND")
      set(MKL_SCALAPACK_HEADERS "")
    endif()

  else()

    message("MKL not found ! Please provide environment variable MKL_ROOT.")

  endif()

endif()

#
# Libxc
# 1. prefer using pkg-config,
# 2. use cmake target file if not found with pkg-config
#
pkg_check_modules(Libxc QUIET IMPORTED_TARGET libxc)

if(Libxc_FOUND)
  message("Libxc found via pkg-config")
  set(Libxc_FOUND TRUE)
  #set(Libxc_VERSION ${LibxcPkg_VERSION})
  #set(Libxc_INCLUDE_DIRS ${LibxcPkg_INCLUDE_DIRS})
  add_library(Libxc::xc ALIAS PkgConfig::Libxc)
else()
  find_package(Libxc REQUIRED)
  message("Libxc found via cmake target")
endif()

if(Libxc_FOUND)
  add_compile_definitions(HAVE_LIBXC)
endif()

#
# Libint2
#
find_package(Libint2)
if(Libint2_FOUND)
  if(HAVE_LIBINT_ONEBODY)
    add_compile_definitions(HAVE_LIBINT_ONEBODY)
  endif()
  if(HAVE_LIBINT_GRADIENTS)
    add_compile_definitions(HAVE_LIBINT_GRADIENTS)
  endif()
endif()
#find_package(PkgConfig REQUIRED)
#pkg_check_modules(LIBINT2 QUIET IMPORTED_TARGET libint2)

#
# Python
#
find_package(Python COMPONENTS Interpreter)

#
# TODO : create a config.h with all macros HAVE_MPI, HAVE_SCALAPACK, etc...
#

# Generate config.h
#include(cmake/generate_config_h.cmake)

# make sure config.h is found
#add_compile_options(-I${CMAKE_BINARY_DIR})

#
# generate files basis_path.f90 and git_sha.f90
#
include(cmake/prepare_sourcecode.cmake)

#
# add sources
#
add_subdirectory(src)

#
# build documentation
#
add_subdirectory(docs)

#
# Test : TODO
#

#
# install
#

# GNU compatibility,
# see https://cmake.org/cmake/help/latest/module/GNUInstallDirs.html
include(GNUInstallDirs)

install(
  TARGETS
  molgw)

install(
  FILES
  utils/run_molgw.py
  utils/scf_status.py
  DESTINATION ${CMAKE_INSTALL_BINDIR})

install(
  DIRECTORY
  basis
  DESTINATION ${CMAKE_INSTALL_BINDIR})

#
# create source archive using CPACK
# run: `make package_source` to obtain archive
#
set(CPACK_SOURCE_IGNORE_FILES "${CMAKE_BINARY_DIR}" "${CMAKE_SOURCE_DIR}/.git" "${CMAKE_SOURCE_DIR}/.gitignore" )
set(CPACK_SOURCE_GENERATOR "TGZ")
set(CPACK_GENERATOR "TGZ")
message(STATUS "CPack generators : ${CPACK_GENERATOR}")
include(CPack)


##################### PRINT CONFIGURE STATUS ######################
message("//===================================================")
message("// ${PROJECT_NAME} build configuration:")
message("// ${PROJECT_NAME} version : ${PROJECT_VERSION}")
message("//===================================================")
message("  CMake version          : ${CMAKE_VERSION}")
if (NOT CMAKE_BUILD_TYPE)
  message("  CMake build type       : NOT SET !")
else()
  message("  CMake build type       : ${CMAKE_BUILD_TYPE}")
endif()
message("  CMake install prefix   : ${CMAKE_INSTALL_PREFIX}")
message("  CMake system processor : ${CMAKE_SYSTEM_PROCESSOR}")
message("  CMake system name (OS) : ${CMAKE_SYSTEM_NAME}")
message("")

message("  Fortran compiler Id  : ${CMAKE_Fortran_COMPILER_ID} ${CMAKE_Fortran_COMPILER_VERSION}")
message("  Fortran compiler exe : ${CMAKE_Fortran_COMPILER}")
message("  Fortran flags        : ${CMAKE_Fortran_FLAGS}")
message("")

message(STATUS "MPI config:")
message("    MPI found            : ${MPI_FOUND}")
message("    MPI version          : ${MPI_VERSION}")
message("    MPI standard version : ${MPI_Fortran_VERSION}")
# note : make sure you correctly your C, C++ and Fortran compiler
# through variable CC, CXX and FC
message("    MPI_VENDOR           : ${MPI_VENDOR}")
message("    MPI library version  : ${MPI_Fortran_LIBRARY_VERSION_STRING}")
message("    MPI fortran compiler : ${MPI_Fortran_COMPILER}")
message("    MPI headers          : ${MPI_Fortran_INCLUDE_DIRS}")
message("    MPI libraries        : ${MPI_Fortran_LIBRARIES}")
#message("    MPI link flags       : ${MPI_Fortran_LINK_FLAGS}")
message("")

message(STATUS "OpenMP config :")
message("    OpenMP found         : ${OPENMP_FOUND}")
message("")

message(STATUS "ScaLapack config:")
message("    USE_MKL_SCALAPACK          : ${USE_MKL_SCALAPACK}")
if(USE_MKL_SCALAPACK)
  message("    SCALAPACK PROVIDER         : MKL")
  message("    MKL found                  : ${MKL_FOUND}")
  message("    MKL_BLAS_FLAVOR            : ${MKL_BLAS_FLAVOR}")
  message("    MKL_BLAS_FLAVOR_FOUND      : ${MKL_BLAS_FLAVOR_FOUND}")
  message("    MKL blas headers           : ${MKL_BLAS_HEADERS}")
  message("    MKL blas libraries         : ${MKL_BLAS_LIBRARIES}")
  message("    MKL_SCALAPACK_FLAVOR       : ${MKL_SCALAPACK_FLAVOR}")
  message("    MKL_SCALAPACK_FLAVOR_FOUND : ${MKL_SCALAPACK_FLAVOR_FOUND}")
  message("    MKL scalapack headers      : ${MKL_SCALAPACK_HEADERS}")
  message("    MKL scalapack libraries    : ${MKL_SCALAPACK_LIBRARIES}")
else()
  message("    SCALAPACK PROVIDER         : NETLIB")
  message("    ScaLapack found            : ${scalapack_FOUND}")
  message("    Scalapack dir              : ${scalapack_DIR}")
  message("    Scalapack found via pkg-config : ${scalapack_found_using_pkg_config}")
  message("    Scalapack found via cmake cfg  : ${scalapack_found_using_cmake_target}")
endif()
message("")

message(STATUS "Libxc config:")
message("    Libxc found        : ${Libxc_FOUND}")
message("    Libxc dir          : ${Libxc_DIR}")
message("    Libxc version      : ${Libxc_VERSION}")
message("    Libxc headers      : ${Libxc_INCLUDE_DIRS}")
message("    Libxc libraries    : ${Libxc_LIBRARIES}")
message("")

message(STATUS "Libint2 config:")
message("    Libint2 found      : ${LIBINT2_FOUND}")
#message("    Libint2 dir        : ${LIBINT2_DIR}")
message("    Libint2 version    : ${LIBINT2_VERSION}")
message("    Libint2 headers    : ${LIBINT2_INCLUDE_DIRS}")
message("    Libint2 libraries  : ${LIBINT2_LIBRARIES}")

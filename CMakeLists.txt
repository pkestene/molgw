# actually prefer using 3.18 to have nice lapack imported target
cmake_minimum_required(VERSION 3.13)

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
# - Scalapack
# - MKL
# - Libxc
# - libint
# - python
#
# For each external dependency, you can instruct
# cmake to search for a particular directory
# using either env variable or cmake variable
# <PackageName>_ROOT
################################################

#
# MPI
#
set(MPI_DETERMINE_LIBRARY_VERSION TRUE)
find_package(MPI)
if(MPI_FOUND)
  add_compile_definitions(HAVE_MPI)
endif()

#
# SCALAPACK
#
find_package(scalapack)
if(scalapack_FOUND)
  add_compile_definitions(HAVE_SCALAPACK)
endif()

#
# MKL
#
find_package(MKL)
if(MKL_FOUND)
  add_compile_definitions(HAVE_MKL)
endif()

#
# Libcx
#
find_package(Libxc REQUIRED)
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
# generate files  and git_sha.f90
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
message("    MPI library version  : ${MPI_Fortran_LIBRARY_VERSION_STRING}")
message("    MPI fortran compiler : ${MPI_Fortran_COMPILER}")
message("")
message(STATUS "ScaLapack config:")
message("    ScaLapack found       : ${scalapack_FOUND}")
message("    Scalapack dir         : ${scalapack_DIR}")
message("")
message(STATUS "MKL config:")
message("    MKL found             : ${scalapack_FOUND}")
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

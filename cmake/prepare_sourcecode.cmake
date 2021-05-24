# NOTE: this file provides the same function as prepare_sourcecode.py

#
# Create the default basis set folder
#

configure_file(
  ${CMAKE_SOURCE_DIR}/src/basis_path.f90.in
  ${CMAKE_SOURCE_DIR}/src/basis_path.f90)

#
# Create the version numbering
#

find_package(Git QUIET)
if (NOT GIT_FOUND)
  set(GIT_SHA_STRING "N/A")
else()
  execute_process(COMMAND ${GIT_EXECUTABLE} rev-parse HEAD
    OUTPUT_VARIABLE GIT_SHA_STRING
    OUTPUT_STRIP_TRAILING_WHITESPACE)
endif()

# create data and time string (as done in prepare_sourcecode.py)
execute_process(COMMAND date "+%d/%m/%y"
  OUTPUT_VARIABLE DATE_STRING
  OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND date "+%H:%M:%S"
  OUTPUT_VARIABLE TIME_STRING
  OUTPUT_STRIP_TRAILING_WHITESPACE)

# generate git_sha.f90
configure_file(
  ${CMAKE_SOURCE_DIR}/src/git_sha.f90.in
  ${CMAKE_SOURCE_DIR}/src/git_sha.f90)

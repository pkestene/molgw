# ================================
# PDF Documentation
# ================================

find_package(LATEX)
find_package(LATEX COMPONENTS PDFLATEX)

if(LATEX_PDFLATEX_FOUND)
add_custom_target(doc
  COMMAND ${CMAKE_COMMAND} -E echo "pdflatex run 1"
  COMMAND ${PDFLATEX_COMPILER} ${CMAKE_CURRENT_SOURCE_DIR}/notes.tex
  COMMAND ${CMAKE_COMMAND} -E echo "pdflatex run 2"
  COMMAND ${PDFLATEX_COMPILER} ${CMAKE_CURRENT_SOURCE_DIR}/notes.tex
  VERBATIM
  COMMENT "Generating pdf documentation with pdflatex")

add_custom_target(clean_doc
  COMMAND ${CMAKE_COMMAND} -E rm -f notes.pdf)

else()

  message(STATUS "pdflatex not available. Please install to build documentation")

endif()

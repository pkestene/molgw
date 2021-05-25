#
# build everything except executable
#
add_library(molgw_shared SHARED "")

#  echo_input_variables.f90
#  echo_input_variables_yaml.f90
#  input_variable_declaration.f90
#  input_variables.f90

target_sources(molgw_shared
  PRIVATE
  boys_function.f90
  bse.f90
  force.f90
  gwgamma_selfenergy.f90
  gw_selfenergy.f90
  linear_response.f90
  m_atoms.f90
  m_basis_set.f90
  m_block_diago.f90
  m_cart_to_pure.f90
  m_ci.f90
  m_definitions.f90
  m_density_tools.f90
  m_dft_grid.f90
  m_dm_analysis.f90
  m_dm_mbpt.f90
  m_ecp.f90
  m_elements.f90
  m_eri_ao_mo.f90
  m_eri_calculate.f90
  m_eri.f90
  m_fourier_quadrature.f90
  m_gaussian.f90
  m_gw_selfenergy_grid.f90
  m_hamiltonian_onebody.f90
  m_hamiltonian_tools.f90
  m_hamiltonian_twobodies.f90
  m_hamiltonian_wrapper.f90
  m_inputparam.f90
  m_io.f90
  m_lbfgs.f90
  m_libint_tools.f90
  m_libxc_tools.f90
  m_linear_algebra.f90
  m_memory.f90
  m_mpi.f90
  m_mpi_tools.f90
  m_multipole.f90
  m_numerical_tools.f90
  mp2.f90
  m_pt_density_matrix.f90
  m_restart.f90
  m_scalapack.f90
  m_scf.f90
  m_scf_loop.f90
  m_selfenergy_evaluation.f90
  m_selfenergy_tools.f90
  m_spectra.f90
  m_spectral_function.f90
  m_string_tools.f90
  m_tddft_fxc.f90
  m_tddft_propagator.f90
  m_tddft_variables.f90
  m_timing.f90
  m_virtual_orbital_space.f90
  m_warning.f90
  pt_selfenergy.f90
  real_spherical_harmonics.f90
  static_polarizability.f90
  lebedev_quadrature.f
  pdbssolver1.f
  libint_onebody.cc
  libint_onebody_grad.cc
  libint_twobody.cc
  libint_twobody_grad.cc
  )
target_compile_options(molgw_shared PRIVATE -cpp)

if(MPI_FOUND)
  target_link_libraries(molgw_shared PUBLIC MPI::MPI_Fortran)
endif()

if(scalapack_mkl_FOUND)
  target_link_libraries(molgw_shared PUBLIC mkl::${MKL_SCALAPACK_FLAVOR})
elseif(scalapack_FOUND)
  target_link_libraries(molgw_shared PUBLIC scalapack)
endif()

if(Libxc_FOUND)
  target_link_libraries(molgw_shared PUBLIC Libxc::xc)
endif()

if(LIBINT2_FOUND)
  target_link_libraries(molgw_shared PUBLIC Libint2::int2)
endif()

#
# add executables
#
add_executable(molgw "")
target_sources(molgw PRIVATE
  molgw.f90)
target_link_libraries(molgw PRIVATE
  molgw_shared)

#add_executable(spectrum "")
#target_sources(spectrum PRIVATE
#  spectrum.f90)
#target_link_libraries(spectrum PRIVATE
#  molgw_shared)


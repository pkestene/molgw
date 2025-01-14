!======================================================================
! The following lines have been generated by a python script: input_variables.py
! Do not alter them directly: they will be overriden sooner or later by the script
! To add a new input variable, modify the script directly
! Generated by input_variables.py on 07 March 2021
!======================================================================

 namelist /molgw/   &
    auto_auxil_fsam,       &
    auto_auxil_lmaxinc,       &
    auxil_basis,       &
    basis,       &
    comment,       &
    ecp_auxil_basis,       &
    ecp_basis,       &
    ecp_elements,       &
    ecp_quality,       &
    ecp_type,       &
    eri3_genuine,       &
    gaussian_type,       &
    incore,       &
    memory_evaluation,       &
    move_nuclei,       &
    nstep,       &
    scf,       &
    tolforce,       &
    eri3_nbatch,       &
    eri3_npcol,       &
    eri3_nprow,       &
    grid_memory,       &
    mpi_nproc_ortho,       &
    scalapack_block_min,       &
    basis_path,       &
    force_energy_qp,       &
    ignore_bigrestart,       &
    print_bigrestart,       &
    print_cube,       &
    print_wfn_files,       &
    print_density_matrix,       &
    print_eri,       &
    print_hartree,       &
    print_multipole,       &
    print_pdos,       &
    print_restart,       &
    print_rho_grid,       &
    print_sigma,       &
    print_spatial_extension,       &
    print_w,       &
    print_wfn,       &
    print_yaml,       &
    read_fchk,       &
    read_restart,       &
    calc_dens_disc,       &
    calc_q_matrix,       &
    calc_spectrum,       &
    print_cube_diff_tddft,       &
    print_cube_rho_tddft,       &
    print_dens_traj,       &
    print_dens_traj_points_set,       &
    print_dens_traj_tddft,       &
    print_line_rho_diff_tddft,       &
    print_line_rho_tddft,       &
    print_tddft_matrices,       &
    print_tddft_restart,       &
    read_tddft_restart,       &
    write_step,       &
    assume_scf_converged,       &
    ci_greens_function,       &
    ci_nstate,       &
    ci_nstate_self,       &
    ci_spin_multiplicity,       &
    ci_type,       &
    dft_core,       &
    ecp_small_basis,       &
    eta,       &
    frozencore,       &
    gwgamma_tddft,       &
    ncoreg,       &
    ncorew,       &
    nexcitation,       &
    nomega_chi_imag,       &
    nomega_sigma,       &
    nomega_sigma_calc,       &
    nstep_dav,       &
    nstep_gw,       &
    nvel_projectile,       &
    nvirtualg,       &
    nvirtualw,       &
    postscf,       &
    postscf_diago_flavor,       &
    pt3_a_diagrams,       &
    pt_density_matrix,       &
    rcut_mbpt,       &
    scissor,       &
    selfenergy_state_max,       &
    selfenergy_state_min,       &
    selfenergy_state_range,       &
    small_basis,       &
    step_sigma,       &
    step_sigma_calc,       &
    stopping,       &
    tda,       &
    tddft_grid_quality,       &
    toldav,       &
    triplet,       &
    use_correlated_density_matrix,       &
    virtual_fno,       &
    excit_dir,       &
    excit_kappa,       &
    excit_name,       &
    excit_omega,       &
    excit_time0,       &
    n_hist,       &
    n_iter,       &
    n_restart_tddft,       &
    ncore_tddft,       &
    pred_corr,       &
    prop_type,       &
    projectile_charge_scaling,       &
    r_disc,       &
    tddft_frozencore,       &
    time_sim,       &
    time_step,       &
    vel_projectile,       &
    alpha_hybrid,       &
    alpha_mixing,       &
    beta_hybrid,       &
    density_matrix_damping,       &
    diis_switch,       &
    gamma_hybrid,       &
    grid_quality,       &
    init_hamiltonian,       &
    integral_quality,       &
    kerker_k0,       &
    level_shifting_energy,       &
    min_overlap,       &
    mixing_scheme,       &
    npulay_hist,       &
    nscf,       &
    partition_scheme,       &
    scf_diago_flavor,       &
    tolscf,       &
    charge,       &
    length_unit,       &
    magnetization,       &
    natom,       &
    nghost,       &
    nspin,       &
    temperature,       &
    xyz_file

!=====

 auto_auxil_fsam=1.5_dp 
 auto_auxil_lmaxinc=1
 auxil_basis=''
 basis=''
 comment=''
 ecp_auxil_basis=''
 ecp_basis=''
 ecp_elements=''
 ecp_quality='high'
 ecp_type=''
 eri3_genuine='no'
 gaussian_type='pure'
 incore='yes'
 memory_evaluation='no'
 move_nuclei='no'
 nstep=50
 scf=''
 tolforce=1e-05_dp 
 eri3_nbatch=1
 eri3_npcol=1
 eri3_nprow=1
 grid_memory=400.0_dp 
 mpi_nproc_ortho=1
 scalapack_block_min=100000
 basis_path=''
 force_energy_qp='no'
 ignore_bigrestart='no'
 print_bigrestart='yes'
 print_cube='no'
 print_wfn_files='no'
 print_density_matrix='no'
 print_eri='no'
 print_hartree='no'
 print_multipole='no'
 print_pdos='no'
 print_restart='yes'
 print_rho_grid='no'
 print_sigma='no'
 print_spatial_extension='no'
 print_w='no'
 print_wfn='no'
 print_yaml='yes'
 read_fchk='no'
 read_restart='no'
 calc_dens_disc='no'
 calc_q_matrix='no'
 calc_spectrum='no'
 print_cube_diff_tddft='no'
 print_cube_rho_tddft='no'
 print_dens_traj='no'
 print_dens_traj_points_set='no'
 print_dens_traj_tddft='no'
 print_line_rho_diff_tddft='no'
 print_line_rho_tddft='no'
 print_tddft_matrices='no'
 print_tddft_restart='yes'
 read_tddft_restart='no'
 write_step=1_dp 
 assume_scf_converged='no'
 ci_greens_function='holes'
 ci_nstate=1
 ci_nstate_self=1
 ci_spin_multiplicity=1
 ci_type='all'
 dft_core=0
 ecp_small_basis=''
 eta=0.001_dp 
 frozencore='no'
 gwgamma_tddft='no'
 ncoreg=0
 ncorew=0
 nexcitation=0
 nomega_chi_imag=0
 nomega_sigma=51
 nomega_sigma_calc=1
 nstep_dav=15
 nstep_gw=1
 nvel_projectile=1
 nvirtualg=100000
 nvirtualw=100000
 postscf=''
 postscf_diago_flavor=' '
 pt3_a_diagrams='yes'
 pt_density_matrix='no'
 rcut_mbpt=1.0_dp 
 scissor=0.0_dp 
 selfenergy_state_max=100000
 selfenergy_state_min=1
 selfenergy_state_range=100000
 small_basis=''
 step_sigma=0.01_dp 
 step_sigma_calc=0.03_dp 
 stopping='no'
 tda='no'
 tddft_grid_quality='high'
 toldav=0.0001_dp 
 triplet='no'
 use_correlated_density_matrix='no'
 virtual_fno='no'
 excit_dir=(/ 1.0_dp , 0.0_dp , 0.0_dp /)
 excit_kappa=2e-05_dp 
 excit_name='NO'
 excit_omega=0.2_dp 
 excit_time0=3.0_dp 
 n_hist=2
 n_iter=2
 n_restart_tddft=50
 ncore_tddft=0
 pred_corr='PC1'
 prop_type='MAG2'
 projectile_charge_scaling=1.0_dp 
 r_disc=200.0_dp 
 tddft_frozencore='no'
 time_sim=10.0_dp 
 time_step=1.0_dp 
 vel_projectile=(/ 0.0_dp , 0.0_dp , 1.0_dp /)
 alpha_hybrid=0.0_dp 
 alpha_mixing=0.7_dp 
 beta_hybrid=0.0_dp 
 density_matrix_damping=0.0_dp 
 diis_switch=0.05_dp 
 gamma_hybrid=1000000.0_dp 
 grid_quality='high'
 init_hamiltonian='guess'
 integral_quality='high'
 kerker_k0=0.0_dp 
 level_shifting_energy=0.0_dp 
 min_overlap=1e-05_dp 
 mixing_scheme='pulay'
 npulay_hist=6
 nscf=50
 partition_scheme='ssf'
 scf_diago_flavor=' '
 tolscf=1e-07_dp 
 charge=0.0_dp 
 length_unit='angstrom'
 magnetization=0.0_dp 
 natom=0
 nghost=0
 nspin=1
 temperature=0.0_dp 
 xyz_file=''


!======================================================================

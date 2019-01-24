!################################################################################
!This file is part of Incompact3d.
!
!Incompact3d
!Copyright (c) 2012 Eric Lamballais and Sylvain Laizet
!eric.lamballais@univ-poitiers.fr / sylvain.laizet@gmail.com
!
!    Incompact3d is free software: you can redistribute it and/or modify
!    it under the terms of the GNU General Public License as published by
!    the Free Software Foundation.
!
!    Incompact3d is distributed in the hope that it will be useful,
!    but WITHOUT ANY WARRANTY; without even the implied warranty of
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!    GNU General Public License for more details.
!
!    You should have received a copy of the GNU General Public License
!    along with the code.  If not, see <http://www.gnu.org/licenses/>.
!-------------------------------------------------------------------------------
!-------------------------------------------------------------------------------
!    We kindly request that you cite Incompact3d in your publications and 
!    presentations. The following citations are suggested:
!
!    1-Laizet S. & Lamballais E., 2009, High-order compact schemes for 
!    incompressible flows: a simple and efficient method with the quasi-spectral 
!    accuracy, J. Comp. Phys.,  vol 228 (15), pp 5989-6015
!
!    2-Laizet S. & Li N., 2011, Incompact3d: a powerful tool to tackle turbulence 
!    problems with up to 0(10^5) computational cores, Int. J. of Numerical 
!    Methods in Fluids, vol 67 (11), pp 1735-1757
!################################################################################

module var

use decomp_2d
USE variables
USE param

! define all major arrays here

real(mytype), save, allocatable, dimension(:,:,:) :: ux1, ux2, ux3, po3, dv3, pp3, pp3corr, pp3star
real(mytype), save, allocatable, dimension(:,:,:) :: uy1, uy2, uy3
real(mytype), save, allocatable, dimension(:,:,:) :: uz1, uz2, uz3
real(mytype), save, allocatable, dimension(:,:,:) :: phi1, phi2, phi3
real(mytype), save, allocatable, dimension(:,:,:) :: gx1, gy1, gz1, hx1, hy1, hz1, phis1, phiss1
real(mytype), save, allocatable, dimension(:,:,:) :: px1, py1, pz1
real(mytype), save, allocatable, dimension(:,:,:) :: ep1
real(mytype), save, allocatable, dimension(:,:,:) :: clx1, clx2, clx3
real(mytype), save, allocatable, dimension(:,:,:) :: cly1, cly2, cly3
real(mytype), save, allocatable, dimension(:,:,:) :: clz1, clz2, clz3

! Additional variables required for LMN
real(mytype), save, allocatable, dimension(:,:,:) :: rho1, rho2, rho3, rhos1, rhoss1, rhos01, &
     rhos001, rho0p3
real(mytype), save, allocatable, dimension(:,:,:) :: drhodt1
real(mytype), save, allocatable, dimension(:,:,:) :: temperature1, temperature2, temperature3, &
     temperatures1, temperaturess1
real(mytype), save, allocatable, dimension(:,:,:) :: massfrac1, massfrac2, massfrac3, massfracs1, &
     massfracss1
real(mytype), save, allocatable, dimension(:,:,:) :: divu3
real(mytype), save, allocatable, dimension(:,:,:) :: mu1, mu2, mu3
real(mytype), save, allocatable, dimension(:,:,:) :: kappa1, kappa2, kappa3
real(mytype), save, allocatable, dimension(:,:,:) :: gamma1, gamma2, gamma3

!arrays for statistic collection
real(mytype), save, allocatable, dimension(:,:,:) :: umean, vmean, wmean
real(mytype), save, allocatable, dimension(:,:,:) :: uumean, uvmean, uwmean
real(mytype), save, allocatable, dimension(:,:,:) :: vvmean, vwmean
real(mytype), save, allocatable, dimension(:,:,:) :: wwmean, tmean
real(mytype), save, allocatable, dimension(:,:,:) :: phimean, phiphimean
#include "newvar-dec.inc"

!arrays for visualization
real(mytype), save, allocatable, dimension(:,:,:) :: uvisu

! define all work arrays here
real(mytype), save, allocatable, dimension(:,:,:) :: ta1,tb1,tc1,td1,&
     te1,tf1,tg1,th1,ti1,di1
real(mytype), save, allocatable, dimension(:,:,:) :: ta2,tb2,tc2,td2,&
     te2,tf2,tg2,th2,ti2,tj2,di2
real(mytype), save, allocatable, dimension(:,:,:) :: ta3,tb3,tc3,td3,&
     te3,tf3,tg3,th3,ti3,di3

! 
integer, save :: nxmsize, nymsize, nzmsize 

real(mytype), save :: pressure0 ! LMN: thermodynamic pressure
real(mytype), save :: divup3norm

contains

  
  subroutine init_variables

    TYPE(DECOMP_INFO), save :: ph  ! decomposition object

    if (nclx==0) then
       nxmsize = xsize(1)
    else
       nxmsize = xsize(1) -1
    endif
    if (ncly==0) then
       nymsize = ysize(2)
    else
       nymsize = ysize(2) -1
    endif
    if (nclz==0) then
       nzmsize = zsize(3)
    else
       nzmsize = zsize(3) -1
    endif
    call decomp_info_init(nxmsize, nymsize, nzmsize, ph)
    

!X PENCILS
    call alloc_x(ux1, opt_global=.true.)
    call alloc_x(uy1, opt_global=.true.)
#ifndef TWOD
    call alloc_x(uz1, opt_global=.true.)
    call alloc_x(pz1, opt_global=.true.)
#else
    allocate (uz1(1,1,1))
    allocate (pz1(1,1,1))
#endif
    call alloc_x(px1, opt_global=.true.)
    call alloc_x(py1, opt_global=.true.)
    call alloc_x(phi1, opt_global=.true.)
    call alloc_x(clx1, opt_global=.true.)
    call alloc_x(cly1, opt_global=.true.)
    call alloc_x(clz1, opt_global=.true.)
    call alloc_x(gx1);call alloc_x(gy1);call alloc_x(gz1);call alloc_x(phis1) 
    call alloc_x(hx1);call alloc_x(hy1);call alloc_x(hz1);call alloc_x(phiss1)
    call alloc_x(ta1);call alloc_x(tb1);call alloc_x(tc1)
    call alloc_x(td1);call alloc_x(te1);call alloc_x(tf1)
    call alloc_x(tg1);call alloc_x(th1);call alloc_x(ti1)
    call alloc_x(di1);call alloc_x(ep1)
    call alloc_x(rho1, opt_global=.true.)
    call alloc_x(temperature1, opt_global=.true.)
    call alloc_x(massfrac1, opt_global=.true.)
    call alloc_x(rhos1)
    call alloc_x(temperatures1)
    call alloc_x(massfracs1)
    call alloc_x(rhoss1)
    call alloc_x(temperaturess1)
    call alloc_x(massfracss1)
    call alloc_x(rhos01)
    call alloc_x(rhos001)
    call alloc_x(drhodt1)
    call alloc_x(mu1, opt_global=.true.)
    call alloc_x(kappa1, opt_global=.true.)
    call alloc_x(gamma1, opt_global=.true.)
    allocate(sx(xsize(2),xsize(3)),vx(xsize(2),xsize(3)))
    !inflow/ouflow 2d arrays
    allocate(bxx1(xsize(2),xsize(3)),bxy1(xsize(2),xsize(3)))
    allocate(bxz1(xsize(2),xsize(3)),bxxn(xsize(2),xsize(3)))
    allocate(bxyn(xsize(2),xsize(3)),bxzn(xsize(2),xsize(3)))
    allocate(bxo(xsize(2),xsize(3)),byo(xsize(2),xsize(3)))
    allocate(bzo(xsize(2),xsize(3)))
    allocate(byx1(xsize(1),xsize(3)),byy1(xsize(1),xsize(3)))
    allocate(byz1(xsize(1),xsize(3)),byxn(xsize(1),xsize(3)))
    allocate(byyn(xsize(1),xsize(3)),byzn(xsize(1),xsize(3)))   
    allocate(bzx1(xsize(1),xsize(2)),bzy1(xsize(1),xsize(2)))
    allocate(bzz1(xsize(1),xsize(2)),bzxn(xsize(1),xsize(2)))
    allocate(bzyn(xsize(1),xsize(2)),bzzn(xsize(1),xsize(2)))
    !pre_correc 2d array
    allocate(dpdyx1(xsize(2),xsize(3)),dpdyxn(xsize(2),xsize(3)))
    allocate(dpdzx1(xsize(2),xsize(3)),dpdzxn(xsize(2),xsize(3)))
    allocate(dpdxy1(xsize(1),xsize(3)),dpdxyn(xsize(1),xsize(3)))
    allocate(dpdzy1(xsize(1),xsize(3)),dpdzyn(xsize(1),xsize(3)))
    allocate(dpdxz1(xsize(1),xsize(2)),dpdxzn(xsize(1),xsize(2)))
    allocate(dpdyz1(xsize(1),xsize(2)),dpdyzn(xsize(1),xsize(2)))

!arrays for statistic collection!pay attention to the size!
    allocate (umean(xstS(1):xenS(1),xstS(2):xenS(2),xstS(3):xenS(3)))
    allocate (vmean(xstS(1):xenS(1),xstS(2):xenS(2),xstS(3):xenS(3)))
    allocate (wmean(xstS(1):xenS(1),xstS(2):xenS(2),xstS(3):xenS(3)))
    allocate (uumean(xstS(1):xenS(1),xstS(2):xenS(2),xstS(3):xenS(3)))
    allocate (vvmean(xstS(1):xenS(1),xstS(2):xenS(2),xstS(3):xenS(3)))
    allocate (wwmean(xstS(1):xenS(1),xstS(2):xenS(2),xstS(3):xenS(3)))
    allocate (uvmean(xstS(1):xenS(1),xstS(2):xenS(2),xstS(3):xenS(3)))
    allocate (uwmean(xstS(1):xenS(1),xstS(2):xenS(2),xstS(3):xenS(3)))
    allocate (vwmean(xstS(1):xenS(1),xstS(2):xenS(2),xstS(3):xenS(3)))
    allocate (tmean(xstS(1):xenS(1),xstS(2):xenS(2),xstS(3):xenS(3)))    
    if (iscalar==1) then
       allocate (phimean(xstS(1):xenS(1),xstS(2):xenS(2),xstS(3):xenS(3)))
       allocate (phiphimean(xstS(1):xenS(1),xstS(2):xenS(2),xstS(3):xenS(3)))
    else
       allocate (phimean(1,1,1))
       allocate (phiphimean(1,1,1))
    endif
#include "newvar-alloc.inc"

!arrays for visualization!pay attention to the size!
    allocate (uvisu(xstV(1):xenV(1),xstV(2):xenV(2),xstV(3):xenV(3)))

!Y PENCILS
    call alloc_y(ux2);call alloc_y(uy2);call alloc_y(uz2)
    call alloc_y(ta2);call alloc_y(tb2);call alloc_y(tc2)
    call alloc_y(td2);call alloc_y(te2);call alloc_y(tf2)
    call alloc_y(tg2);call alloc_y(th2);call alloc_y(ti2)
    call alloc_y(tj2)
    call alloc_y(di2);call alloc_y(phi2)
    call alloc_y(clx2);call alloc_y(cly2);call alloc_y(clz2)
    call alloc_y(rho2)
    call alloc_y(temperature2)
    call alloc_y(massfrac2)
    call alloc_y(mu2)
    call alloc_y(kappa2)
    call alloc_y(gamma2)
    allocate(sy(ysize(1),ysize(3)),vy(ysize(1),ysize(3)))
!Z PENCILS
    call alloc_z(ux3);call alloc_z(uy3);call alloc_z(uz3)
    call alloc_z(ta3);call alloc_z(tb3);call alloc_z(tc3)
    call alloc_z(td3);call alloc_z(te3);call alloc_z(tf3)
    call alloc_z(tg3);call alloc_z(th3);call alloc_z(ti3)
    call alloc_z(di3);call alloc_z(phi3)
    call alloc_z(clx3);call alloc_z(cly3);call alloc_z(clz3)
    call alloc_z(rho3)
    call alloc_z(temperature3)
    call alloc_z(massfrac3)
    call alloc_z(divu3)
    call alloc_z(mu3)
    call alloc_z(kappa3)
    call alloc_z(gamma3)
    allocate(sz(zsize(1),zsize(2)),vz(zsize(1),zsize(2)))

 ! if all periodic
 !   allocate (pp3(ph%zst(1):ph%zen(1),ph%zst(2):ph%zen(2),ph%zst(3):ph%zen(3)))
 !   allocate (dv3(ph%zst(1):ph%zen(1),ph%zst(2):ph%zen(2),ph%zst(3):ph%zen(3)))
 !   allocate (po3(ph%zst(1):ph%zen(1),ph%zst(2):ph%zen(2),ph%zst(3):ph%zen(3)))
    call alloc_z(pp3,ph,.true.)
    call alloc_z(pp3corr,ph,.true.)
    call alloc_z(pp3star,ph,.true.)
    call alloc_z(rho0p3,ph,.true.)
    call alloc_z(dv3,ph,.true.)
    call alloc_z(po3,ph,.true.)

    return
  end subroutine init_variables

end module var

	program nematic_defect
	implicit none

	integer,parameter::nx=15		!25 / 10
	integer,parameter::ny=15
	integer,parameter::nc=0

	real*8,parameter::L0=20		! system size as L x L
	real*8,parameter::dx=L0/float(nx)
	real*8,parameter::dy=L0/float(ny)
	real*8,parameter::lambda=0.001d0		! exp lengthscale for interpolation // 0.1d0 0.01d0
	real*8,parameter::pi=acos(-1.d0)
	real*8,parameter::rcutoff=1.d0


	real*8::theta(1:nx,1:ny),xb,yb
	real*8::ndir(1:nx,1:ny)
	real*8::drx,dry,dr,z(1:nx,1:ny)
	real*8::dis,di(1:nx,1:ny)			!th(1:n)
	real*8::beta,junk				!x(1:n),y(1:n)
	real*8::xdum,ydum,ddx,ddy,dxy
	real*8::avgS,avgS1,avgS2, Sglobal

	real*8, allocatable :: th(:),x(:),y(:)
	real*8, allocatable :: x1(:),y1(:),x2(:),y2(:)

      	integer :: n
	integer :: nph,nmh
	integer::phi(1:5),coun(1:nx,1:ny)
	integer::i,j,l,im,jp	


	open(unit=100,file='data/afinetheta.txt',status='unknown')
	open(unit=200,file='data/nxy.txt',status='unknown')
	open(unit=300,file='data/defect.txt',status='unknown')
	open(unit=400,file='data/tdef.txt',status='unknown')
	open(unit=500,file='data/Defect3.txt',status='unknown')


	!---------------- get exact line number in a file -----------
	CALL execute_command_line('wc -l < data/afinetheta.txt > wc.txt' ) 
   	OPEN(unit=999,file='wc.txt') 
	READ(999,*) n 
	CLOSE(999)

	!--------------- allocate arrays ---------------
	allocate(th(1:n),x(1:n),y(1:n))
	allocate(x1(1:n),y1(1:n),x2(1:n),y2(1:n))

	th=0

	do i=1,n
	read(100,*)xdum,ydum,ddx,ddy,junk

	if (ddy.gt.0.d0) then
	x1(i)=xdum; y1(i)=ydum
	x2(i)=xdum+ddx; y2(i)=ydum+ddy
	else
	x2(i)=xdum; y2(i)=ydum
	x1(i)=xdum+ddx; y1(i)=ydum+ddy
	endif
	dxy = dsqrt( ddx*ddx + ddy*ddy )
	th(i) = dacos( (x2(i)-x1(i))/dxy )
      
      
	x(i)=0.5d0*(x1(i)+x2(i))
	y(i)=0.5d0*(y1(i)+y2(i))
	enddo

!------------------------------ Interpolation -----------------------------

	nph=0; nmh=0

	z=0; theta=0; coun=0

	do i=1,nx
	do j=1,ny

	xb=-(L0/2.d0) + (i-0.5d0)*dx
	yb=-(L0/2.d0) + (j-0.5d0)*dy

	avgS = 0.d0
	avgS1 = 0.d0
	avgS2 = 0.d0

	do l=1,n		! interpolation of theta

	drx=xb-x(l)
	dry=yb-y(l)

	dr=sqrt(drx*drx+dry*dry)

	theta(i,j)=theta(i,j)+th(l)*exp(-dr/lambda)
	z(i,j)=z(i,j)+exp(-dr/lambda)

        if(dr.lt.(sqrt(dx*dx+dy*dy))) then
	avgS1 = avgS1 + dcos(th(l))
	avgS2 = avgS2 + dsin(th(l))
	coun(i,j)=coun(i,j)+1
	endif

	enddo

	theta(i,j)=theta(i,j)/z(i,j)
	ndir(i,j) = atan2( avgS2/coun(i,j), avgS1/coun(i,j) )

	!write(*,*) avgS1, coun(i,j), ndir(i,j)	
   
!	if(coun(i,j).ge.nc) then 
!	write(200,*)-(L0/2.d0)+(i-0.5d0)*dx,-(L0/2.d0)+(j-0.5d0)*dy,cos(theta(i,j)),sin(theta(i,j)),avgS/coun(i,j)
!	endif

	enddo
	enddo


!-------------------------- defect detection --------------------

	phi=0
	di=0.d0

	do i=1,nx
	do j=1,ny

	im=i-1
	jp=j+1

	if(i.eq.1) im=nx
	if(j.eq.ny) jp=1

	phi(1)=theta(i,j)
	phi(2)=theta(im,j)
	phi(3)=theta(im,jp)
	phi(4)=theta(i,jp)
	phi(5)=theta(i,j)

	di(i,j)=0;

	do l=1,4
	dis=(phi(l+1)-phi(l))
	beta=0
	if (dis.gt.pi/2) then
	beta=pi
	endif
	if (dis.lt.-pi/2) then
	beta=-pi
	endif
	di(i,j)=di(i,j)+dis+beta
	enddo

	if(coun(i,j).gt.nc) then
	if (di(i,j).lt.(pi+0.05).and.di(i,j).gt.(pi-0.05)) then			! +1/2 defect
	write(300,*)-(L0/2.d0)+(i-0.5d0)*dx,-(L0/2.d0)+(j+0.5d0)*dy, 0.5d0
	nph=nph+1
	endif
	if (di(i,j).gt.(-pi-0.05).and.di(i,j).lt.(-pi+0.05)) then		! -1/2 defect
	write(300,*)-(L0/2.d0)+(i-0.5d0)*dx,-(L0/2.d0)+(j+0.5d0)*dy, -0.5d0
	nmh=nmh+1
	endif
	if(abs(di(i,j)-2.d0*pi).lt.0.05) then
	write(500,*)-(L0/2.d0)+(i-0.5d0)*dx,-(L0/2.d0)+(j+0.5d0)*dy
	endif
	endif

	enddo
	enddo



!----------------  Nematic order calculation --------------

	Sglobal = 0.d0

	do j=1,ny
	do i=1,nx

	xb=-(L0/2.d0) + (i-0.5d0)*dx
	yb=-(L0/2.d0) + (j-0.5d0)*dy

	avgS = 0.d0

	do l=1,n		! interpolation of theta

	drx=xb-x(l)
	dry=yb-y(l)

	dr=sqrt(drx*drx+dry*dry)

	if(dr.lt.(sqrt(dx*dx+dy*dy)))then
	avgS = avgS + dcos(2.d0* (th(l)-ndir(i,j)) )
	endif

	enddo

	Sglobal = Sglobal + avgS/coun(i,j)

	write(200,*)-(L0/2.d0)+(i-0.5d0)*dx,-(L0/2.d0)+(j-0.5d0)*dy,avgS/coun(i,j),(180.0/3.14)*ndir(i,j)		!avgS/coun(i,j)	

	enddo
	write(200,*) ""
	enddo

	Sglobal = Sglobal/float(nx*ny)



	write(400,*)nph, nmh, nph+nmh, Sglobal



	end program nematic_defect

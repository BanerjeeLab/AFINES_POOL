	program polar_order
	implicit none

	real*8,parameter::L0=20		! system size as L x L

	real*8::xb,yb
	real*8::beta,junk
	real*8::xdum1,ydum1,xdum2,ydum2
	real*8::rij, thetaij

	real*8, allocatable :: x(:),y(:)

      	integer :: n
	integer::i,j,l,im,jp, icount, pcount	


	open(unit=100,file='data/afinetheta.txt',status='unknown')
	open(unit=101,file='data/allbeads.txt',status='unknown')
	open(unit=200,file='data/pxy.txt',status='unknown')
	open(unit=201,file='data/bxy.txt',status='unknown')


	!***********  BARBED END ANALYSIS  *************

	!---------------- get exact line number in a file -----------
	CALL execute_command_line('wc -l < data/afinetheta.txt > wc.txt' ) 
   	OPEN(unit=999,file='wc.txt') 
	READ(999,*) n 
	CLOSE(999)

	!--------------- allocate arrays ---------------
	allocate(x(1:n),y(1:n))

	do i=1,n
	read(100,*)xdum1,ydum1,xdum2,ydum2
	x(i)=xdum1				!0.5d0*(x1(i)+x2(i))
	y(i)=ydum1				!0.5d0*(y1(i)+y2(i))
	enddo


	!----------------  get distances --------------

	do i=1,n
	icount = 0
	do j=1,n

	xb=x(i)-x(j)
	if (abs(xb).gt.L0/2.d0) xb=L0-abs(xb)
	yb=y(i)-y(j)
	if (abs(yb).gt.L0/2.d0) yb=L0-abs(yb)

	rij=sqrt(xb*xb+yb*yb)

	if (i.ne.j) then
	write(200,*) rij
	endif

	enddo		! j-loop
	enddo		! i-loop


	deallocate(x)
	deallocate(y)



	!***********  ALL BEADS ANALYSIS  *************

	!---------------- get exact line number in a file -----------
	CALL execute_command_line('wc -l < data/allbeads.txt > wc.txt' ) 
   	OPEN(unit=999,file='wc.txt') 
	READ(999,*) n 
	CLOSE(999)

	!--------------- allocate arrays ---------------
	allocate(x(1:n),y(1:n))

	do i=1,n
	read(101,*)xdum1,ydum1,junk,junk   
	x(i)=xdum1				!0.5d0*(x1(i)+x2(i))
	y(i)=ydum1				!0.5d0*(y1(i)+y2(i))
	enddo


	!----------------  get distances --------------

	do i=1,n
	icount = 0
	do j=1,n

	xb=x(i)-x(j)
	if (abs(xb).gt.L0/2.d0) xb=L0-abs(xb)
	yb=y(i)-y(j)
	if (abs(yb).gt.L0/2.d0) yb=L0-abs(yb)

	rij=sqrt(xb*xb+yb*yb)

	if (i.ne.j) then
	write(201,*) rij
	endif

	enddo		! j-loop
	enddo		! i-loop







	end program polar_order

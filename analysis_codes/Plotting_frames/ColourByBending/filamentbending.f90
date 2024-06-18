	program readfile
	implicit none

	real*8, parameter :: L=10.d0			!use the half of the system size -> x = [-L,L]

	integer, parameter :: n=30  	! as we use max filament of 20 rods

	real*8 :: xp(1:n),yp(1:n),xp0(1:n),yp0(1:n), crv(1:n)
	real*8 :: dx,dy
	real*8 :: s,r, theta
	real*8 :: dum
	integer :: i, lcount
	integer :: nn


	!------ initiate variables --------

	xp(1:n)=0.d0; yp(1:n)=0.d0; xp0(1:n)=0.d0; yp0(1:n)=0.d0; crv(1:n)=0.d0
	dx=0.d0; dy=0.d0;
	s=0.d0; r=0.d0; theta=0.d0;
	dum=0.d0;
	i=0
	lcount=0
	nn=0

	!----------------------------------


	!---------------- get exact line number in a file -----------
	CALL execute_command_line('wc -l < filament.txt > wc.txt' ) 
   	OPEN(unit=999,file='wc.txt') 
	READ(999,*) lcount 
	CLOSE(999)

	OPEN(unit=100,file='filament.txt')
	do i=1,lcount
	read(100,*) xp(i), yp(i), dum, dum
	enddo
	xp0 = xp
	yp0 = yp	! original coordinates

	!---------------- open curve.txt to append ---------------------
	OPEN(unit=200,file='curve.txt',action='write',position='append')


	!---------------- unwrap x,y co-ordinate ---------------------
	do i=1,lcount-1

	if (abs(xp(i+1)-xp(i)).gt.L) then
	if (xp(i)<0) then
	xp(i+1) = xp(i+1) - 2.d0*L
	elseif (xp(i).gt.0.d0) then
	xp(i+1) = xp(i+1) + 2.d0*L
	endif
	endif

	if (abs(yp(i+1)-yp(i)).gt.L) then
	if (yp(i).lt.0.d0) then
	yp(i+1) = yp(i+1) - 2.d0*L
	elseif (yp(i).gt.0.d0) then
	yp(i+1) = yp(i+1) + 2.d0*L
	endif
	endif

	enddo

	!OPEN(unit=900,file='test.txt')
	!do i=1,lcount
	!write(900,*) xp(i), yp(i)
	!enddo

	s = 0.d0

	!---------------- calculate curvature --------------
	do i=1,lcount-1

	dx=xp(i+1)-xp(i)
	dy=yp(i+1)-yp(i)

	s = s + sqrt(dx*dx + dy*dy)

	enddo

	r=sqrt( (xp(lcount)-xp(1))*(xp(lcount)-xp(1)) + (yp(lcount)-yp(1))*(yp(lcount)-yp(1)) )
	theta = 1.d0 - (r/s)
!	write(200,*) theta


	do i=1,lcount			!---- to create profile of bending 
	write(200,*) xp0(i), yp0(i), theta
	enddo

	write(200,*) ""

	stop
	end program

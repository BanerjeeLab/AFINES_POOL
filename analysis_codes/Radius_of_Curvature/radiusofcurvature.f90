	program readfile
	implicit none

	real*8, parameter :: L=10.d0			!use the half of the system size -> x = [-L,L]

	integer, parameter :: n=30

	real*8 :: xp(1:n),yp(1:n),xp0(1:n),yp0(1:n), crv(1:n)
	real*8 :: dx2,dx3,dy2,dy3
	real*8 :: a,b,r
	real*8 :: dum
	integer :: i, lcount
	integer :: nn

	OPEN(unit=900,file='done.txt')

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
	yp0 = yp

	!---------------- if smaller than 3 beads ---------------------
	OPEN(unit=200,file='curve.txt',action='write',position='append')
	if (lcount.lt.3) then
	GOTO 10
	endif

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



	!---------------- calculate radius of curvature --------------
	do i=2,lcount-1

	dx2=xp(i)-xp(i-1)
	dx3=xp(i+1)-xp(i-1)
	dy2=yp(i)-yp(i-1)
	dy3=yp(i+1)-yp(i-1)

	a = (dx2*dx2*dy3 - dx3*dx3*dy2 + dy2*dy2*dy3 - dy3*dy3*dy2)/(2.d0*(dx2*dy3 - dx3*dy2))
	b = (dx2*dx2*dx3 - dx3*dx3*dx2 + dy2*dy2*dx3 - dy3*dy3*dx2)/(2.d0*(dx3*dy2 - dx2*dy3))

	r=sqrt((a*a)+(b*b))
	crv(i) = r

	write(200,*) xp0(i), yp0(i), crv(i)
	
	enddo

	GOTO 20


!----------------- exit ------------------
10	do i=1,lcount
	write(200,*) xp0(i), yp0(i), 0.d0
	enddo
	write(900,*) 'done 10'	


20	write(900,*) 'done'

	stop
	end program

	program readfile
	implicit none

	real*8, parameter :: L=10.d0			!use the half of the system size -> x = [-L,L]
	real*8, parameter :: er=1.d-6

	integer, parameter :: n=10000

	real*8 :: rc(1:n), c(1:n)
	real*8 :: meanc, varc, maxc
	real*8 :: dum
	integer :: i, lcount, ncount
	integer :: nn
	

	!---------------- get exact line number in a file -----------
	CALL execute_command_line('wc -l < curve.txt > wc.txt' ) 
   	OPEN(unit=999,file='wc.txt') 
	READ(999,*) lcount 
	CLOSE(999)

	OPEN(unit=100,file='curve.txt')
	!------- mean ----------
	ncount = 0
	meanc=0.d0
	do i=1,lcount
	read(100,*) dum, dum, rc(i)

	if (rc(i).gt.er) then
	c(i) = 1.d0/rc(i)
	meanc=meanc+c(i)
	ncount = ncount + 1
	endif

	enddo
	meanc = meanc/float(ncount)
	maxc = maxval(c)

	!------- std ------------
	varc=0.d0
	ncount = 0
	do i=1,lcount
	if (rc(i).gt.er) then
	dum = c(i) - meanc
	varc = varc + (dum*dum)
	ncount = ncount + 1
	endif

	enddo
	varc = varc/float(ncount)

	!---------------- if smaller than 3 beads ---------------------
	OPEN(unit=200,file='timecurve.txt',action='write',position='append')
	write(200,*) meanc, dsqrt(varc), maxc


!----------------- exit ------------------
	

	stop
	end program

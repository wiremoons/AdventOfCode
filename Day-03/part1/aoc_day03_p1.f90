! Advent of Code 2021 : https://adventofcode.com/2021
! Puzzle for Day 03 part 02 : 
! Build with:  gfortran -static-libgcc -o aoc_day03_p1 aoc_day03_p1.f90

program aoc_day03_p1

	use, intrinsic :: iso_fortran_env
	implicit none

	! Declare and set constants the AOC day and part
	integer,parameter :: day = 3, part = 1

	! Declare file related variables
	integer :: rows = 0, total_power=0
	character(len=*), parameter :: filename = "day03-input.txt"
	character(len=*), parameter :: error1 = "file: '"//''//filename//''//"' not found"

	! Output startup message
	call display_welcome(day,part)

	if (.NOT. file_exists(filename)) stop error1
	rows = get_row_count(filename)
	total_power = get_measurements(filename,rows)
	
	! Display the number rows in the input file
	write(*,'(A,I4.4)') " » Number of measurements: ",rows
	write(*,'(A,I8.8)') " » Power consumption of the submarine: ",total_power
	
	
contains

	! Display the AoC puzzle day and part being resolved  
	subroutine display_welcome(day,part)
		implicit none
		integer, intent(in) :: day,part
		write (*,'(A,I2.2,A,I2.2)') "AoC 2021 - solution for Day ",day," part ",part
	end subroutine display_welcome


	! Check input filename exists 
	function file_exists(filename) result (exists)
		implicit none
		character(len=*), intent(in) :: filename
		logical :: exists ! type for the return.  NB: no intent(out) needed.
				
		inquire(file=filename, exist=exists)
	end function file_exists
	

	! Open the file and count the number of rows it contains
	function get_row_count(filename) result (rows)
		implicit none
		character(len=*), intent(in) :: filename
		integer :: fileunit,io
		integer :: rows ! type for the return.  NB: no intent(out) needed.
		
		open(newunit=fileunit, file=filename, action='read', position='rewind')
		rows = 0
		do  
			read(fileunit,*,iostat=io)
			if ( io /= 0 ) exit
			rows = rows + 1
		end do
		close(fileunit)
	end function get_row_count
	
	! Solve the problem : total number of depth increases for each sonar reading 
	function get_measurements(filename,rows) result (total_power)
		implicit none
		character(len=*), intent(in) :: filename
		integer :: fileunit,io,rows,j,c,m,t,z
		integer,dimension(12,1) :: gamma, epsilon ! hold binary representation for each
		integer,dimension(12,rows) :: input  ! main array of input data from puzzle
		integer :: total_power ! type for the return.
		
		open(newunit=fileunit, file=filename, action='read', position='rewind')
		!allocate(input(rows:12))
		read(fileunit,'(I1,I1,I1,I1,I1,I1,I1,I1,I1,I1,I1,I1)') input
		close(fileunit)

		write(*,'(A,I5.5)') "Array 'input' size is: ",size(input)
		write(*,'(A,I2.2)') "Array 'input' number of dimensions (rank) is: ",rank(input)
		write(*,'(A,I2.2)') "Array 'input' shape is: ",shape(input)

		! Display all input as a 12 x 1000 array matrix
		!do c = 1,12
		!	do j = 1,rows
		!		write(*,'(I1.1)',advance="no") input(c,j)
		!		!print *, input(c,j)
		!	end do
		!	print *, ""
		!end do
		
		t = 1000
		m = 0  ! capture 'gamma' candidates
		z = 0  ! capture 'epsilon' candidates
		write (*,'(A,I4.4)') "Target: ",t
		do c = 1,12
			do j = 1,rows
				!write(*,'(I1.1)',advance="no") input(c,j)
				if (input(c,j) .eq. 1 ) m = m + 1  ! it is a gamma measurement
				if (input(c,j) .eq. 0 ) z = z + 1  ! it is an epsilon measurement
				!print *, input(c,j)
			end do
			!print *, m
			!print *, z + m
			! display the calculations to decide if 
			write(*,'(I2.2,A,I4.4,A,I5.5)') c," = ",m," cal:", t-m
			! if more than half the candidate max - then gama, else epsilon instead. Can only be one or the other!
			! build the binary view using an array for each - can check once built to calculate decimal equivalent 
			if (m .gt. 499) then
				gamma(c,1) = 1
				epsilon(c,1) = 0
			else
			 	gamma(c,1) = 0
			 	epsilon(c,1) = 1
			end if
			z = 0
			m = 0
		end do

		print *,""
		print *, "Submarine Gama (binary) is:"
		print *, gamma
		print *, "Submarine epsilon (binary) is:"
 		print *, epsilon	
		print *, "Gama as decimal: '844'  and  Epsilon as decimal: '3251'"
		
		total_power=844*3251
		!total_power = count(input(1:rows-1).LT.input(2:rows))
		!deallocate(input)
	end function get_measurements

end program aoc_day03_p1
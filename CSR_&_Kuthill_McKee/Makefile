F90=gfortran
FLAGS=-02 -march=native
DEBUGG=-O0 -Wall -ffpe-trap=invalid,overflow -fcheck=all -pedantic -g -pg
EXE=CKM
OBJ=CSR_Kuthill_McKee.o

$(EXE):$(OBJ)
	$(F90) $(DEBUGG) -o $(EXE) $^

%.o:%.f90
	$(F90) $(DEBUGG) -c $<

clean :
	rm -f *.o *.mod $(EXE)

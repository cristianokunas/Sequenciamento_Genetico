
all: compile
	
compile:
	gcc -o 1criar 1criar.c
	nvcc -o gpu.out seqgene.cu
#nvcc -o gpu.out seqgene.cu -Xcompiler -fopenmp
	@echo "Compilaçao concluida"

clean:
	rm -rf *.out

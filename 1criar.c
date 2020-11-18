#include<stdio.h>
#include <stdlib.h>
#include<string.h>
#include<time.h>

//1073741824 - 1GB

#define TAM 1024*1024*1024


void cria_arq1();
void cria_arq2();

void main(void)
{
	srand(time(NULL));
	cria_arq1();
	cria_arq2();
}

void cria_arq1(){
	FILE *file;
	file = fopen("src/DNA1.txt","w");	    
	int n=0, cont;
	char c;
	for (cont=TAM; cont > 0; cont --){
		do {
			n = rand() % 90;
		} while ((n != 65) && (n != 67) && (n != 71) && (n != 84));
		//printf("%d ",n);
		c = n + 0;
		//printf("%c ",c);
		putc(c,file);
	}
	fclose(file);
}

void cria_arq2(){
	FILE *file;
	file = fopen("src/DNA2.txt","w");	    
	int n=0, cont;
	char c;
	for (cont=TAM; cont > 0; cont --){
		do {
			n = rand() % 90;
		} while ((n != 65) && (n != 67) && (n != 71) && (n != 84));
		//printf("%d ",n);
		c = n + 0;
		//printf("%c ",c);
		putc(c,file);
	}
	fclose(file);
}

//A 65
//C 67
//G 71
//T 84

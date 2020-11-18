#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//#include <omp.h>
#include <cuda.h>


const char ARQUIVO_DNA_1[] = {"src/DNA1.txt"};
const char ARQUIVO_DNA_2[] = {"src/DNA2.txt"};

char *DNA, *combinacoesDNA;

int *inicioProcesso, *countCombinacoesDNA;

char combinacoesDNAtxt[24][5] = {"ACGT", "ACTG", "AGCT" , "AGTC", 
                                "ATCG", "ATGC", "CAGT", "CATG", 
                                "CGAT", "CGTA", "CTAG", "CTGA", 
                                "GACT", "GATC", "GCAT", "GCTA", 
                                "GTAC", "GTCA", "TACG", "TAGC", 
                                "TCAG", "TCGA", "TGAC", "TGCA"};
                            
void lerArquivo(const char *nomeArquivo, const int tamanho);
int tamanhoArquivo(const char *nomeArquivo);

__device__ int my_strcmp(const char *str_a, const char *str_b, unsigned len = 5)
{
    int match = 0;
    unsigned i = 0;
    unsigned done = 0;
    while ((i < len) && (match == 0) && !done)
    {
      if ((str_a[i] == 0) || (str_b[i] == 0))
      {
        done = 1;
      } 
      else if (str_a[i] != str_b[i])
      {
        match = i+1;
        if (((int)str_a[i] - (int)str_b[i]) < 0)
        {
        match = 0 - (i + 1);
        }
      }
      i++;
    }
    return match;
}

__global__ void pesquisar(char *dna, char *combinacoes, int *inicio, int *countCombinacoes, int tamanhoDNA, unsigned totalProcessos)
{
    int idProcesso = blockIdx.x * blockDim.x + threadIdx.x;
    if(idProcesso < totalProcessos)
    {
        int i;
    
        char busca[5];
        char combinacao[5];

        int count;
        for(count = inicio[idProcesso]; count < inicio[idProcesso + 1]; count++)
        {
            
            busca[0] = dna[count];
            busca[1] = dna[count + 1];
            busca[2] = dna[count + 2];
            busca[3] = dna[count + 3];
            
            for(i = 0; i < 96; i+=4)
            {
                combinacao[0] = combinacoes[i];
                combinacao[1] = combinacoes[i + 1];
                combinacao[2] = combinacoes[i + 2];
                combinacao[3] = combinacoes[i + 3];
                
                if(my_strcmp(busca, combinacao) == 0)
                {
                    // Add no vetor
                    atomicAdd(&countCombinacoes[i/4],1);
                    break;
                }  
            }
        }
    }
}

__global__ void compararEncontrados(char *dna, char *combinacoes, int *inicio, int *maisEncontrados, int *countmaisEncontrados, int tamanhoDNA, int totalProcessos)
{
    int idProcesso = blockIdx.x * blockDim.x + threadIdx.x;
    if(idProcesso < totalProcessos)
    {

        int i;
    
        char busca[5];
        char combinacao[5];
        
        int count;
        for(count = inicio[idProcesso]; count < inicio[idProcesso + 1]; count++)
        {
            
            busca[0] = dna[count];
            busca[1] = dna[count + 1];
            busca[2] = dna[count + 2];
            busca[3] = dna[count + 3];
            
            for(i = 0; i < 17; i+=4)
            {   
                int tempIndex = maisEncontrados[i/4] * 4;
                combinacao[0] = combinacoes[tempIndex];
                combinacao[1] = combinacoes[tempIndex + 1];
                combinacao[2] = combinacoes[tempIndex + 2];
                combinacao[3] = combinacoes[tempIndex + 3];
                
                if(my_strcmp(busca, combinacao) == 0)
                {
                    // Add no vetor
                    atomicAdd(&countmaisEncontrados[i/4],1);  
                    break;
                }
            }
        }
    }
}


int main(int argc, char *argv[0])
{
    if((argv[1] == NULL) || (argv[2] == NULL))
    {
        printf("\n\nInsira o número de blocos e threads! \n\n");
        return(1);
    }

    int *countMaisEncontrados;

    int numBlocos = atoi(argv[1]);
    int numThreads = atoi(argv[2]);
    int totalProcessos = numBlocos * numThreads;

    const int tamanhoDNA = tamanhoArquivo(ARQUIVO_DNA_1);

    cudaMallocManaged(&DNA, tamanhoDNA * sizeof(char));
    cudaMallocManaged(&combinacoesDNA, 96 * sizeof(char));
    cudaMallocManaged(&inicioProcesso, (totalProcessos + 1) * sizeof(int));
    cudaMallocManaged(&countCombinacoesDNA, 24 * sizeof(int));
    cudaMallocManaged(&countMaisEncontrados, 5 * sizeof(int));
    
    strcpy(combinacoesDNA,"ACGTACTGAGCTAGTCATCGATGCCAGTCATGCGATCGTACTAGCTGAGACTGATCGCATGCTAGTACGTCATACGTAGCTCAGTCGATGACTGCA");
    
    lerArquivo(ARQUIVO_DNA_1, tamanhoDNA);

    // Definindo a posição inicial de cada processo
    int i;
    inicioProcesso[0] = 0;
    for(i = 0; i < totalProcessos; i++)
    {
        inicioProcesso[i + 1] = inicioProcesso[i] + tamanhoDNA / totalProcessos;
    }

    /*
    <<<numDeBlocos, numDeThreadsPorBloco>>>
    gtx 960 16 blocos 64 threads
    gtx 1050 12 blocos 64 threads
    */

    pesquisar <<<numBlocos, numThreads>>> (DNA, combinacoesDNA, inicioProcesso, countCombinacoesDNA, tamanhoDNA, totalProcessos);
    cudaDeviceSynchronize();
    
    int *maisEncontrados;
    cudaMallocManaged(&maisEncontrados, 5 * sizeof(int));
    maisEncontrados[0] = 0;
    // Encontra as 5 combinações mais achadas pegando os seus indices
    for (int count = 0; count < 5; count++)
    {
        if (count == 0)
        {
            for (i = 0; i < 24; i++)
            {
                if (countCombinacoesDNA[maisEncontrados[count]] < countCombinacoesDNA[i])
                {
                    maisEncontrados[count] = i;
                }
            }
        }
        else
        {
            for (i = 0; i < 24; i++)
            {
                if (countCombinacoesDNA[maisEncontrados[count]] < countCombinacoesDNA[i] && countCombinacoesDNA[maisEncontrados[count - 1]] > countCombinacoesDNA[i])
                {
                    maisEncontrados[count] = i;
                }
            }
        }
    }

    lerArquivo(ARQUIVO_DNA_2, tamanhoDNA);

    compararEncontrados<<<numBlocos, numThreads>>>(DNA, combinacoesDNA, inicioProcesso, maisEncontrados, countMaisEncontrados, tamanhoDNA, totalProcessos);
    cudaDeviceSynchronize();

    cudaFree(DNA);
    cudaFree(countCombinacoesDNA);
    cudaFree(combinacoesDNA);
    cudaFree(inicioProcesso);
    cudaFree(maisEncontrados);
    cudaFree(countMaisEncontrados);

    return 0;
}

void lerArquivo(const char *nomeArquivo, const int tamanho)
{   
    /*
    omp_set_num_threads(12);
    #pragma omp parallel
    {
        FILE *file;
        file = fopen(nomeArquivo, "r");
    
        int i;
        char busca[2];
        // Leitura do arquivo DNA1
        #pragma omp for private (i) 
        fseek(file, i, SEEK_SET);
        for (i = 0; i < tamanho; i++)
        {
            //fseek(file, i, SEEK_SET);
            fgets(busca, 2, file);
            DNA[i] = busca[0];
            //fscanf(file, "%1c", &DNA[i]);
        }
        fclose(file);
    }
    */
    
    
    FILE *file;
    file = fopen(nomeArquivo,"r");
    
    int i;
    // Leitura do arquivo DNA1
    for(i = 0; i < tamanho; i++)
    {
        fscanf(file, "%1c", &DNA[i]);
    }
    fclose(file);
    
    
}

int tamanhoArquivo(const char *nomeArquivo)
{
    FILE *file;
    file = fopen(nomeArquivo, "r");
    fseek(file, 0, SEEK_END);
    int size;
    size = ftell(file);
    fclose(file);
    return size;
}


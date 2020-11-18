### Sequenciamento Genético
Este trabalho apresenta  uma avaliação de desempenho da paralelização do sequenciamento de DNA em ambientes com aceleradores. Para tanto foi utilizado  uma implementação paralela que realiza o sequenciamento de DNA com os modelos de programação CUDA. A solução utilizada baseia-se em uma versão modificada do algoritmo Smith-Waterman sendo capaz de realizar buscas com sequenciamento de 4 caracteres.

### Executando
Para compilar no SO linux, use o [Makefile](https://github.com/cristianokunas/Sequenciamento_Genetico/blob/main/Makefile).
* [1criar](https://github.com/cristianokunas/Sequenciamento_Genetico/blob/main/1criar.c) - cria arquivos de texto com as sequências (tamanho do arquivo: TAM = 1GB).
* [seqgene]() - realiza a pesquisa, recebe como parâmetros a quantidade de blocos e threads.
```
./gpu.out 12 64
```

Também foi criado um [script](https://github.com/cristianokunas/Sequenciamento_Genetico/blob/main/run.sh) para execução automática e captura dos tempos (para GPU NVIDIA GTX RTx 2060 - 1920 cuda cores).

### Documentos
Resumo Espandido, [XX ERAD, 2020](https://sol.sbc.org.br/index.php/eradrs/article/view/10744).

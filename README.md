# Sequenciamento Genético
>Este trabalho apresenta  uma avaliação de desempenho da paralelização do sequenciamento de DNA em ambientes com aceleradores. Para tanto foi utilizado  uma implementação paralela que realiza o sequenciamento de DNA com os modelos de programação CUDA. A solução utilizada baseia-se em uma versão modificada do algoritmo Smith-Waterman sendo capaz de realizar buscas com sequenciamento de 4 caracteres.

<p>
<a href="https://sol.sbc.org.br/index.php/eradrs/article/view/10744">
  <img alt="Resumo Espandido" src="https://img.shields.io/badge/Resumo%20Espandido-XX%20ERAD%2C%202020-76B900?logo=read-the-docs&logoColor=white"/>
</a><br>
  
<img src="https://img.shields.io/badge/Ubuntu-E95420?logo=ubuntu&logoColor=white"/>

<img src="https://img.shields.io/badge/C-00599C?logo=c&logoColor=white"/>

<img src="https://img.shields.io/badge/CUDA-000000?logo=nvidia&logoColor=white"/>

<a href="https://www.nvidia.com/pt-br/geforce/graphics-cards/rtx-2060/" alt="NVIDIA">
  <img src="https://img.shields.io/badge/NVIDIA-GTX%20RTx2060-76B900?logo=nvidia&logoColor=white"/>
</a>

</p>

## Como usar

### Linux
Para compilar, use o Makefile:
```
make
```
De permissão de execução com:
```
chmod +x run.sh
```
Execute:
```
./run.sh
```

Ao executar, são criados dois arquivos de texto com as sequências (tamanho = 1GB).

O [script](https://github.com/cristianokunas/Sequenciamento_Genetico/blob/main/run.sh) executa de forma automática e captura dos tempos. 

Os resultados são salvos em:
```
src/resultados.txt
```

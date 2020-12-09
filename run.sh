echo +------------------------------------------+
echo +------- "Criando Arquivos DNA" -----------+
echo +------------------------------------------+

./1criar


echo +------------------------------------------+
echo +------- "Arquivos DNA criados" -----------+
echo +------------------------------------------+


echo +------------------------------------------+
echo +------- "Iniciando teste CUDA" -----------+
echo +------------------------------------------+

# Configured for NVIDIA GTX RTx 2060
# 6GB of Memory and 1920 CUDA Cores
for i in 1 2 3 4 5
do
    echo
    echo "--------- Rodada: $i--------------------------"
    for j in 160 128 96 64 32 16 8 4 2
    do
        echo
        echo "--------- Executando em $((12 * $j)) CUDA core(s)---------"
	    time ./gpu.out 12 $j >> src/resultados.txt
        echo
        echo "----------------------------------------------"
	    echo
    done
done

echo +------------------------------------------+
echo +------- "Fim do teste CUDA" --------------+
echo +------------------------------------------+


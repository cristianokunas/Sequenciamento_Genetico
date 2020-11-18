echo +------------------------------------------+
echo +------- "Iniciando teste CUDA" --------------+
echo +------------------------------------------+


for i in 1
do
    echo
    echo "--------- Rodada: $i--------------------------"
    for j in 160 128 96 64 32 16 8 4 2
    do
        echo
        echo "--------- Executando em $((12 * $j)) CUDA core(s)---------"
	    time ./gpu.out 12 $j > resultados.txt
        echo
        echo "----------------------------------------------"
	    echo
    done
done

echo +------------------------------------------+
echo +------- "Fim do teste CUDA" -----------------+
echo +------------------------------------------+


#!/bin/bash

# Lista dos algoritmos
algoritmos=("fifo" "ljf" "prio_dynamic" "prio_dynamic_quantum" "prio_static" "sjf")

# Loop pelos algoritmos
for alg in "${algoritmos[@]}"
do
    echo "Executando algoritmo: $alg"

    output_file="resultados_${alg}.txt"
    stats_file="estatisticas_${alg}.txt"
    grafico_file="grafico_${alg}.dat"

    # Limpa arquivos anteriores, se existirem
    > $output_file
    > $stats_file
    > $grafico_file

    # Loop das quantidades de processos
    for j in $(seq 10 10 100)
    do
        echo "Processando $j processos..."

        # Executa 10 rodadas para cada quantidade de processos
        for i in $(seq 1 10)
        do
            ./main_$alg $j | grep "TME" >> $output_file
        done

        # Extrai os 10 últimos valores de TME (da quantidade atual)
        valores=$(grep "TME" $output_file | tail -n 10 | awk '{print $2}')

        # Calcula média
        soma=0
        for v in $valores
        do
            soma=$(echo "$soma + $v" | bc -l)
        done
        media=$(echo "$soma / 10" | bc -l)

        # Calcula variância
        soma_var=0
        for v in $valores
        do
            diff=$(echo "$v - $media" | bc -l)
            diff2=$(echo "$diff * $diff" | bc -l)
            soma_var=$(echo "$soma_var + $diff2" | bc -l)
        done
        variancia=$(echo "$soma_var / 10" | bc -l)

        # Desvio padrão
        desvio=$(echo "sqrt($variancia)" | bc -l)

        # Salva no arquivo de estatísticas detalhado
        {
            echo "Processos: $j"
            echo "Média TME: $media"
            echo "Variância: $variancia"
            echo "Desvio Padrão: $desvio"
            echo "-------------------------------"
        } >> $stats_file

        # Salva no arquivo de dados para gráficos (simples e limpo)
        echo "$j $media $variancia" >> $grafico_file
    done

    echo "Estatísticas salvas em $stats_file"
    echo "Dados para gráfico salvos em $grafico_file"
done

echo "Processo concluído para todos os algoritmos!"

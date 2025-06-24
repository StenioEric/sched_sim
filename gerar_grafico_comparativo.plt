# Define o formato de saída como PNG e o nome do arquivo
set terminal pngcairo size 1000,600 enhanced font 'Verdana,10'
set output 'grafico_comparativo.png'

# --- Configurações do gráfico ---
set title "Comparativo de TME dos Algoritmos de Escalonamento"
set xlabel "Quantidade de Processos"
set ylabel "TME (microssegundos)"

# Adiciona uma grade e posiciona a legenda
set grid
set key top left

# --- Comando para plotar múltiplas linhas ---
# O primeiro plot usa o nome do arquivo, os seguintes usam '' para reutilizar o mesmo arquivo.
# 'using 1:2' plota a coluna 2 vs a coluna 1.
# 'using 1:3' plota a coluna 3 vs a coluna 1, e assim por diante.
plot 'dados.dat' using 1:2 with linespoints title 'FIFO', \
     ''          using 1:3 with linespoints title 'SJF', \
     ''          using 1:4 with linespoints title 'LJF', \
     ''          using 1:5 with linespoints title 'PRIO ESTÁTICO', \
     ''          using 1:6 with linespoints title 'PRIO DINÂMICO', \
     ''          using 1:7 with linespoints title 'PRIO DINÂMICO Q'
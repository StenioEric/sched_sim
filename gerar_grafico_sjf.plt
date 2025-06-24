# Define o formato de saída como PNG e o nome do arquivo
set terminal pngcairo size 800,600 enhanced
set output 'grafico_sjf.png'

# --- Configurações do seu gráfico ---
set title "Tempo Médio de Espera (SJF)"
set xlabel "Quantidade de Processos"
set ylabel "Tempo Médio de Espera (microssegundos)"
set grid
set key left top

# Define que as colunas no arquivo de dados são separadas por espaços
set datafile separator whitespace

# Plota os dados (coluna 2 vs coluna 1) com barras de erro.
# As barras de erro são a raiz quadrada da coluna 3 (desvio padrão).
plot "grafico_sjf.dat" using 1:2:($3**0.5) with yerrorlines title "Média TME com Desvio Padrão"
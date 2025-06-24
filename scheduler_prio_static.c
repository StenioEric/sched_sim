#include <stdio.h>
#include <stdlib.h>  // Para rand()
#include "queue.h"
#include "proc.h"
#include "stats.h"
#include "utils.h"

// Variáveis globais
extern struct queue * ready;
extern struct queue * ready2;
extern struct queue * blocked;
extern struct queue * finished;
extern int MAX_TIME;

struct proc * scheduler(struct proc * current)
{
    struct proc * selected = NULL;

    // --- Tratamento do processo que estava executando ---
    if (current != NULL)
    {
        switch (current->state)
        {
            case READY:
                // Retorna para a mesma fila em que iniciou
                if (current->queue == 0)
                {
                    enqueue(ready, current);
                }
                else
                {
                    enqueue(ready2, current);
                }
                count_ready_in(current);
                break;

            case BLOCKED:
                enqueue(blocked, current);
                count_blocked_in(current);
                break;

            case FINISHED:
                enqueue(finished, current);
                count_finished_in(current);
                break;

            default:
                printf("@@ ERRO no estado de saída do processo %d\n", current->pid);
        }
    }

    // --- Verifica se há processos nas duas filas ---
    if (isempty(ready) && isempty(ready2))
    {
        return NULL;
    }

    // --- Sorteio para decidir de qual fila escolher ---
    int sorteio = rand() % 100;  // Número entre 0 e 99

    if ((sorteio < 80 && !isempty(ready)) || isempty(ready2))
    {
        // 80% para a fila ready ou se a ready2 estiver vazia
        selected = dequeue(ready);
    }
    else
    {
        // 20% para a fila ready2
        selected = dequeue(ready2);
    }

    // --- Atualiza estatísticas e estado ---
    if (selected != NULL)
    {
        count_ready_out(selected);
        selected->state = RUNNING;
    }

    return selected;
}

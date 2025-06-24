#include <stdio.h>
#include "queue.h" // Certifique-se de que queue.h contém a definição completa de struct node
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

    if (current != NULL)
    {
        switch (current->state)
        {
            case READY:
                enqueue(ready, current);
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

    if (isempty(ready))
    {
        return NULL;
    }

    // Procurar processo com maior remaining_time na fila 'ready'
    struct proc * aux = ready->head;
    selected = aux;

    for (; aux != NULL; aux = aux->next)
    {
        if (aux->remaining_time > selected->remaining_time)
        {
            selected = aux;
        }
    }

    // Remover processo selecionado da fila ready
    dequeue_bypid(ready, selected->pid);

    count_ready_out(selected);
    selected->state = RUNNING;

    return selected;
}

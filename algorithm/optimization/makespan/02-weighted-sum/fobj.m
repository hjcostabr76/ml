function [somaPonderadaAtrasos] = fobj(x, taskTimeTable, taskPenalty, dueDate)

    %
    % ===================================================================
    % Objective funciton 02: Minimização da soma ponderada dos atrasos
    % -------------------------------------------------------------------
    %
    % - d_w: Soma ponderada de atraso total;
    % - d_wj: Penalidade por atraso da tareja j;
    % - d_j: Atraso absoluto da tarefa j;
    % - W_j: Peso do impacto negaivo do atraso na execução da tarefa j;
    % - t_i: Total time interval from t zero until machine k finish it's last task;
    % - t_[i, k]: Time to machine k finish task i (coms from input data);
    % - D_D: Prazo estipulado para conclusão de cada tarefa;
    %
    % -------------------------------------------------------------------
    % ===================================================================
    %

    [tasksCount, machinesCount] = size(taskTimeTable);
    penalidadePorAtraso = zeros(1, tasksCount);
    machineTimes = zeros(1, machinesCount);


    for k = 1:machinesCount
        for i = 1:tasksCount
            if x(i, k) > 0
                task = x(i, k);
                machineTimes(k) = machineTimes(k) + taskTimeTable(task, k);
                atrasoAbsolutoTask = 0;
                if (machineTimes(k) - dueDate) > 0
                    atrasoAbsolutoTask = machineTimes(k) - dueDate;
                end
                penalidadePorAtraso(task) = atrasoAbsolutoTask * taskPenalty(task);
            end
        end
    end
    somaPonderadaAtrasos = 0;
    for j = 1:tasksCount
        somaPonderadaAtrasos = somaPonderadaAtrasos + penalidadePorAtraso(j);
    end
end


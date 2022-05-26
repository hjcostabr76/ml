% EXECUÇÃO DO PROGRAMA 5 VEZES SEGUIDAS

inicio = now; % contagem de tempo

disp("Execução 1 - Início: " + datestr(now, 'HH:MM'));
naoDominadas1 = Pe(); 
disp("Execução 2 - Início: " + datestr(now, 'HH:MM'));
naoDominadas2 = Pe();
disp("Execução 3 - Início: " + datestr(now, 'HH:MM'));
naoDominadas3 = Pe();
disp("Execução 4 - Início: " + datestr(now, 'HH:MM'));
naoDominadas4 = Pe();
disp("Execução 5 - Início: " + datestr(now, 'HH:MM'));
naoDominadas5 = Pe();


disp("Fim da execução: " + datestr(now, 'HH:MM') + " (iniciada às: " + datestr(inicio, 'HH:MM')+")");

% plotagem dos resultados
figure, hold on
plt1 = plot(naoDominadas1(1,:),naoDominadas1(2,:),'ro');
plt2 = plot(naoDominadas2(1,:),naoDominadas2(2,:),'go');
plt3 = plot(naoDominadas3(1,:),naoDominadas3(2,:),'co');
plt4 = plot(naoDominadas4(1,:),naoDominadas4(2,:),'mo');
plt5 = plot(naoDominadas5(1,:),naoDominadas5(2,:),'bo');
hold off

legend([plt1, plt2, plt3, plt4, plt5],'Execução 1','Execução 2','Execução 3','Execução 4','Execução 5')

xlabel('Quantidade de Roteadores')
ylabel('Distância Média')
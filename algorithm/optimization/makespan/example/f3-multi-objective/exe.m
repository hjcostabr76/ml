% EXECU��O DO PROGRAMA 5 VEZES SEGUIDAS

inicio = now; % contagem de tempo

disp("Execu��o 1 - In�cio: " + datestr(now, 'HH:MM'));
naoDominadas1 = Pe(); 
disp("Execu��o 2 - In�cio: " + datestr(now, 'HH:MM'));
naoDominadas2 = Pe();
disp("Execu��o 3 - In�cio: " + datestr(now, 'HH:MM'));
naoDominadas3 = Pe();
disp("Execu��o 4 - In�cio: " + datestr(now, 'HH:MM'));
naoDominadas4 = Pe();
disp("Execu��o 5 - In�cio: " + datestr(now, 'HH:MM'));
naoDominadas5 = Pe();


disp("Fim da execu��o: " + datestr(now, 'HH:MM') + " (iniciada �s: " + datestr(inicio, 'HH:MM')+")");

% plotagem dos resultados
figure, hold on
plt1 = plot(naoDominadas1(1,:),naoDominadas1(2,:),'ro');
plt2 = plot(naoDominadas2(1,:),naoDominadas2(2,:),'go');
plt3 = plot(naoDominadas3(1,:),naoDominadas3(2,:),'co');
plt4 = plot(naoDominadas4(1,:),naoDominadas4(2,:),'mo');
plt5 = plot(naoDominadas5(1,:),naoDominadas5(2,:),'bo');
hold off

legend([plt1, plt2, plt3, plt4, plt5],'Execu��o 1','Execu��o 2','Execu��o 3','Execu��o 4','Execu��o 5')

xlabel('Quantidade de Roteadores')
ylabel('Dist�ncia M�dia')
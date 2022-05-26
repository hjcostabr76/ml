% EXECU��O DO PROGRAMA 5 VEZES SEGUIDAS

mem1 = VNS();
mem2 = VNS();
mem3 = VNS();
mem4 = VNS();
mem5 = VNS();

figure, hold on
plt1 = plot(0:size(mem1,1)-1,mem1(:,end),'r-','linewidth',2);
plt2 = plot(0:size(mem2,1)-1,mem2(:,end),'g-','linewidth',2);
plt3 = plot(0:size(mem3,1)-1,mem3(:,end),'b-','linewidth',2);
plt4 = plot(0:size(mem4,1)-1,mem4(:,end),'c-','linewidth',2);
plt5 = plot(0:size(mem5,1)-1,mem5(:,end),'m-','linewidth',2);
hold off

legend([plt1, plt2, plt3, plt4, plt5],'Execu��o 1','Execu��o 2','Execu��o 3','Execu��o 4','Execu��o 5')

xlabel('N�mero de avalia��es')
ylabel('Dist�ncia m�dia')
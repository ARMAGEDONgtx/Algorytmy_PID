load('CFO_workspace.mat')
load('PSO_workspace.mat')
load('mapowanie_workspace.mat')


mesh(FIT);
hold on;
scatter3(gbest(2)*10,gbest(4)*10, gbest(1),'red');
hold on;
scatter3(best_cells(1)*10, best_cells(2)*10, best_cells(3),'blue');


% najlepsze dopasowania poszczegolnych mrowek w PSO, w CFO nie ma takiej
% opcji
%for i = 1:1:20
  %  scatter3(pbest(i,2)*10,pbest(i,4)*10, pbest(i,1));
%end
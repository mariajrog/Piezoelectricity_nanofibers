path = 'C:\Users\mjrg0\OneDrive - Universidad EAFIT\Escritorio\Trabajo de grado\Piezoelectricidad\Fibra_8';
cd(path)
%%
tomas = 3;
num_pruebas = 14;
carga_all = 0;

for j=1:num_pruebas
    close all
    carga_all = 0;

    % Load the files with loads and time
    num_carga = j;
    for i=1:tomas
        name_s = sprintf('%d\\%d%s', num_carga, i,'.txt');
        cargas = importdata(name_s);
        carga_raw(:,i) = cargas(:,2);
        t = cargas(:,1);
    end
    
    % plot(carga_raw)
    
    % Delete time space with no signal
    threshold = mean(min(carga_raw(:,1)));

    for i=1:tomas
        ind = abs(carga_raw(:,i))< abs(threshold);
        carga_all = [carga_all; carga_raw(ind,i)];
    end

    carga_all(1)=[];
    t = linspace(0,500,length(carga_all));

    % figure(33)
    % plot(t, carga_all)
    % ylabel('Voltajes [V]')
    % xlabel('Tiempo [ms]')

    % Find peaks in the signal
    ind_positive = carga_all>0;
    carga_positive= carga_all(ind_positive);

    % Find valleys in the signal
    ind_negative= carga_all<0;
    carga_negative= carga_all(ind_negative);

    max_prom = 0.1;
    if j>6
        max_prom = 0.1;
    end
    % figure(22)
    % findpeaks(carga_positive,'MinPeakProminence',max_prom);
    maximos = findpeaks(carga_positive,'MinPeakProminence',max_prom);

    min_prom = 0.1;
    if j>2
        min_prom = 0.1;
    end
    % figure(23)
    % findpeaks(-carga_negative,'MinPeakProminence',min_prom);
    minimos = findpeaks(-carga_negative,'MinPeakProminence',min_prom);
    
    % Take the peak-to-peak voltage
    voltajes(num_carga,1) = round(mean(maximos)+ mean(minimos),2);

    % Take the loads average
    name_c = sprintf('%d\\%s', num_carga, 'Cargas.txt');
    carga_val_all = importdata(name_c);
    
    cargas_val(num_carga,1) = round(mean(carga_val_all),2);
end

voltajes
cargas_val

plot(cargas_val, voltajes,'*')

%% Find the indices of the values to drop from cargas_val (outliers)
% cargas_to_drop = [0.39, 1.44, 2.05, 1.17];    % Fibra 4
% cargas_to_drop = [0.61, 1.17, 0.83];    % Fibra 7
cargas_to_drop = [0.46, 0.69, 0.73];    % Fibra 8
% cargas_to_drop = [0.58, 0.7, 0.78, 1, 0.46, 0.97, 1];    % Fibra 42

indices_to_drop = ~ismember(cargas_val, cargas_to_drop);

cargas_clean = cargas_val(indices_to_drop);
voltajes_clean = voltajes(indices_to_drop);

plot(cargas_clean, voltajes_clean,'*')

%% Fit a linear regression
mdl = fitlm(cargas_clean, voltajes_clean)

% Get the coefficients
coefficients = mdl.Coefficients;
% Extract slope and intercept from the coefficients
slope = mdl.Coefficients.Estimate(2);
intercept = mdl.Coefficients.Estimate(1);
r2 = mdl.Rsquared.Ordinary;

% Create a string representing the linear equation
linear_equation = sprintf('y = %.2fx + %.2f', slope, intercept);
R2 = sprintf('R^2 = %.2f', r2);

plot(cargas_clean, voltajes_clean,'*')
hold on
plot(mdl)

% Add the linear equation to the plot and the determination coeffcient
text(0.5, 0.5, linear_equation, 'FontSize', 10, 'Color', 'k');
text(0.5, 0.5, R2, 'FontSize', 10, 'Color', 'k');

% legend('Datos', 'Regresión lineal', 'Intervalos de confianza');
xlabel('Cargas [N]')
ylabel('Voltajes [V]')
title('Membrana 4')

%% Compare nanofibers performance

xx =[0 1];

% Create the nanofibers lineal functions from the regression
fibra4 = 0.71.*xx + 0.34;
fibra7 = 0.65.*xx + 0.22;
fibra8 = 0.46.*xx + 0.11;

plot(xx, fibra4, xx, fibra7, xx, fibra8)
xlabel('Cargas [N]')
ylabel('Voltajes [V]')
title('Comparación curvas F vs V')
legend('Membrana 4', 'Membrana 7', 'Membrana 8');

% Add the linear equation to the plot
% Fibra 4
text(0.5, 0.5, 'y_4 = 0.71x + 0.34', 'FontSize', 10, 'Color', 'k');
text(0.5, 0.5, 'R_4^2 = 0.71', 'FontSize', 10, 'Color', 'k');

% Fibra 7
text(0.5, 0.5, 'y_7 = 0.65x + 0.22', 'FontSize', 10, 'Color', 'k');
text(0.5, 0.5, 'R_7^2 = 0.95', 'FontSize', 10, 'Color', 'k');

% Fibra 8
text(0.5, 0.5, 'y_8 = 0.46x + 0.11', 'FontSize', 10, 'Color', 'k');
text(0.5, 0.5, 'R_8^2 = 0.97', 'FontSize', 10, 'Color', 'k');


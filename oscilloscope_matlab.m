% Instantiate an instance of the scope.
myScope = oscilloscope();

% Find resources. 
resource = resources(myScope);

% Get driver information. 
driverlist = drivers(myScope);

% Instantiate an instance of the scope.
myScope = oscilloscope(resource{3}, 'tektronix')

%%
% Set the acquisition time
myScope.AcquisitionTime = 5; % [decisegundos] -> 5 dc = 500 ms

% Set the acquisition to collect 2000 data points.
% myScope.WaveformLength = 2000;

% Enable channel 1. 
enableChannel(myScope, 'CH1');

D = 'C:\Users\mjrg0\OneDrive - Universidad EAFIT\Escritorio\Trabajo de grado\Piezoelectricidad';

fibra = input('Número de fibra: ');
carga = input('Prueba: ');

folder_path =fullfile(D,sprintf('%s%d%','Fibra_',fibra),num2str(carga));
mkdir(folder_path);
%%

if exist(sprintf('%s%d',folder_path,1), 'file')
    disp('File already exist');
    return
end

totalAdquisitions = 3 % Take 3 repetitions

pause(15)

disp('Measuring now')

for i = 1:totalAdquisitions
    % Acquire the waveform
    signal = readWaveform(myScope);
    t = linspace(0,myScope.AcquisitionTime,myScope.WaveformLength);
    
    figure(2)
    plot(t,signal)
    title("Acquired waveform (sweep)")
    xlabel("Time (s)");
    ylabel("Voltage (V)");
    
    data(:,1) = t;
    data(:,2) = signal;

    name = sprintf('%s\\%d',folder_path,i)
    
    % Save the waveform data and time stamps to a file
    writematrix(data, name)
    disp('File saved')
end

%% 
disconnect(myScope);
clear myScope;
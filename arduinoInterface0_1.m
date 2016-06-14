%% This code is written in MatLab. This code is designed to communicate with the Arduino via serial communication
%% This 
arduino=serial('COM1','BaudRate',9600);

fopen(arduino);
pause(1);
%% This is the writing section
fprintf('\n')
fprintf('How many steps shall the nose move? \n')
noseStep = input('');
fprintf('\n')
fprintf('How many steps shall the ear move? \n')
earStep = input('');
fprintf('\n')
fprintf('RUNNING \n')
fprintf(arduino, '%s','go ');
fprintf(arduino, '%d',noseStep);
noseStepTest = fscanf(arduino,'%d');
fprintf(arduino, '%d',earStep);
earStepTest = fscanf(arduino,'%d');
fprintf('SERIAL SENT \n')
if (noseStepTest == noseStep && earStepTest == earStep)
    disp('all systems nominal');
end

%% This is the manual running side
running = 'run ';
while (~strcmp(running, 'stop;'))
    fprintf('Type run; to run \nType stop; to stop \nType trigger; to manually trigger a pulse \n')
    running = input('', 's');
    fprintf(arduino, '%s', running);
    %%isRunning = fscanf(arduino,'%s');
    %%disp(isRunning);
end
%% This is the reading section

%% This is the closing section
fclose(arduino);
delete(arduino)
clear arduino
fprintf('SEQUENCE COMPLETE \n')
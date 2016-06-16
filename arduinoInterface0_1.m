%% This code is written in MatLab. This code is designed to communicate with the Arduino via serial communication.  This program runs with motorControl6.1.ino or motorControl6.3.inouploaded to the arduino.
%   INPUTS:_______________________
%   noseStep an integer of how steps you wish the nose to travel. A step is
%   equal to 1.8 degrees of motion.
%   EX: noseStep = 100;
%   earStep an integer of how steps you wish the ear to travel. A step is
%   equal to 1.8 degrees of motion.
%   EX: earStep = 100;
%   Commands:_____________________
%   run; is a command that calls the motors to perform their dynamic motion
%   stop; is a command that ends this program and no longer allows input
%   into the arduino until this is run again.
%   trigger; is a command that will allow a digital high voltage signal to
%   be sent to pin 52 on the arduino to activate the dynamic motion. This
%   signal must be sent within around a five second window.
clear;
clc;
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

%% This code is written in MatLab. This code is designed to communicate with the Arduino via serial communication. This program runs with motorControl6.2.ino uploaded to the arduino.
%   The stepper Motor
%   INPUTS:_______________________
%   noseStep an integer of how steps you wish the nose to travel. A step is
%   equal to 1.8 degrees of motion.
%   EX: noseStep = 100;
%   earStep an integer of how steps you wish the ear to travel. A step is
%   equal to 1.8 degrees of motion.
%   EX: earStep = 100;
%   Commands:_____________________
%   No input commands are nessecary after the initialization. In order to
%   successfully trigger the dynamic control, a digital high voltage signal
%   must be sent to pin 52 on the arduino.
%   
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


%% This is the reading section

%% This is the closing section
fclose(arduino);
delete(arduino)
clear arduino
fprintf('SEQUENCE COMPLETE \n')

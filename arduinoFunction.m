function [ confirmation ] = arduinoFunction( COM , runCount , noseStep , earStep )
%% This code is written in MatLab. This code is designed to communicate with the Arduino via serial communication.  This program runs with motorControl6.ino uploaded to the arduino.
%   INPUTS:_______________________
%   COM is a string of the serial communications port you will be using.
%   EX: COM = 'COM1';
%   runCount an integer of how many times you wish to run the dynamic control.
%   EX: runCount = 1;
%   noseStep an integer of how steps you wish the nose to travel. A step is
%   equal to 1.8 degrees of motion.
%   EX: noseStep = 100;
%   earStep an integer of how steps you wish the ear to travel. A step is
%   equal to 1.8 degrees of motion.
%   EX: earStep = 100;
%   OUTPUTS:______________________
%   confirmation is a number returned to confirm that the data was recieved
%   and the program successfully ran. If confirmation is equal to 1, the
%   data was sent, recieved, and the stepper motors ran. If confirmation is
%   zero, then either the data sent was not the same as recieved, or the
%   motors did not fully run.
arduino = serial(COM ,'BaudRate',9600);

fopen(arduino);
pause(1);
%% This is the writing section

fprintf('RUNNING \n')
fprintf(arduino, '%s','go ');
fprintf(arduino, '%d', runCount);
runCountTest = fscanf(arduino,'%d');
fprintf(arduino, '%d',noseStep);
noseStepTest = fscanf(arduino,'%d');
fprintf(arduino, '%d',earStep);
earStepTest = fscanf(arduino,'%d');
fprintf('SERIAL SENT \n')
%%
verify1 = (runCountTest == runCount && noseStepTest == noseStep && earStepTest == earStep);
loopTester = true;
count = 0;
while (loopTester)
    if (strcmp(fscanf(arduino,'%s'),'Complete') || count > 100000)
        loopTester = false;
        verify2 = true;
    end
    count = count + 1;
end
confirmation = (verify1 && verify2);
%% This is the reading section

%% This is the closing section
fclose(arduino);
delete(arduino)
clear arduino
fprintf('SEQUENCE COMPLETE \n')
if (confirmation == 1)
    fprintf('SEQUENCE SUCCESSFUL\n');
end
end


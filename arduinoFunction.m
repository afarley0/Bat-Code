function [ confirmation ] = arduinoFunction( COM , runCount , noseStep , earStep )
%% This code is written in MatLab. This code is designed to communicate with the Arduino via serial communication 
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


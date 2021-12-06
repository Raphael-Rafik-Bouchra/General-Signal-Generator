%-------------Part 2----------------------
close all
clear
clc
%-----------------------------------------

%-------------------------------------------------------Reading Variables-----------------------------------------------------
fs = 0; ti=0; tf=0; numberOfBreakpoints=-1; positionsOfBreakpoint=[];
while(fs <= 0)                                                    %checking correct value for fs
fs = input('Enter the Sampling frequency of the signal:\nfs=');
end
while(tf <= ti)                                                   %checking correct values for ti & tf
ti = input('Enter the start of time scale:\nti=');
tf = input('Enter the end of time scale:\ntf=');
end

while(numberOfBreakpoints < 0)        %checking correct value of numberOfBreakpoints
    numberOfBreakpoints = input('Enter the number of breakpoints:\nn=');
end

while(size(positionsOfBreakpoint) < numberOfBreakpoints)          %checking correct values of positionsOfBreakpoint
positionsOfBreakpoint = input('Enter an ARRAY of positions of breaking points: Example"Positions=[1 2 3]"\nPositions=');
end
disp('--------------------------------------------');
%---------------------------------------------

%--------------------------------------------------Identifying Signal--------------------------------------------------------------
t1 = 0;            %t1 is the start time of the current signal
t2 = 0;            %t2 is the end time of the current signal
signal = [];       %The total signal;
for i = 0:1:numberOfBreakpoints
    typeOfCurrentSignal = 0; %Resets the value of the type of current signal
    currentSignal = 0;       %Resets the current signal
    currentSignalTime = 0;   %Resets the current signal time
    
    region = ['[Region] ', num2str(i+1) ];   %Prints the Number of current region
    disp(region);
    
    if(numberOfBreakpoints == 0)
        t1 = ti;               %means there only one signal from ti to tf
        t2 = tf;
    
    
    elseif(i == 0)
        t1 = ti;               %the time of the first region
        t2 = positionsOfBreakpoint(1);
    
    elseif(i == numberOfBreakpoints)     %the time of the last region
        t1 = positionsOfBreakpoint(end);
        t2 = tf;
        
    else
        t1 = positionsOfBreakpoint(i);     %the time the remaining regions
        t2 = positionsOfBreakpoint(i+1);
    end
        time = ['From t=', num2str(t1),' --> To t=',num2str(t2)];   %prints to the user the begining and the end of the current region
        disp(time);
        disp('-------------------');
        
       currentSignalTime = linspace(t1,t2,ceil(t2-t1)*fs);          %current signal time eguation (ceil to prevent fraction fs error)
        
    while(typeOfCurrentSignal<1 || typeOfCurrentSignal>5)    %checks the value of typeOfCurrentSignal
        typeOfCurrentSignal = input('Enter the type number of region signal:\n1:DC signal   2:Ramp signal   3:General order polynomial\n    4:Exponential signal   5:Sinusoidal signal\nType=');
    end
    
    switch typeOfCurrentSignal      %current signal generator based on some specifications
        case 1                      %DC signal
            disp('DC Signal:');
            
            amplitude = input('Enter the amplitude of the DC signal:\nAmplitude=');
            
            currentSignal = zeros(1,floor(t2-t1)*fs) + amplitude;  %ceil to prevent fraction fs error
            disp('------------------------------');
            
        case 2                      %Ramp signal
            disp('Ramp Signal:');
            
            slope = input('Enter the slope of the ramp signal:\nSlope=');
            intercept = input('Enter the intercept of the ramp value:\nintercept=');
            
            currentSignal = slope*currentSignalTime + intercept;   %ramp equation
            disp('------------------------------');
            
        case 3                      %General order polynomial
            disp('General order polynomial:');    %General ploynomial equation
            
            coefficients = input('Enter an array of coefficients: Example: 2t^2 + 3t - 5  --> [2 3 -5]\nCoefficients=');  %getting coefficients from user
            degree = length(coefficients);              %degree = Highest power in the polynomial 
            
            for j = degree:-1:1                         %Eguating the polynomial equation
                
                currentTerm = (currentSignalTime.^(j-1)).*coefficients(degree-j+1);
                currentSignal = currentSignal+currentTerm;
            end
            disp('------------------------------');
    
        case 4                      %Exponential signal
            disp('Exponential signal');
            
            amplitude = input('Enter the amplitude of the exponential signal:\nAmplitude=');
            exponent = input('Enter the exponent of the exponential signal:\nExponent=');
            
            currentSignal = amplitude*exp(exponent*currentSignalTime);         %exponential equation
            disp('------------------------------');
            
        case 5                      %Sinusoidal signal
            disp('Sinusoidal signal');
            
            amplitude = input('Enter the amplitude of the sinusoidal signal:\nAmplitude=');
            frequency = input('Enter the frequency of the sinusoidal signal [Angular Frequency (w)]:\nfrequency=');
            phase = input('Enter the phase of the sinusoidal signal [in rad]:\nphase=');
            
            currentSignal = amplitude*sin((2*pi*frequency*currentSignalTime)+phase); %sinusoidal equation (used (sin) & (+)phase to produce the same output signal in the test cases pdf )
                                                                                     %*** BUT the general definition is [amplitude*cos(2*pi*frequency*currentSignalTime) - phase]
            disp('------------------------------');
    end
    signal = [signal currentSignal];     %concatinate each region signal with the total signal
end
%-----------------------------------------------------------------------------------------------------------------------

%------------------------Ploting total signal-----------------------------
totalTime = linspace(ti,tf,ceil(tf-ti)*fs);     %ceil to prevent fraction fs error
figure; plot(totalTime,signal); title('Total Signal'); grid on;    %plots the total signal
%-------------------------------------------------------------------------


%------------------------Operations On Signal-----------------------------
disp('---Performing Operations on the signal---');

while(1)
    typeOfOperation = 0;      %resets the value typrOfOperation
    while(typeOfOperation < 1 || typeOfOperation > 6)  %checks the value of typeOfoperation
        typeOfOperation = input('Enter the type of operation:\n1.Amplitude Scaling   2.Time reversal    3.Time shift\n4.Expanding the signal   5.Compressing the signal   6.None\nOperation type=');
    end

    switch typeOfOperation        
        case 1                          %amplitude scaling        
            disp('Amplitude Scaling:');
            amplitude = input('Enter the amplitude scale:\nScale=');
            signal = signal.*amplitude;
            disp('------------------------------');
            
        case 2                         %time reversal
            disp('Time reversal:');
            signal = fliplr(signal);
            disp('------------------------------');
            
        case 3                        %time shift
            disp('Time shift:');      
            shift = input('Enter the time shift:\nTime shift=');
            totalTime = totalTime - shift;
            disp('------------------------------');
    
        case 4                        %expanding
            disp('Expanding the signal');
            expansion = input('Enter the expansion factor:\nExpansion factor=');
            totalTime = totalTime*expansion;
            disp('------------------------------');
            
        case 5                        %compressing
            disp('Compressing the signal');
            compression = input('Enter the compression factor:\nCompression factor=');
            totalTime = totalTime/compression;
            disp('------------------------------');
        case 6
            break;   %terminate the whole program
    end
%--------------------------------------------------------------------------
%---------------------Ploting modified signal------------------------------
    figure; plot(totalTime,signal); title('Total Signal after operation applying'); grid on;   %plots the modified signal
%--------------------------------------------------------------------------    
end  
%-------------------------------------------------END OF PROGRAM-------------------------------------------------------------
s = tf('s');
J = 1;
b = 20;
R = 1;
L = 0.001;
Km = 5;
%systems
G2 = 1/(J*s^2 + b*s);
G1 = Km/(L*s + R);
Ka = 50;
open_sys = Ka * G1*G2; %OLTF
figure;
step(open_sys);
title('OLTF step response');
Td = G2/(1+Ka * G1); %CLTF of disturbance 
Ts = open_sys/(1+ open_sys); % CLTF of reference 
figure;
step(Ts); %3Azero disturbance
title('CLTF of reference step response, zero disturbance');
figure;
step(Td); %3Bzero refrence
title('CLTF of disturbance step response, zero reference');





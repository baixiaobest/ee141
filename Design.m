%% Hard Disk Design

%% Task 1
% The differential equation of input voltage and head position is given, so
% it is pretty easy to get the open loop transfer function by taking the
% lapalce transform of both side and can easily get 
%
% $$\frac{Y(s)}{U(s)} = \frac{1}{Js^2+bs}$$

%% Task 2
% open loop transfer function is given by multiplying both G1 and G2
%
% $$G1(s)G2(s)=\frac{Km}{(Ls+R)*(Js^2+bs)}=\frac{Km}{LJs^3+Lbs^2+RJs^2+Rbs}$$
s = tf('s');
J = 1;
b = 20;
R = 1;
L = 0.001;
Km = 5;
G1 = Km/(L*s+R)
G2 = 1/(J*s^2+b*s)
openTF = G1*G2
t=[0:0.005:0.5];
y = step(openTF,t);
plot(t,y);
%%
% You can see that if a constant voltage is applied, then the read head
% will moves in a constant speed. And at the begining when the voltage is
% applied, there is a curve, which indicates that the read head is
% accelerating under applied voltage.
% 

%% Task 3a
% The proportional compensator is applied, so that the open loop transfer
% function is given by 
% 
% $$Ka*G1(s)*G2(s)$$
%
% and closed loop transfer function is given by
%
% $$\frac{Ka*G1(s)*G2(s)}{1+Ka*G1(s)*G2(s)}$$
% 
% after plug in G1(s)G2(s) from previous computation, we have
%
% $$\frac{Ka*Km}{LJs^3+(Lb+RJ)s^2+Rbs+KaKm}$$
%
% Try plugging in Ka = 50, we can get the following plot
Ka = 50;
t=[0:0.005:1.5];
ProportionalTF =(Ka*G1*G2)/(1+Ka*G1*G2)
y = step(ProportionalTF, t);
plot(t,y);
%%
% Then applied step when Ka = 400
Ka = 400;
ProportionalTF = (Ka*openTF)/(1+Ka*openTF)
y = step(ProportionalTF, t);
plot(t,y);
%%
% Clearly you can see that the Ka=50 has less over shoot than Ka=400 does.
% This is because for Ka=400, the feedback amplification is too big and
% make system too sensitive.

%% Task 3b
% So when disturbance is Introduced to the system, the disturbance input
% flows into system between G1 and G2.
% So that we can derive the transfer function for disturbance:
%
% $$Tw = \frac{G2(s)}{1+Ka*G1(s)}$$
%
% First plot the response of disturbance in case of Ka = 50
Ka = 50;
Tw = G2/(1+Ka*G1*G2)
y = step(Tw, t);
plot(t,y);

%%
% Then plot the response of disturbance in case of Ka = 400
Ka = 400;
Tw = G2/(1+Ka*G1*G2)
y = step(Tw, t);
plot(t,y);

%% Task 3C
% We can plot overshoot percentage and settling time as a function of Ka,
% and analyze the optiomal Ka for the system
overshoot = [];
settlingTime = [];
maxError = [];
n=[1:100];
for  Ka=n
    ProportionalTF = (Ka*openTF)/(1+Ka*openTF);
    y = step(ProportionalTF, t);
    info = stepinfo(y, t, 'SettlingTimeThreshold', 0.02);
    overshoot = [overshoot, info.Overshoot];
    settlingTime = [settlingTime info.SettlingTime];
    
    Tw = G2/(1+Ka*G1*G2);
    y = step(Tw, t);
    maxError = [maxError max(y)];
end
subplot(3,1,1);
plot(n,overshoot);xlabel('Ka');ylabel('Overshoot Percentage');
subplot(3,1,2);
plot(n,settlingTime);xlabel('Ka');ylabel('Settling Time');
subplot(3,1,3);
plot(n,maxError);xlabel('Ka');ylabel('Maximum Error of Disturbance');

%%
% for overshoot less than 5%, Ka is required to be equal or less than 41
% Ka value that satisfy settling time less than 250ms is too big and is not
% in the graph
% for disturbance less than 0.005, Ka is required to be equal or bigger than 41
% Clearly, you cannot satisfy both requirement at the same time.

%% Task 4
% The closed loop transfer function in this case would be
%
% $$frac{KaG1(s)G2(s)}{1+KaH(s)G1(s)G2(s)}$$
%

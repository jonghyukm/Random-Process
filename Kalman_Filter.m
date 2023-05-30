clear;clc;close all

%% Modeling
F=[1 0 0.5 0;0 1 0 0.5;0 0 1 0;0 0 0 1];
FT=F.';
H=[1 0 0 0;0 1 0 0];
HT=H.';
P=eye(4);
R=100;
%% Original Data Set
x=zeros(4,100);
x(:,1)=[3;0;1;0];
%% Measurement Data Set
tri1=[20 20;-20 0];
noisy=zeros(2,100);
%% Filtered Data Set
xhat=zeros(4,100);
xhat(:,1)=[3;0;1;0];

%% Original Data
for i=1:1:99
    x(:,i+1)=F*x(:,i)+randn(4,1);
end
plot(x(1,:),x(2,:),"-o","Color",[0 0 0])
hold on

%% Measurement data
for i=1:1:100
    r1=normrnd(0,0.3)+sqrt(x(1,i)^2+x(2,i)^2);
    r2=normrnd(0,0.3)+sqrt((x(1,i)-10)^2+(x(2,i)-10)^2);
    r3=normrnd(0,0.3)+sqrt(x(1,i)^2+(x(2,i)-10)^2);
    tri2=[(r1^2)-(r2^2)+200;(r2^2)-(r3^2)-100];
    input=tri1\tri2;
    noisy(:,i)=input;
end
plot(noisy(1,:),noisy(2,:),"-x")
hold on

%% Kalman Filtering
for i=1:1:99 
    xhat(:,i+1)=F*xhat(:,i);
    P=F*P*FT + eye(4);
    K=(P*HT)/((H*P*HT+R*eye(2)));
    xhat(:,i+1)=xhat(:,i+1)+K*(noisy(:,i+1)-H*xhat(:,i+1));
    P=P-K*H*P;
end
plot(xhat(1,:),xhat(2,:),"-x","Color","b")

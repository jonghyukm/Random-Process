%% Settings
clear
clc
A=[0.975 0.025;0.025 0.975];
p=0.001;
B=[1-p p;p 1-p];
testnum=1000;

%% Evaluate the Average Error Probability
for j=1:5
    error=0;
    for i=1:testnum
        [y,z]=make(p);
        zhat=viterbi(A,B,y);
        cnt=test(zhat,z);
        if cnt~=0
            error=error+cnt;
        end
    end
    js=num2str(j);
    s=num2str(error/(testnum*0.01));
    disp("Trial "+js+"; Error probability is "+s+"%")
end

%% Check Error
function cnt=test(zhat,z)
cnt=0;
len=length(z);
for t=1:len
    if zhat(t)~=z(t)
        cnt=1;
        break
    end
end
end

%% Viterbi Algorithm
function zhat=viterbi(A,B,y)
len=length(y);
zhat=zeros(1,len);
prob=zeros(2,len);
prob(:,1)=B(:,1).*[1;0];
index=zeros(2,len);
for t=2:len
    [prob(1,t),index(1,t)]=max(prob(:,t-1).*A(:,1).*B(1,y(t)+1));
    [prob(2,t),index(2,t)]=max(prob(:,t-1).*A(:,2).*B(2,y(t)+1));
end
[~,argmax]=max(prob(:,len));
zhat(len)=argmax-1;
for t=len:-1:2
    zhat(t-1)=index(zhat(t)+1,t)-1;
end
end

%% Make Hidden Sequence and Observation Sequence
function [y,z]=make(p)
z=zeros(1,100);
y=zeros(1,100);
y(1)=0;
previous=0;
state=[1 0];
for t=2:100
    zd=rand(1);
    if zd<0.975
        z(t)=previous;
    else
        z(t)=state(previous+1);
        previous=z(t);
    end
    yd=rand(1);
    if yd<1-p
        y(t)=z(t);
    else
        y(t)=state(z(t)+1);
    end
end
end
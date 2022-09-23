
function input=sinal(forma,amplitude,ti,to)
%ti é t inicial
%to é tout - final
input = zeros(to,1);
newt = ti+1;   
%step = round((to-newt-1)/5)-1;
step = 10;
step2=round((to-newt-1)/10)-1;

if forma==0
    input (ti:to,1)=amplitude
end


%impulso
if forma==1
    input(newt,1)= amplitude;
end

    
%pulso1
if forma==2
    input(newt:newt+step,1)=amplitude;
end

   
%pulso2
if forma==3
    for ii = 1:2
        input(newt:newt+step2,1)=amplitude;
        newt=newt+2*step2
    end
end

       
%degrau    
if forma==4
    input (newt:to,1)=amplitude;
end

    
    
%seno
if forma==5
       f = 0.0075;
       for ii = 1:to-newt
           input (newt+ii)=amplitude*sin(2*pi*f*ii);
       end
end       

if forma==6
    for ii = newt:to
        input(ii,1)=amplitude*rand;
    end
end


if forma==7
    for ii = 1:5
     input(newt:newt+step,1)=amplitude*ii;
     newt = newt+step;
    end
end

    









  

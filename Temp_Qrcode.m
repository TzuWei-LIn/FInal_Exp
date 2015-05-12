clear();
%load secert
I = imread('Lena.jpg');
[test] = textread('s1.txt','%s','headerlines',0);
secert_data_1(1,1:1024) = cellfun(@str2num,test) ;    %取出來的認證碼存在secert_data_1
test=[];
[test] = textread('s2.txt','%s','headerlines',0);
secert_data_2(1,1:1024) = cellfun(@str2num,test) ;    %取出來的認證碼存在secert_data_2
for i=2:size(secert_data_1,2)
    secert_data_1(i) = secert_data_1(i) + secert_data_1(i-1);
    secert_data_2(i) = secert_data_2(i) + secert_data_2(i-1);
end

%recalculate authentication
%devide 8x8 block
bb = imread('Fuck.bmp');
count = 1;
for i=1:8:size(bb,1)
    for j=1:8:size(bb,2)
        data_extract(:,:,count) = bb(i:i+7,j:j+7);
        count=count+1;
    end
end

%clean lsb1 for 0
for g=1:count-1
    for i=1:8
        for j=1:8
            x1 = dec2bin(data_extract(i,j,g))-48;
            if(x1(length(x1))==1)
                data_extract(i,j,g) =  data_extract(i,j,g)-1;
            end
        end
    end
end

%detect
compare_data = [];
for i=1:size(data_extract,3)
    compare_data(i) = 0;
    [U,S,V] = svd(double(data_extract(:,:,i)));
    t1 = fix(S(1,1));
    t2 = fix(S(2,2));
    count_hide=1;
    if(secert_data_1(i)~=t1 || secert_data_2(i)~=t2)
        compare_data(i)=1;
    end
    count_hide=count_hide+1;
end

% detect more Accurate
th = 2;
mem = compare_data;  %Scratchpad
for i=1:length(compare_data)
    count_r =0;
    if(i==1)            %i=0;
        if(mem(i+1)==1)
            count_r=count_r+1;
        end
        if(mem(i+32)==1)
            count_r=count_r+1;
        end
        if(mem(i+33)==1)
            count_r = count_r+1;
        end
        if(count_r<th)
            compare_data(i) = 0;
        end
    end % i=0
    
    if(i>1 && i<32)        %top
        if(mem(i+32)==1)
            count_r=count_r+1;
        end
        if(mem(i+31)==1)
            count_r=count_r+1;
        end
        if(mem(i+33)==1)
            count_r=count_r+1;
        end
        if(count_r<th)
            compare_data(i) = 0;
        end
    end   %end top
    
    if(i==32)   %i=32
        if(mem(i-1)==1)
            count_r=count_r+1;
        end
        if(mem(i+31)==1)
            count_r=count_r+1;
        end
        if(mem(i+32)==1)
            count_r=count_r+1;
        end
        if(count_r<th)
            compare_data(i) = 0;
        end
    end % end i=32
    
    if(i>1 && mod(i,32)==1 && i~=993)    %left
        if(mem(i-32)==1)
            count_r=count_r+1;
        end
        if(mem(i-31)==1)
            count_r=count_r+1;
        end
        if(mem(i+1)==1)
            count_r=count_r+1;
        end
        if(mem(i+33)==1)
            count_r=count_r+1;
        end
        if(mem(i+32)==1)
            count_r=count_r+1;
        end
        if(count_r < th)
            compare_data(i) = 0;
        end
    end     %end for left
    
    if(i==993)  %i=993
        if(mem(i-32)==1)
            count_r=count_r+1;
        end
        if(mem(i-31)==1)
            count_r=count_r+1;
        end
        if(mem(i+1)==1)
            count_r=count_r+1;
        end
        if(count_r < th)
            compare_data(i) = 0;
        end
    end  %end i=993
    
    if(i~=32 && mod(i,32)==0 && i~=1024)    %right
        if(mem(i-32)==1)
            count_r=count_r+1;
        end
        if(mem(i-33)==1)
            count_r=count_r+1;
        end
        if(mem(i-1)==1)
            count_r=count_r+1;
        end
        if(mem(i+31)==1)
            count_r=count_r+1;
        end
        if(mem(i+32)==1)
            count_r=count_r+1;
        end
        if(count_r < th)
            compare_data(i) = 0;
        end
    end     %end for right
    
    if(i==1024)     %i=1024
        if(mem(i-32)==1)
            count_r=count_r+1;
        end
        if(mem(i-33)==1)
            count_r=count_r+1;
        end
        if(mem(i-1)==1)
            count_r=count_r+1;
        end
        if(count_r < th)
            compare_data(i) = 0;
        end
    end     %end i=1024
    
    if(i>993 && i<1024)    %end btm
        if(mem(i-1)==1)
            count_r=count_r+1;
        end
        if(mem(i-33)==1)
            count_r=count_r+1;
        end
        if(mem(i-32)==1)
            count_r=count_r+1;
        end
        if(mem(i-31)==1)
            count_r=count_r+1;
        end
        if(mem(i+1)==1)
            count_r=count_r+1;
        end
        if(count_r < th)
            compare_data(i) = 0;
        end
    end     %end btm
    if(i~=1 && i>32 && mod(i,32)~=1 && i~=1024 && i~=993 && mod(i,32)~=0 && i<993) % else
        if(mem(i-1)==1)
            count_r=count_r+1;
        end
        if(mem(i-33)==1)
            count_r=count_r+1;
        end
        if(mem(i-32)==1)
            count_r=count_r+1;
        end
        if(mem(i-31)==1)
            count_r=count_r+1;
        end
        if(mem(i+1)==1)
            count_r=count_r+1;
        end
        if(mem(i+33)==1)
            count_r=count_r+1;
        end
        if(mem(i+32)==1)
            count_r=count_r+1;
        end
        if(mem(i+31)==1)
            count_r=count_r+1;
        end
        if(count_r < th)
            compare_data(i) = 0;
        end
    end     %else
    
end  %end for

mem = compare_data;     %Scratchpad
recover_data = data_extract;

for i=1:size(data_extract,3)
    Diff_sum = 0;   %save disstance
    Diff_th = 100000;        %
    Diff_U=[];
    Diff_V=[];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if(i==1 && mem(i) ==1)            %i=0;    
        rr(1) = secert_data_1(i);      
        rr(2) = secert_data_2(i);
        if(mem(i+1)~=1) %right block
            id = i+1;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end %end right block
        if(mem(i+33)~=1)%Button right corner
            id = i+33;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end%Buttom right corner
        if(mem(i+32)~=1)%down
            id = i+32;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end %end down
        %Recover
        g=0;
        for k=1:2
            g = g+rr(k)*Diff_U(:,k)*Diff_V(:,k)';
        end
        g = round(g);
        recover_data(:,:,i) = g;
        mem(i)=0;
    end % i=0
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if(i>1 && i<32  && mem(i) ==1)        %top
        rr(1) = secert_data_1(i);       
        rr(2) = secert_data_2(i);
        if(mem(i+1)~=1) %right block
            id = i+1;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end %end right block
        
        if(mem(i+33)~=1)%Button right corner
            id = i+33;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end%Buttom right corner
        
        if(mem(i+32)~=1)%down
            id = i+32;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end %end down
        
        if(mem(i+31)~=1)%左下角
            id = i+31;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end%end %左下角
        
        if(mem(i-1)~=1)%left
            id = i-1;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end %end left
        
        %Recover
        g=0;
        for k=1:2
            g = g+rr(k)*Diff_U(:,k)*Diff_V(:,k)';
        end
        g = round(g);
        recover_data(:,:,i) = g;
        mem(i)=0;
    end   %end top
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if(i==32  && mem(i) ==1)   %i=32       
        rr(1) = secert_data_1(i);        
        rr(2) = secert_data_2(i);
        if(mem(i+32)~=1)%down
            id = i+32;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end %end down
        
        if(mem(i+31)~=1)%左下角
            id = i+31;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end%end %左下角
        
        if(mem(i-1)~=1)%left
            id = i-1;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end %end left
        
        %Recover
        g=0;
        for k=1:2
            g = g+rr(k)*Diff_U(:,k)*Diff_V(:,k)';
        end
        g = round(g);
        recover_data(:,:,i) = g;
        mem(i)=0;
    end % end i=32
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if(i>1 && mod(i,32)==1 && i~=993  && mem(i) ==1)    %left        
        rr(1) = secert_data_1(i);      
        rr(2) = secert_data_2(i);     
        
        if(mem(i-32)~=1)%top
            id = i-32;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end%end top
        
        if(mem(i-31)~=1)%top right
             id = i-31;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end%end top right
        
         if(mem(i+1)~=1) %right block
            id = i+1;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end %end right block
        
        if(mem(i+33)~=1)%Button right corner
            id = i+33;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end%Buttom right corner
        
        if(mem(i+32)~=1)%down
            id = i+32;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end %end down
        
         %Recover
        g=0;
        for k=1:2
            g = g+rr(k)*Diff_U(:,k)*Diff_V(:,k)';
        end
        g = round(g);
        recover_data(:,:,i) = g;
        mem(i)=0;
    end     %end for left
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if(i==993  && mem(i) ==1)  %i=993
        rr(1) = secert_data_1(i);
        rr(2) = secert_data_2(i);
        
        if(mem(i-32)~=1)%top
            id = i-32;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end%end top
        
        if(mem(i-31)~=1)%top right
             id = i-31;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end%end top right
        
         if(mem(i+1)~=1) %right block
            id = i+1;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end %end right block
        
         %Recover
        g=0;
        for k=1:2
            g = g+rr(k)*Diff_U(:,k)*Diff_V(:,k)';
        end
        g = round(g);
        recover_data(:,:,i) = g;
        mem(i)=0;
    end  %end i=993
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if(i~=32 && mod(i,32)==0 && i~=1024  && mem(i) ==1)    %right
        rr(1) = secert_data_1(i);
        rr(2) = secert_data_2(i);
        
        if(mem(i+32)~=1)%down
            id = i+32;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end %end down
        
         if(mem(i+31)~=1)%左下角
            id = i+31;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end%end %左下角
        
         if(mem(i-1)~=1)%left
            id = i-1;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end %end left
        
        if(mem(i-33)~=1)%左上
            id = i-33;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end%end 左上
        
         if(mem(i-32)~=1)%top
            id = i-32;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end%end top
        
         %Recover
        g=0;
        for k=1:2
            g = g+rr(k)*Diff_U(:,k)*Diff_V(:,k)';
        end
        g = round(g);
        recover_data(:,:,i) = g;
        mem(i)=0;
    end     %end for right
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if(i==1024  && mem(i) ==1)     %i=1024         
        rr(1) = secert_data_1(i);        
        rr(2) = secert_data_2(i);
        
         if(mem(i-1)~=1)%left
            id = i-1;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end %end left
        
        if(mem(i-33)~=1)%左上
            id = i-33;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end%end 左上
        
         if(mem(i-32)~=1)%top
            id = i-32;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end%end top
        
         %Recover
        g=0;
        for k=1:2
            g = g+rr(k)*Diff_U(:,k)*Diff_V(:,k)';
        end
        g = round(g);
        recover_data(:,:,i) = g;
        mem(i)=0;
    end     %end i=1024
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
    if(i>993 && i<1024  && mem(i) ==1)    %end btm        
        rr(1) = secert_data_1(i);         
        rr(2) = secert_data_2(i);
        
         if(mem(i-1)~=1)%left
            id = i-1;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end %end left
        
        if(mem(i-33)~=1)%左上
            id = i-33;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end%end 左上
        
         if(mem(i-32)~=1)%top
            id = i-32;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end%end top
        if(mem(i-31)~=1)%top right
             id = i-31;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end%end top right
        
         if(mem(i+1)~=1) %right block
            id = i+1;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end %end right block
        
         %Recover
        g=0;
        for k=1:2
            g = g+rr(k)*Diff_U(:,k)*Diff_V(:,k)';
        end
        g = round(g);
        recover_data(:,:,i) = g;
        mem(i)=0;
    end     %end btm
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if(i~=1 && i>32 && mod(i,32)~=1 && i~=1024 && i~=993 && mod(i,32)~=0 && i<993  && mem(i) ==1) % else      
        rr(1) = secert_data_1(i);  
        rr(2) = secert_data_2(i);
        
        if(mem(i-1)~=1)%left
            id = i-1;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end %end left
        
        if(mem(i-33)~=1)%左上
            id = i-33;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end%end 左上
        
         if(mem(i-32)~=1)%top
            id = i-32;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end%end top
        if(mem(i-31)~=1)%top right
             id = i-31;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end%end top right
        
         if(mem(i+1)~=1) %right block
            id = i+1;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end %end right block
        
         if(mem(i+33)~=1)%Button right corner
            id = i+33;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end%Buttom right corner
        
        if(mem(i+32)~=1)%down
            id = i+32;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end %end down
        if(mem(i+31)~=1)%左下角
            id = i+31;
            [U,S,V] = svd(double(recover_data(:,:,id)));
            Diff_sum = Diff_sum + (abs(fix(S(1,1)) - rr(1)))*0.7;
            Diff_sum = Diff_sum + (abs(fix(S(2,2)) - rr(2)))*0.3;
            if(Diff_sum < Diff_th)
                Diff_th = Diff_sum;
                Diff_U = U;
                Diff_V = V;
            end%end
            Diff_sum =0;
        end%end %左下角
        
         %Recover
        g=0;
        for k=1:2
            g = g+rr(k)*Diff_U(:,k)*Diff_V(:,k)';
        end
        g = round(g);
        recover_data(:,:,i) = g;
        mem(i)=0;
    end     %else
end %end for

%output detect image
count =1;
detect_image = [];
for i=1:8:size(bb,1)
    for j=1:8:size(bb,2)
        if(compare_data(count)==1)
            detect_image(i:i+7,j:j+7) = 0;
        else
            detect_image(i:i+7,j:j+7) = 255;
        end
        count = count+1;
    end
end
imwrite(detect_image,'Detect_Image.bmp');

%output RecoverImage
%Recover_image=bb;
recover_data = uint8(recover_data);
ff=1;
for i=1:8:256
    for j=1:8:256
        Recover_image(i:i+7,j:j+7) =recover_data(1:8,1:8,ff);   %HideImage
        ff = ff+1;
    end
end
imwrite(Recover_image,'Recvore_image.bmp');
psnr(Recover_image,I)


%產生qr code 依序 產生區塊S1 和 S2
clear();
% I = imread('Lena.jpg');
I = imread('Sailboat.bmp');

% Devide block into martix x
count =1;
for i=1:4:size(I,1)
    for j=1:4:size(I,2)
        x(:,:,count) =I(i:i+3,j:j+3); %spilt origin image in x martix
        count=count+1;
    end
end

%clean LSB1 to 0 from matrix x
for g=1:count-1
    for i=1:4
        for j=1:4
            x1 = dec2bin(x(i,j,g))-48;
            if(x1(length(x1))==1)
                x(i,j,g) = x(i,j,g)-1;
            end
        end
    end
end

% Generate Secert code (SVD) and store in matrix S1 and S2 and Claculate
% Diff
count =1;
for i=1:2:size(x,3)
    [U S V] = svd(double(x(:,:,i)));
    [A B C] = svd(double(x(:,:,i+1)));
    if(count <=1024)
        S1(count) = fix((fix(S(1,1)) + fix(B(1,1)))/2);
        if(count==1)
            Secert_Diff_1(count) = S1(count);
            count = count+1;
        else
            Secert_Diff_1(count) = S1(count) - S1(count-1);
            count = count+1;
        end
    else
         S2(count-1024) = fix((fix(S(1,1)) + fix(B(1,1)))/2);
        if(count==1025)
            Secert_Diff_2(count-1024) = S2(count-1024);
            count = count+1;
        else
            Secert_Diff_2(count-1024) = S2(count-1024) - S2(count-1-1024);
            count = count+1;
        end
    end
end

% out put int to txt
f1 = fopen('Secert_1.txt','w');
f2 = fopen('Secert_2.txt','w');
for i=1:size(Secert_Diff_1,1)
    fprintf(f1,'%d ',Secert_Diff_1);
    fprintf(f2,'%d ',Secert_Diff_2);
end
fclose(f1);
fclose(f2);

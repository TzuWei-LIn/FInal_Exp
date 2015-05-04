rd = importdata('Secert_Rand.mat');
I = imread('Lena.jpg');

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
    for i=1:4        for j=1:4
            x1 = dec2bin(x(i,j,g))-48;
            if(x1(length(x1))==1)
                x(i,j,g) = x(i,j,g)-1;
            end
        end
    end
end

% Generate Secert code (SVD) and store in matrix S1 and S2 and Claculate
% Diff
for i=1:size(x,3)
    [U S V] = svd(double(x(:,:,i)));
    S1(i) = fix(S(1,1));
    S2(i) = fix(S(2,2));
    
    %     Calculate Diff and store in Secert_Diff_1 and Secert_Diff_2
    if(i==1)
        Secert_Diff_1(i) = S1(i);
        Secert_Diff_2(i) = S2(i);
    else
        Secert_Diff_1(i) = S1(i) - S1(i-1);
        Secert_Diff_2(i) = S2(i) - S2(i-1);
    end
end

% out put int to txt
f1 = fopen('Secert_1.txt','w');
f2 = fopen('Secert_2.txt','w');
for i=1:size(Secert_Diff_1,1)
    fprintf(f1,'%d ',Secert_Diff_1);
    fprintf(f2,'%d ',Secert_Diff_2);
end

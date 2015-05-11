clear();
rd = importdata('Secert_Rand.mat');

I = imread('Lena.jpg');
Img_qr1 = rgb2gray(imread('Secert_1.jpg'));
Img_qr2 = rgb2gray(imread('Secert_2.jpg'));

% Devide block into martix x
count =1;
for i=1:8:size(I,1)
    for j=1:8:size(I,2)
        x(:,:,count) =I(i:i+7,j:j+7); %spilt origin image in x martix
        count=count+1;
    end
end

%clean LSB1 to 0 from matrix x
for g=1:count-1
    for i=1:8
        for j=1:8
            x1 = dec2bin(x(:,:,g))-48;
            if(x1(length(x1))==1)
                x(i,j,g) = x(i,j,g)-1;
            end
        end
    end
end

%Hide Qr code
tmp = Img_qr1;
tmp2 = Img_qr2;
secert = [reshape(tmp',1,numel(tmp)) reshape(tmp2',1,numel(tmp2))];
total = (size(Img_qr1,1)*size(Img_qr1,2)) + (size(Img_qr2,1)*size(Img_qr2,2));
count=1;
Img_H = I;
for i=1:256
    for j=1:256
        if(secert(count) == 255)
            Img_H(i,j) = Img_H(i,j)+1;
        end
        count = count+1;
        if(count > total)
            break;
        end
    end
    if(count > total)
        break;
    end
end

imwrite(Img_H,'Fuck.bmp');
clear();
rd = importdata('Secert_Rand.mat');

I = imread('Lena.jpg');
Img_H = I;
Img_qr1 = rgb2gray(imread('Secert_1.jpg'));
Img_qr2 = rgb2gray(imread('Secert_2.jpg'));

%clean LSB1 to 0 from matrix x
    for i=1:256
        for j=1:256
            x1 = dec2bin(Img_H(i,j))-48;
            if(x1(length(x1))==1)
                Img_H(i,j) = Img_H(i,j)-1;
            end
        end
    end

%Hide Qr code
tmp = Img_qr1;
tmp2 = Img_qr2;
secert = [reshape(tmp',1,numel(tmp)) reshape(tmp2',1,numel(tmp2))];
total = (size(Img_qr1,1)*size(Img_qr1,2)) + (size(Img_qr2,1)*size(Img_qr2,2));
count=1;

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

%output
oo = [total size(Img_qr1,1)*size(Img_qr1,2) size(Img_qr2,1)*size(Img_qr2,2) size(Img_qr1,2) size(Img_qr2,2)];
f1 = fopen('total.txt','w');
for i=1:size(oo,2)
    fprintf(f1,'%d ',oo(1,i));
end
imwrite(Img_H,'Fuck.bmp');
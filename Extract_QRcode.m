clear();
Img_H = imread('Fuck.bmp');
[test] = textread('total.txt','%s','headerlines',0);
total_size(1,1:5) = cellfun(@str2num,test) ;    %取出來的認證碼存在secert_data_1
count=1;

%Extract QR code
total = total_size(1,1);%181*180+164*164
secert1=[];
secert2=[];
for i=1:size(Img_H,1)
    for j=1:size(Img_H,2)
        if(count <= total_size(1,2))
            if(mod(Img_H(i,j),2) == 0)
                secert1(count) = 0;
            else
                secert1(count) = 255;
            end
        else
            if(mod(Img_H(i,j),2) == 0)
                secert2(count-total_size(1,2)) = 0;
            else
                secert2(count-total_size(1,2)) = 255;
            end
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

%
ex1 = vec2mat(secert1,total_size(1,4));
ex2 = vec2mat(secert2,total_size(1,5));
imwrite(ex1,'ex1.bmp');
imwrite(ex2,'ex2.bmp');
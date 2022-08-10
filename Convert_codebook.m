clc; close all; clear all;

W_read=readmatrix('temp.csv');

MyCodeBook=round((readmatrix('temp.csv')+(1+1i))*31);

%Mag = abs(MyCodeBook);   %magnitude
%Phase = angle(MyCodeBook); %phase angle

%% separating I and Q.
MyCodeBookReal=real(MyCodeBook);
MyCodeBookImg=imag(MyCodeBook);

%% convert the dec value to Hex value.
HexReal=dec2hex(MyCodeBookReal);
HexImg=dec2hex(MyCodeBookImg);

%% Combine real and img based on the pisition of the antenna.
sizeOfLoop=size(HexImg,1)/16;
ColCounter=1;

s1='0x';
s2=',0x';
HexRealChar = strcat(s1,HexReal);
HexImgChar = strcat(s2,HexImg,',');
MixedCBNum=[HexRealChar HexImgChar];

%MixedCBNum2(1,1:10,1)=MixedCBNum(1,:);
row=1;
for j=1:sizeOfLoop
    charNum=1;
    if mod(row,16)==0
        row=1;
    
    else
       row=row+1;
    end
    for i = 1:16
        
        MixedCBNum2(j,charNum:(charNum+9))=MixedCBNum(ColCounter,:);
        ColCounter=ColCounter+1;
        charNum=charNum+10;
        
    end
end
writematrix(MixedCBNum2,'Final.txt'); 


 %out= sprintf('%X%X',HexReal(:,ColCounter) ,HexImg(:,ColCounter) );
 %MixedCBNum2(i,j)=strcat(HexReal(ColCounter,:),HexImg(ColCounter,:));
 %MixedCBNum2(i,j)=HexReal(ColCounter,:)+' '+HexImg(ColCounter,:);















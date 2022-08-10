clc; clear; close all;

%% step 1
fc = 28e9;
c = physconst('LightSpeed');
lam = c/fc;
test=phased.URA([2 8],0.5*lam);
pos=getElementPosition(test);%inja ye matrise 3x16 mide ke sotoonesh be tartib mishe x,y,z va oon 16 ta marboot be position ha mishe
SV=zeros(16,64);
%SV(:,1)= steervec(pos,[0;0]);
for i=1:64
degree=i*1.6875-54;
SV(:,i) = steervec(pos/lam,(degree));%example Azim 30° elev 10°
end
L=16; % number of element

% figure;
% viewArray(test,'ShowNormals',true,'Title','Uniform Rectangular Array (URA)')
% set(gca,'color','w');
% view(0,90)
% rotate3d on

%% implementing BF- step 2
BF_codebook=zeros(64,1);
W_out=zeros(16,64);
quantized=zeros(16,64);
W_angle=zeros(16,64);
for i=1:64
[W,BF_out]= Conv_BF(L,SV(:,i));
BF_codebook(i)=BF_out;
W_out(:,i)=W;
W_angle(:,i)=rad2deg(angle(W)); %%step 3-atan2(img(BF_codebook(1)),real(BF_codebook(1)))  phase angle
[index,quantized(:,i)] = Quantize_beam(W_angle(:,i)); %%quantizing- step 4
index;
end
quantizedShift=quantized;
quantizedShift(2,:)=quantized(2,:)-90;
quantizedShift(5,:)=quantized(5,:)-180;
quantizedShift(6,:)=quantized(6,:)+90;
quantizedShift(8,:)=quantized(8,:)-90;
quantizedShift(9,:)=quantized(9,:)-90;
quantizedShift(11,:)=quantized(11,:)+90;
quantizedShift(12,:)=quantized(12,:)-90;
quantizedShift(14,:)=quantized(14,:)+90;
quantizedShift(15,:)=quantized(15,:)-90;
quantizedShift(16,:)=quantized(16,:)+90;

temp_mat=quantizedShift;
map_vect=[16,15,14,13,12,11,10,9,7,8,5,6,3,4,1,2];
for i=1:16
    quantizedShift(i,:)=temp_mat(map_vect(i),:);
end


quantized_shift=deg2rad(quantizedShift-2);
%writematrix(SV,'temp.csv'); 
%% step 5,6
W_quant=cos(quantized_shift)+1i*sin(quantized_shift);
% W_quant_not_shifted=cos(quantized)+1i*sin(quantized);
writematrix(W_quant,'temp.csv'); 
%%step 6
%quantized_CB=comp_num;

%% array patterns




% figure,
% pattern(test,fc,'Weights',W_out(:,32),...  
%     'CoordinateSystem','polar','EL',0);
% 
% 
% hold on
% pattern(test,fc,'Weights',W_out(:,33),...  
%     'CoordinateSystem','polar','EL',0);
% 
% hold on
% pattern(test,fc,'Weights',W_out(:,34),...  
%     'CoordinateSystem','polar','EL',0);
% hold on
% pattern(test,fc,'Weights',W_out(:,35),...  
%     'CoordinateSystem','polar','EL',0);
% 
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% figure,
% pattern(test,fc,'Weights',W_quant(:,32),...  % fig3
%     'CoordinateSystem','polar','EL',0);
% hold on
% pattern(test,fc,'Weights',W_quant(:,33),...  % fig3
%     'CoordinateSystem','polar','EL',0);
% hold on
% pattern(test,fc,'Weights',W_quant(:,34),...  % fig3
%     'CoordinateSystem','polar','EL',0);
% hold on
% pattern(test,fc,'Weights',W_quant(:,35),...  % fig3
%     'CoordinateSystem','polar','EL',0);
% hold on



figure,
pattern(test,fc,'Weights',W_out(:,33),...  % fig3
    'CoordinateSystem','polar','EL',0);
hold on
pattern(test,fc,'Weights',W_quant(:,33),...  % fig3
    'CoordinateSystem','polar','EL',0);
%legend('Ideal','quantized')
[pat,az,el]=pattern(test,fc,'Weights',W_out(:,33),...  % fig3
    'CoordinateSystem','polar','EL',0);
[value,index]=max(pat);

beam_dir=az(index);

%writematrix(W_quant,'Quantized_weight.csv') to write quantized beam in a csv file



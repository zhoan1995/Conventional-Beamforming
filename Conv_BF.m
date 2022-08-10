function [W,BF_out] = Conv_BF(L,SV)
%% play with this :)
%this function give weghts to the steering vectors.
W=SV/L; %array weights of the conventional beam former 
W_H=W';
BF_out=W_H*W;

end


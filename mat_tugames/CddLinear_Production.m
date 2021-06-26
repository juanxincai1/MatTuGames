function [v,x]=CddLinear_Production(A,mB,p)
% CDD_LINEAR_PRODUCTION computes from a production problem (A,mB,p) a linear production game using cddmex.
%
% SOURCE: G. Owen, "On the core of linear production games", Mathematics of
%            Operations Research vol. 9, (1975) 358{370.
%
% Usage: [v,x]=CddLinear_Production(A,mB,p)
%
% Define variables:
% output:
%  v        -- A Tu-Game v of length 2^n-1. 
%  x        -- A matrix of optimal solution vectors for all
%              coalition S.
% input: 
%  A        -- Production coefficient matrix of size (qxr) w.r.t. inequalities.
%  mB       -- Resource matrix of size (nxq) w.r.t. inequalities.
%  p        -- Price vector of produced goods of size (1xr).
%
%
% Example:
% Define a production coefficient matrix A by
% A =
%    0.2500   0.1000
%    8.0000   5.0000
%    4.0000   6.0000
%
% and a resource matrix mB by
% mB = 
%     9   260   200
%     5   120   200
%    14   590   400    
%
% Finally, consider the price vector of the r-goods through
% p = 
%     200   150    
%
% Now, invoke
%  v=CddLinear_Production(A,mB,p)
% to get
% v =
%    1.0e+04 *
%
%    0.7000    0.3600    1.1000    1.4000    2.2091    1.9500    2.6500
%
%


%
%  Author:        Holger I. Meinhardt (hme)
%  E-Mail:        Holger.Meinhardt@wiwi.uni-karlsruhe.de
%  Institution:   University of Karlsruhe (KIT)  
%
%  Record of revisions:
%   Date              Version         Programmer
%   ====================================================
%   03/17/2021        1.9             hme
%

A1=A;
[q,r]=size(A1);
[n,~]=size(mB);
N=2^n-1;
v=zeros(1,N);
x=zeros(N,r);
l=1:q;
% objective function
C=-p;  % max problem
% lower boundary
A2=eye(r);
A3=-A2;
B1=zeros(r,1);
B2=inf(r,1);
A=[A1;A3;A2];
objective=C;

% Setting constraints;
adm=zeros(q,N);
for kk=1:q
    qrs=mB(:,kk)';
    adm(kk,:)=additive_game(qrs);
end



% Sub-Problems
it=0:-1:1-n;
k=1:n;
for S=1:N
   % Matrix and boundary vector for coalition S.
   mB1=adm(:,S);
   B=[mB1;B1;B2];
   objective=C;
   IN=struct('obj',objective,'A',A,'B',B);
   OUT = cddmex('solve_lp_DS',IN);
   xmax=OUT.xopt;
   v(S)=p*xmax;
   x(S,:)=xmax';
end
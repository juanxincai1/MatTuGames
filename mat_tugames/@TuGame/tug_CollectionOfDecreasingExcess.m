function SOL=tug_CollectionOfDecreasingExcess(clv,y)
% TUG verifies game solution/property with the Mathematica Package TuGames.
%
% Usage: SOL=tug_CollectionOfDecreasingExcess(v,y)
% Define variables:
%  output:
%  SOL          -- An excess vector of length 2^n-1 in decreasing order.
%                  Field variable gives result in Matlab and Mathematica format.
%  input:
%  clv          -- TuGame class object.
%  y            -- A payoff vector of length (1xn).
%

%  Author:        Holger I. Meinhardt (hme)
%  E-Mail:        Holger.Meinhardt@wiwi.uni-karlsruhe.de
%  Institution:   University of Karlsruhe (KIT)
%
%  Record of revisions:
%   Date              Version         Programmer
%   ====================================================
%   11/01/2012        0.3             hme
%   07/02/2021        1.9             hme
%

v=clv.tuvalues;
N=clv.tusize;
n=clv.tuplayers;
if nargin < 2
   if isa(clv,'TuSol')
      y=clv.tustpt;
   elseif isa(clv,'p_TuSol')
      y=clv.tustpt;
   else
      y=(v(N)/n)*ones(1,n);
   end
   if isempty(y)
     y=(v(N)/n)*ones(1,n);
   end
end

math('quit')
pause(1)
math('$Version')
try 
    math('{Needs["TUG`"] }'); 
catch 
    math('{Needs["coop`CooperativeGames`"],Needs["VertexEnum`"],Needs["TuGames`"],Needs["TuGamesAux`"] }'); 
end
disp('Passing Game to Mathematica ...')
w=gameToMama(clv);
math('matlab2math','mg1',w);
math('matlab2math','n1',n);
math('matlab2math','x1',y);
math('bds=Flatten[n1][[1]]');
math('stx=Flatten[x1]');
math('T=Flatten[Range[n1]]');
math('{T,mg=FlattenAt[PrependTo[mg1,0],2];}');
math('ExpGame:=(DefineGame[T,mg];);');
math('rtx=Rationalize[stx]');
exc_w=math('exc01=CollectionOfDecreasingExcess[ExpGame,rtx]');
lg_ew=math('lg=Length[exc01]');
%for k=1:lg_ew
%  exc_v{k}=math('matlab2math','exc01[[k]]',k)
%end
exc_v=[];
SOL=struct('CollectionOfDecreasingExcess',exc_v,'MCollectionOfDecreasingExcess',exc_w);
math('quit')

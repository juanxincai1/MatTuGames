function SOL=tug_KernelCalculation(v)
% TUG verifies game solution/property with the Mathematica Package TuGames.
%
% Usage: SOL=tug_KernelCalculation(v)
% Define variables:
%  output:
%  SOL        -- A kernel element of game v and a list of kernel candidates.
%                Field variable gives result in Matlab and Mathematica format.
%  input:
%  v          -- A Tu-Game v of length 2^n-1.
%
%

%  Author:        Holger I. Meinhardt (hme)
%  E-Mail:        Holger.Meinhardt@wiwi.uni-karlsruhe.de
%  Institution:   University of Karlsruhe (KIT)
%
%  Record of revisions:
%   Date              Version         Programmer
%   ====================================================
%   03/06/2011        0.1 beta        hme
%   07/02/2021        1.9             hme
%

% Here we assume that the user has represented the game correctly.
if nargin<1
    error('At least the game must be given!');
elseif nargin<2
N=length(v);
gr=dec2bin(N);
n=length(gr);
    if (2^n-1)~=N
      error('Game has not the correct size!');
    end
else
    N=length(v);
    gr=dec2bin(N);
    n=length(gr);
    if (2^n-1)~=N
       error('Game has not the correct size!');
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
w=gameToMama(v);
math('matlab2math','mg1',w);
math('matlab2math','n1',n);
math('bds=Flatten[n1][[1]]');
math('T=Flatten[Range[n1]]');
math('{T,mg=FlattenAt[PrependTo[mg1,0],2];}');
math('ExpGame:=(DefineGame[T,mg];);');
disp('Computing the Kernel ...')
math('sceps=SecondCriticalVal[ExpGame]');
math('{solker,pay}=KernelCalculation[ExpGame,EpsilonValue->sceps[[1,2]]]');
ker_el=math('solker');
cand=math('pay');
ker_cand=math('math2matlab','pay');
ker01_v=math('math2matlab','solker');
SOL=struct('Kernel',ker01_v,'MKernel',ker_el,'KernelCandidates',ker_cand,'MKernelCandidates',cand);
math('quit')

 addpath('_MATLAB_scripts/');

CaseList={  '5MW_OC4Semi_WSt_WavesWN', ...
            '5MW_OC3Spar_DLL_WTurb_WavesIrr',...
            '5MW_TLP_DLL_WTurb_WavesIrr_WavesMulti', ...
            '5MW_ITIBarge_DLL_WTurb_WavesIrr'};
% RegTestMainDir='OpenFAST_reg-test/';
% HDTestDir='HD_reg-test/';
RegTestMainDir='build-DP-gcc7/reg_tests/glue-codes/openfast/';
HDTestDir='reg_tests/r-test/modules/hydrodyn/';
HDTestDir='build-DP-gcc7/reg_tests/modules/hydrodyn/';
OutFileName='OpenFAST_DisplacementTimeseries.dat';

DiffTable.ChanNames={...
    'Wave1Elev',...
    'HydroFxi' ,...
    'HydroFyi' ,...
    'HydroFzi' ,...
    'HydroMxi' ,...
    'HydroMyi' ,...
    'HydroMzi' ,...
    'WRPSurge' ,...
    'WRPSway'  ,...
    'WRPHeave' ,...
    'WRPRoll'  ,...
    'WRPPitch' ,...
    'WRPYaw'   ,...
    'WRPTVxi'  ,...
    'WRPTVyi'  ,...
    'WRPTVzi'  ,...
    'WRPRVxi'  ,...
    'WRPRVyi'  ,...
    'WRPRVzi'  ,...
    'WRPTAxi'  ,...
    'WRPTAyi'  ,...
    'WRPTAzi'  ,...
    'WRPRAxi'  ,...
    'WRPRAyi'  ,...
    'WRPRAzi'  ,...
    'WavesFxi' ,...
    'WavesFyi' ,...
    'WavesFzi' ,...
    'WavesMxi' ,...
    'WavesMyi' ,...
    'WavesMzi' ,...
    'HdrStcFxi',...
    'HdrStcFyi',...
    'HdrStcFzi',...
    'HdrStcMxi',...
    'HdrStcMyi',...
    'HdrStcMzi',...
    'RdtnFxi'  ,...
    'RdtnFyi'  ,...
    'RdtnFzi'  ,...
    'RdtnMxi'  ,...
    'RdtnMyi'  ,...
    'RdtnMzi'  };

%% Data difference table
DiffTable.Diff=zeros(size(CaseList,2),size(DiffTable.ChanNames,2));
DiffTable.Percent=DiffTable.Diff;
DiffTable.Range=DiffTable.Diff;
DiffTable.CaseList=CaseList';
for i=1:size(CaseList,2)
   LoadFASTOut([RegTestMainDir CaseList{i} '/' CaseList{i} '.out'],[HDTestDir 'hd_' CaseList{i} '/driver.HD.out']);
   for j=1:size(DiffTable.ChanNames,2)
      Ref=FASTDataSet(1).FASTData(:,GetChanNum(DiffTable.ChanNames{j},1));
      Test=FASTDataSet(2).FASTData(:,GetChanNum(DiffTable.ChanNames{j},2));
      DiffTable.Range(i,j)=max(Ref)-min(Ref);
      DiffTable.Diff(i,j)=max(abs(Test-Ref));
      DiffTable.Percent(i,j)=DiffTable.Diff(i,j)/DiffTable.Range(i,j);
   end
end
% Now to generate a nice table
disp('Difference');
   % header line
txt='';
for i=1:size(DiffTable.CaseList,1)
   txt=[txt char(9) DiffTable.CaseList{i} char(9)];
end
disp(txt);
   % diff sub header line
txt='';
for i=1:size(DiffTable.CaseList,1)
   txt=[txt char(9) 'Abs diff' char(9) '% diff'];
end
disp(txt);
   % table itself
for j=1:size(DiffTable.ChanNames,2)
   txt=DiffTable.ChanNames{j};
   for i=1:size(DiffTable.CaseList,1)
      txt=[txt char(9) num2str(DiffTable.Diff(i,j)) char(9) num2str(DiffTable.Percent(i,j)*100)];
   end
   disp(txt);
end


%%
i=4;
LoadFASTOut([RegTestMainDir CaseList{i} '/' CaseList{i} '.out'],[HDTestDir 'hd_' CaseList{i} '/driver.HD.out']);
for i=3:size(FASTDataSet(2).HeadNames)
   Chan=FASTDataSet(2).HeadNames{i};
   PlotFAST('Time',Chan);
   legend({'OpenFAST coupled simulation','HdyroDyn\_driver'});
end



%%
figure;
Chan='HydroMxi';
plot(FASTDataSet(2).FASTData(:,1),FASTDataSet(2).FASTData(:,GetChanNum(Chan,2))-FASTDataSet(1).FASTData(:,GetChanNum(Chan,1)));
xlabel('Time (sec)');
ylabel(['Difference: ' FASTDataSet(2).HeadUnits{GetChanNum(Chan,2)}]);
% ylabel('Difference: (kN)');
title('HydroDyn\_driver - OpenFAST');
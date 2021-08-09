% Junta arquivos de cada ensaio em uma única cell array

fPathCell = {
% %              {'\Amostra A1\N_2019_07_01';}
%              {'\Amostra A2\A_2019_08_08';
% %              '\Amostra A2\A_2019_08_12';
%              '\Amostra A2\A_2019_08_28';
%              '\Amostra A2\N_2019_07_09';}
%              {'\Amostra A3\A_2019_12_09';
%              '\Amostra A3\A_2019_12_11';
%              '\Amostra A3\N_2019_12_04';}
%              {'\Amostra A4\A_2019_12_19';
%              '\Amostra A4\A_2020_01_06';
% %              '\Amostra A4\A_2020_01_13';
%              '\Amostra A4\N_2019_12_16';}
%              {'\Amostra A5\A_2020_01_27';
%              '\Amostra A5\A_2020_01_28';
%              '\Amostra A5\N_2020_01_22';}
%               {'\Amostra B2\A_2020_09_02';
%               '\Amostra B2\A_2020_09_09'};
%               {'\Amostra B3\A_2020_09_22';
%               '\Amostra B3\A_2020_09_24';
%               '\Amostra B3\N_2020_09_11';};
%               {'\Amostra B4\A_2020_10_02';
%               '\Amostra B4\A_2020_10_06';
%               '\Amostra B4\A_2020_10_08';
%               '\Amostra B4\N_2020_09_30';};
              {'\Amostra B5\A_2020_10_22';
               '\Amostra B5\A_2020_10_27';
               '\Amostra B5\N_2020_10_16';};
              {'\Amostra B7\N_2021_02_05';
               '\Amostra B7\A_2021_02_08';
              '\Amostra B7\A_2021_02_15';};
%               '\Amostra B7\A_2021_07_24';};
              {'\Amostra B8\N_2021_02_18';
              '\Amostra B8\A_2021_02_22';
              '\Amostra B8\A_2021_02_26'};
              {'\Amostra B10\N_2021_03_22';
              '\Amostra B10\A_2021_03_25';
              '\Amostra B10\A_2021_03_30'};
              {'\Amostra B11\N_2021_04_05';
              '\Amostra B11\A_2021_04_08';
              '\Amostra B11\A_2021_04_22'};
              {'\Amostra B12\N_2021_04_27';
              '\Amostra B12\A_2021_04_30';
%               '\Amostra B12\A_2021_05_03'; 
              '\Amostra B12\A_2021_05_04';};
              {'\Amostra B15\N_2021_05_31';
%               '\Amostra B15\A_2021_06_07';
              '\Amostra B15\A_2021_06_09';
              '\Amostra B15\A_2021_06_15';};
              };
         
fpathVarInit = 'D:\Documentos\Amaciamento\Ensaios\Dados Processados (Dissertação)';

EnDataB = cell(length(fPathCell),1);
EnDataB_Acu = cell(length(fPathCell),1);

for k1 = 1:length(fPathCell)
    for k2 = 1:length(fPathCell{k1})
        fP = [fpathVarInit,fPathCell{k1}{k2}];
        load([fP,'\corrente_Curtose']);
        load([fP,'\corrente_RMS']);
        load([fP,'\corrente_Skewness']);
        load([fP,'\corrente_Shape']);
        load([fP,'\corrente_THD']);
        load([fP,'\corrente_Peak']);
        load([fP,'\corrente_Crest']);
        load([fP,'\corrente_Var']);
        load([fP,'\corrente_Std']);
        
        load([fP,'\vibracao_CalotaInf_RMS']);
        load([fP,'\vibracao_CalotaInf_Curtose']);
        load([fP,'\vibracao_CalotaInf_Ske']);
        load([fP,'\vibracao_CalotaInf_Shape']);
        load([fP,'\vibracao_CalotaInf_THD']);
        load([fP,'\vibracao_CalotaInf_Peak']);
        load([fP,'\vibracao_CalotaInf_Crest']);
        load([fP,'\vibracao_CalotaInf_Var']);
        load([fP,'\vibracao_CalotaInf_Std']);
        
        load([fP,'\vibracao_CalotaSup_Curtose']);
        load([fP,'\vibracao_CalotaSup_RMS']);
        load([fP,'\vibracao_CalotaSup_Ske']);
        load([fP,'\vibracao_CalotaSup_Shape']);
        load([fP,'\vibracao_CalotaSup_THD']);
        load([fP,'\vibracao_CalotaSup_Peak']);
        load([fP,'\vibracao_CalotaSup_Crest']);
        load([fP,'\vibracao_CalotaSup_Var']);
        load([fP,'\vibracao_CalotaSup_Std']);
        
        load([fP,'\pressao_Descarga']);
        load([fP,'\pressao_Succao']);
        load([fP,'\vazao']);
        
        
        dat.tempo = pD.t;
        dat.pD = pD.data;
        dat.pS = pS.data;
        
        dat.cRMS = cRMS.data;
        dat.cKur = cKur.data;
        dat.cSke = cSke.data;
        dat.cShape = cShape.data;
        dat.cTHD = cTHD.data;
        dat.cPeak = cPeak.data;
        dat.cCrest = cCrest.data;
        dat.cVar = cVar.data;
        dat.cStd = cStd.data;
        
        dat.vInfRMS = vInfRMS.data;
        dat.vInfKur = vInfKur.data;
        dat.vInfSke = vInfSke.data;
        dat.vInfShape = vInfShape.data;
        dat.vInfTHD = vInfTHD.data;
        dat.vInfPeak = vInfPeak.data;
        dat.vInfCrest = vInfCrest.data;
        dat.vInfVar = vInfVar.data;
        dat.vInfStd = vInfStd.data;
        
        dat.vSupRMS = vSupRMS.data;
        dat.vSupKur = vSupKur.data;
        dat.vSupSke = vSupSke.data;
        dat.vSupShape = vSupShape.data;
        dat.vSupTHD = vSupTHD.data;
        dat.vSupPeak = vSupPeak.data;
        dat.vSupCrest = vSupCrest.data;
        dat.vSupVar = vSupVar.data;
        dat.vSupStd = vSupStd.data;
        
        dat.vaz = vaz.data;
        
        
        dat.name = fPathCell{k1}{k2}(2:end);
        EnDataB{k1}(k2) = dat;
        
%         load([fP,'\acusticas_Curtose']);
%         load([fP,'\acusticas_RMS']);
%         datAcu.tempo = aRMS.t';
%         datAcu.aRMS = aRMS.data;
%         datAcu.aKur = aKur.data;
%         EnDataA_Acu{k1}(k2) = datAcu;
    end
end

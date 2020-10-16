fPathCell = {{'\Amostra B2\A_2020_09_02';
             '\Amostra B2\A_2020_09_09'};
             {'\Amostra B3\A_2020_09_22';
             '\Amostra B3\A_2020_09_24';
             '\Amostra B3\N_2020_09_11';};
             {'\Amostra B4\A_2020_10_02';
             '\Amostra B4\A_2020_10_06';
             '\Amostra B4\N_2020_09_30';};
             };
         
fpathVarInit = 'D:\Documentos\Amaciamento\Ensaios\Dados Processados';

EnDataB = cell(length(fPathCell),1);
EnDataB_Acu = cell(length(fPathCell),1);

for k1 = 1:length(fPathCell)
    for k2 = 1:length(fPathCell{k1})
        fP = [fpathVarInit,fPathCell{k1}{k2}];
        load([fP,'\corrente_Curtose']);
        load([fP,'\corrente_RMS']);
        load([fP,'\vibracao_CalotaInf_Curtose']);
        load([fP,'\vibracao_CalotaInf_RMS']);
        load([fP,'\vibracao_CalotaSup_Curtose']);
        load([fP,'\vibracao_CalotaSup_RMS']);
        load([fP,'\pressao_Descarga']);
        load([fP,'\pressao_Succao']);
        load([fP,'\vazao']);
        dat.tempo = pD.t';
        dat.pD = pD.data;
        dat.pS = pS.data;
        dat.cRMS = cRMS.data;
        dat.cKur = cKur.data;
        dat.vInfRMS = vInfRMS.data;
        dat.vInfKur = vInfKur.data;
        dat.vSupRMS = vSupRMS.data;
        dat.vSupKur = vSupKur.data;
        dat.vaz = vaz.data;
        dat.name = fPathCell{k1}{k2}(2:end);
        EnDataB{k1}(k2) = dat;
        
        load([fP,'\acusticas_Curtose']);
        load([fP,'\acusticas_RMS']);
        datAcu.tempo = aRMS.t';
        datAcu.aRMS = aRMS.data;
        datAcu.aKur = aKur.data;
        EnDataB_Acu{k1}(k2) = datAcu;
    end
end

function [results] = importClusters(filename,amostra)

%% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 109);

% Specify range and delimiter
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Var1", "Tempo", "CorrenteRMSM5_1020", "CorrenteRMSM10_1020", "CorrenteRMSM30_1020", "CorrenteRMSM5_3060", "CorrenteRMSM10_3060", "CorrenteRMSM30_3060", "Var9", "CorrenteCurtoseM5_1020", "CorrenteCurtoseM10_1020", "CorrenteCurtoseM30_1020", "CorrenteCurtoseM5_3060", "CorrenteCurtoseM10_3060", "CorrenteCurtoseM30_3060", "Var16", "CorrenteVarianciaM5_1020", "CorrenteVarianciaM10_1020", "CorrenteVarianciaM30_1020", "CorrenteVarianciaM5_3060", "CorrenteVarianciaM10_3060", "CorrenteVarianciaM30_3060", "Var23", "VibracaoCalotaInferiorRMSM5_1020", "VibracaoCalotaInferiorRMSM10_1020", "VibracaoCalotaInferiorRMSM30_1020", "VibracaoCalotaInferiorRMSM5_3060", "VibracaoCalotaInferiorRMSM10_3060", "VibracaoCalotaInferiorRMSM30_3060", "Tempo4", "VibracaoCalotaInferiorCurtoseM5_1020", "VibracaoCalotaInferiorCurtoseM10_1020", "VibracaoCalotaInferiorCurtoseM30_1020", "VibracaoCalotaInferiorCurtoseM5_3060", "VibracaoCalotaInferiorCurtoseM10_3060", "VibracaoCalotaInferiorCurtoseM30_3060", "Var37", "VibracaoCalotaInferiorVarianciaM5_1020", "VibracaoCalotaInferiorVarianciaM10_1020", "VibracaoCalotaInferiorVarianciaM30_1020", "VibracaoCalotaInferiorVarianciaM5_3060", "VibracaoCalotaInferiorVarianciaM10_3060", "VibracaoCalotaInferiorVarianciaM30_3060", "Var44", "VibracaoCalotaSuperiorRMSM5_1020", "VibracaoCalotaSuperiorRMSM10_1020", "VibracaoCalotaSuperiorRMSM30_1020", "VibracaoCalotaSuperiorRMSM5_3060", "VibracaoCalotaSuperiorRMSM10_3060", "VibracaoCalotaSuperiorRMSM30_3060", "Var51", "VibracaoCalotaSuperiorCurtoseM5_1020", "VibracaoCalotaSuperiorCurtoseM10_1020", "VibracaoCalotaSuperiorCurtoseM30_1020", "VibracaoCalotaSuperiorCurtoseM5_3060", "VibracaoCalotaSuperiorCurtoseM10_3060", "VibracaoCalotaSuperiorCurtoseM30_3060", "Var58", "VibracaoCalotaSuperiorVarianciaM5_1020", "VibracaoCalotaSuperiorVarianciaM10_1020", "VibracaoCalotaSuperiorVarianciaM30_1020", "VibracaoCalotaSuperiorVarianciaM5_3060", "VibracaoCalotaSuperiorVarianciaM10_3060", "VibracaoCalotaSuperiorVarianciaM30_3060", "Var65", "VazaoM5_1020", "VazaoM10_1020", "VazaoM30_1020", "VazaoM5_3060", "VazaoM10_3060", "VazaoM30_3060", "Var72", "lowpassRMSM5_1020", "lowpassRMSM10_1020", "lowpassRMSM30_1020", "lowpassRMSM5_3060", "lowpassRMSM10_3060", "lowpassRMSM30_3060", "Var79", "bandpassRMSM5_1020", "bandpassRMSM10_1020", "bandpassRMSM30_1020", "bandpassRMSM5_3060", "bandpassRMSM10_3060", "bandpassRMSM30_3060", "Var86", "highpassRMSM5_1020", "highpassRMSM10_1020", "highpassRMSM30_1020", "highpassRMSM5_3060", "highpassRMSM10_3060", "highpassRMSM30_3060", "Var93", "lowpassCurtoseM5_1020", "lowpassCurtoseM10_1020", "lowpassCurtoseM30_1020", "lowpassCurtoseM5_3060", "lowpassCurtoseM10_3060", "lowpassCurtoseM30_3060", "Var100", "bandpassCurtoseM5_1020", "bandpassCurtoseM10_1020", "bandpassCurtoseM30_1020", "bandpassCurtoseM5_3060", "bandpassCurtoseM10_3060", "bandpassCurtoseM30_3060", "Var107", "highpassCurtoseM5_1020", "highpassCurtoseM10_1020", "highpassCurtoseM30_1020", "highpassCurtoseM5_3060", "highpassCurtoseM10_3060", "highpassCurtoseM30_3060"];
opts.SelectedVariableNames = ["Tempo", "CorrenteRMSM5_1020", "CorrenteRMSM10_1020", "CorrenteRMSM30_1020", "CorrenteRMSM5_3060", "CorrenteRMSM10_3060", "CorrenteRMSM30_3060", "CorrenteCurtoseM5_1020", "CorrenteCurtoseM10_1020", "CorrenteCurtoseM30_1020", "CorrenteCurtoseM5_3060", "CorrenteCurtoseM10_3060", "CorrenteCurtoseM30_3060", "CorrenteVarianciaM5_1020", "CorrenteVarianciaM10_1020", "CorrenteVarianciaM30_1020", "CorrenteVarianciaM5_3060", "CorrenteVarianciaM10_3060", "CorrenteVarianciaM30_3060", "VibracaoCalotaInferiorRMSM5_1020", "VibracaoCalotaInferiorRMSM10_1020", "VibracaoCalotaInferiorRMSM30_1020", "VibracaoCalotaInferiorRMSM5_3060", "VibracaoCalotaInferiorRMSM10_3060", "VibracaoCalotaInferiorRMSM30_3060", "Tempo4", "VibracaoCalotaInferiorCurtoseM5_1020", "VibracaoCalotaInferiorCurtoseM10_1020", "VibracaoCalotaInferiorCurtoseM30_1020", "VibracaoCalotaInferiorCurtoseM5_3060", "VibracaoCalotaInferiorCurtoseM10_3060", "VibracaoCalotaInferiorCurtoseM30_3060", "VibracaoCalotaInferiorVarianciaM5_1020", "VibracaoCalotaInferiorVarianciaM10_1020", "VibracaoCalotaInferiorVarianciaM30_1020", "VibracaoCalotaInferiorVarianciaM5_3060", "VibracaoCalotaInferiorVarianciaM10_3060", "VibracaoCalotaInferiorVarianciaM30_3060", "VibracaoCalotaSuperiorRMSM5_1020", "VibracaoCalotaSuperiorRMSM10_1020", "VibracaoCalotaSuperiorRMSM30_1020", "VibracaoCalotaSuperiorRMSM5_3060", "VibracaoCalotaSuperiorRMSM10_3060", "VibracaoCalotaSuperiorRMSM30_3060", "VibracaoCalotaSuperiorCurtoseM5_1020", "VibracaoCalotaSuperiorCurtoseM10_1020", "VibracaoCalotaSuperiorCurtoseM30_1020", "VibracaoCalotaSuperiorCurtoseM5_3060", "VibracaoCalotaSuperiorCurtoseM10_3060", "VibracaoCalotaSuperiorCurtoseM30_3060", "VibracaoCalotaSuperiorVarianciaM5_1020", "VibracaoCalotaSuperiorVarianciaM10_1020", "VibracaoCalotaSuperiorVarianciaM30_1020", "VibracaoCalotaSuperiorVarianciaM5_3060", "VibracaoCalotaSuperiorVarianciaM10_3060", "VibracaoCalotaSuperiorVarianciaM30_3060", "VazaoM5_1020", "VazaoM10_1020", "VazaoM30_1020", "VazaoM5_3060", "VazaoM10_3060", "VazaoM30_3060", "lowpassRMSM5_1020", "lowpassRMSM10_1020", "lowpassRMSM30_1020", "lowpassRMSM5_3060", "lowpassRMSM10_3060", "lowpassRMSM30_3060", "bandpassRMSM5_1020", "bandpassRMSM10_1020", "bandpassRMSM30_1020", "bandpassRMSM5_3060", "bandpassRMSM10_3060", "bandpassRMSM30_3060", "highpassRMSM5_1020", "highpassRMSM10_1020", "highpassRMSM30_1020", "highpassRMSM5_3060", "highpassRMSM10_3060", "highpassRMSM30_3060", "lowpassCurtoseM5_1020", "lowpassCurtoseM10_1020", "lowpassCurtoseM30_1020", "lowpassCurtoseM5_3060", "lowpassCurtoseM10_3060", "lowpassCurtoseM30_3060", "bandpassCurtoseM5_1020", "bandpassCurtoseM10_1020", "bandpassCurtoseM30_1020", "bandpassCurtoseM5_3060", "bandpassCurtoseM10_3060", "bandpassCurtoseM30_3060", "highpassCurtoseM5_1020", "highpassCurtoseM10_1020", "highpassCurtoseM30_1020", "highpassCurtoseM5_3060", "highpassCurtoseM10_3060", "highpassCurtoseM30_3060"];
opts.VariableTypes = ["string", "double", "double", "double", "double", "double", "double", "double", "string", "double", "double", "double", "double", "double", "double", "string", "double", "double", "double", "double", "double", "double", "string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "string", "double", "double", "double", "double", "double", "double", "string", "double", "double", "double", "double", "double", "double", "string", "double", "double", "double", "double", "double", "double", "string", "double", "double", "double", "double", "double", "double", "string", "double", "double", "double", "double", "double", "double", "string", "double", "double", "double", "double", "double", "double", "string", "double", "double", "double", "double", "double", "double", "string", "double", "double", "double", "double", "double", "double", "string", "double", "double", "double", "double", "double", "double", "string", "double", "double", "double", "double", "double", "double", "string", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, [1, 9, 16, 23, 37, 44, 51, 58, 65, 72, 79, 86, 93, 100, 107], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [1, 9, 16, 23, 37, 44, 51, 58, 65, 72, 79, 86, 93, 100, 107], "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
tbl = readtable(filename, opts);
tbl = tbl(2:end,:);

%% Convert to output type

n = 1;
Ensaio = nan(length(tbl.Tempo),1);
Ensaio(1) = 1;

for k = 2:length(tbl.Tempo)
    if tbl.Tempo(k)<tbl.Tempo(k-1)
        n=n+1;
    end
    Ensaio(k) = n;
end
Tempo = tbl.Tempo;


cRMS = table();
cRMS = [cRMS;{'cRMS',{Tempo},{Ensaio},3,5,10,{tbl.CorrenteRMSM5_1020}}];
cRMS = [cRMS;{'cRMS',{Tempo},{Ensaio},3,10,10,{tbl.CorrenteRMSM10_1020}}];
cRMS = [cRMS;{'cRMS',{Tempo},{Ensaio},3,30,10,{tbl.CorrenteRMSM30_1020}}];
cRMS = [cRMS;{'cRMS',{Tempo},{Ensaio},3,5,30,{tbl.CorrenteRMSM5_3060}}];
cRMS = [cRMS;{'cRMS',{Tempo},{Ensaio},3,10,30,{tbl.CorrenteRMSM10_3060}}];
cRMS = [cRMS;{'cRMS',{Tempo},{Ensaio},3,30,30,{tbl.CorrenteRMSM30_3060}}];
cRMS.Properties.VariableNames = {'Grandeza','Tempo','Ensaio','N','M','D','Cluster'};

cKur = table();
cKur = [cKur;{'cKur',{Tempo},{Ensaio},3,5,10,{tbl.CorrenteCurtoseM5_1020}}];
cKur = [cKur;{'cKur',{Tempo},{Ensaio},3,10,10,{tbl.CorrenteCurtoseM10_1020}}];
cKur = [cKur;{'cKur',{Tempo},{Ensaio},3,30,10,{tbl.CorrenteCurtoseM30_1020}}];
cKur = [cKur;{'cKur',{Tempo},{Ensaio},3,5,30,{tbl.CorrenteCurtoseM5_3060}}];
cKur = [cKur;{'cKur',{Tempo},{Ensaio},3,10,30,{tbl.CorrenteCurtoseM10_3060}}];
cKur = [cKur;{'cKur',{Tempo},{Ensaio},3,30,30,{tbl.CorrenteCurtoseM30_3060}}];
cKur.Properties.VariableNames = {'Grandeza','Tempo','Ensaio','N','M','D','Cluster'};

cVar = table();
cVar = [cVar;{'cVar',{Tempo},{Ensaio},3,5,10,{tbl.CorrenteVarianciaM5_1020}}];
cVar = [cVar;{'cVar',{Tempo},{Ensaio},3,10,10,{tbl.CorrenteVarianciaM10_1020}}];
cVar = [cVar;{'cVar',{Tempo},{Ensaio},3,30,10,{tbl.CorrenteVarianciaM30_1020}}];
cVar = [cVar;{'cVar',{Tempo},{Ensaio},3,5,30,{tbl.CorrenteVarianciaM5_3060}}];
cVar = [cVar;{'cVar',{Tempo},{Ensaio},3,10,30,{tbl.CorrenteVarianciaM10_3060}}];
cVar = [cVar;{'cVar',{Tempo},{Ensaio},3,30,30,{tbl.CorrenteVarianciaM30_3060}}];
cVar.Properties.VariableNames = {'Grandeza','Tempo','Ensaio','N','M','D','Cluster'};

vibInfRMS = table();
vibInfRMS = [vibInfRMS;{'vibInfRMS',{Tempo},{Ensaio},3,5,10,{tbl.VibracaoCalotaInferiorRMSM5_1020}}];
vibInfRMS = [vibInfRMS;{'vibInfRMS',{Tempo},{Ensaio},3,10,10,{tbl.VibracaoCalotaInferiorRMSM10_1020}}];
vibInfRMS = [vibInfRMS;{'vibInfRMS',{Tempo},{Ensaio},3,30,10,{tbl.VibracaoCalotaInferiorRMSM30_1020}}];
vibInfRMS = [vibInfRMS;{'vibInfRMS',{Tempo},{Ensaio},3,5,30,{tbl.VibracaoCalotaInferiorRMSM5_3060}}];
vibInfRMS = [vibInfRMS;{'vibInfRMS',{Tempo},{Ensaio},3,10,30,{tbl.VibracaoCalotaInferiorRMSM10_3060}}];
vibInfRMS = [vibInfRMS;{'vibInfRMS',{Tempo},{Ensaio},3,30,30,{tbl.VibracaoCalotaInferiorRMSM30_3060}}];
vibInfRMS.Properties.VariableNames = {'Grandeza','Tempo','Ensaio','N','M','D','Cluster'};

vibInfKur = table();
vibInfKur = [vibInfKur;{'vibInfKur',{Tempo},{Ensaio},3,5,10,{tbl.VibracaoCalotaInferiorCurtoseM5_1020}}];
vibInfKur = [vibInfKur;{'vibInfKur',{Tempo},{Ensaio},3,10,10,{tbl.VibracaoCalotaInferiorCurtoseM10_1020}}];
vibInfKur = [vibInfKur;{'vibInfKur',{Tempo},{Ensaio},3,30,10,{tbl.VibracaoCalotaInferiorCurtoseM30_1020}}];
vibInfKur = [vibInfKur;{'vibInfKur',{Tempo},{Ensaio},3,5,30,{tbl.VibracaoCalotaInferiorCurtoseM5_3060}}];
vibInfKur = [vibInfKur;{'vibInfKur',{Tempo},{Ensaio},3,10,30,{tbl.VibracaoCalotaInferiorCurtoseM10_3060}}];
vibInfKur = [vibInfKur;{'vibInfKur',{Tempo},{Ensaio},3,30,30,{tbl.VibracaoCalotaInferiorCurtoseM30_3060}}];
vibInfKur.Properties.VariableNames = {'Grandeza','Tempo','Ensaio','N','M','D','Cluster'};

vibInfVar = table();
vibInfVar = [vibInfVar;{'vibInfVar',{Tempo},{Ensaio},3,5,10,{tbl.VibracaoCalotaInferiorVarianciaM5_1020}}];
vibInfVar = [vibInfVar;{'vibInfVar',{Tempo},{Ensaio},3,10,10,{tbl.VibracaoCalotaInferiorVarianciaM10_1020}}];
vibInfVar = [vibInfVar;{'vibInfVar',{Tempo},{Ensaio},3,30,10,{tbl.VibracaoCalotaInferiorVarianciaM30_1020}}];
vibInfVar = [vibInfVar;{'vibInfVar',{Tempo},{Ensaio},3,5,30,{tbl.VibracaoCalotaInferiorVarianciaM5_3060}}];
vibInfVar = [vibInfVar;{'vibInfVar',{Tempo},{Ensaio},3,10,30,{tbl.VibracaoCalotaInferiorVarianciaM10_3060}}];
vibInfVar = [vibInfVar;{'vibInfVar',{Tempo},{Ensaio},3,30,30,{tbl.VibracaoCalotaInferiorVarianciaM30_3060}}];
vibInfVar.Properties.VariableNames = {'Grandeza','Tempo','Ensaio','N','M','D','Cluster'};

vibSupRMS = table();
vibSupRMS = [vibSupRMS;{'vibSupRMS',{Tempo},{Ensaio},3,5,10,{tbl.VibracaoCalotaSuperiorRMSM5_1020}}];
vibSupRMS = [vibSupRMS;{'vibSupRMS',{Tempo},{Ensaio},3,10,10,{tbl.VibracaoCalotaSuperiorRMSM10_1020}}];
vibSupRMS = [vibSupRMS;{'vibSupRMS',{Tempo},{Ensaio},3,30,10,{tbl.VibracaoCalotaSuperiorRMSM30_1020}}];
vibSupRMS = [vibSupRMS;{'vibSupRMS',{Tempo},{Ensaio},3,5,30,{tbl.VibracaoCalotaSuperiorRMSM5_3060}}];
vibSupRMS = [vibSupRMS;{'vibSupRMS',{Tempo},{Ensaio},3,10,30,{tbl.VibracaoCalotaSuperiorRMSM10_3060}}];
vibSupRMS = [vibSupRMS;{'vibSupRMS',{Tempo},{Ensaio},3,30,30,{tbl.VibracaoCalotaSuperiorRMSM30_3060}}];
vibSupRMS.Properties.VariableNames = {'Grandeza','Tempo','Ensaio','N','M','D','Cluster'};

vibSupKur = table();
vibSupKur = [vibSupKur;{'vibSupKur',{Tempo},{Ensaio},3,5,10,{tbl.VibracaoCalotaSuperiorCurtoseM5_1020}}];
vibSupKur = [vibSupKur;{'vibSupKur',{Tempo},{Ensaio},3,10,10,{tbl.VibracaoCalotaSuperiorCurtoseM10_1020}}];
vibSupKur = [vibSupKur;{'vibSupKur',{Tempo},{Ensaio},3,30,10,{tbl.VibracaoCalotaSuperiorCurtoseM30_1020}}];
vibSupKur = [vibSupKur;{'vibSupKur',{Tempo},{Ensaio},3,5,30,{tbl.VibracaoCalotaSuperiorCurtoseM5_3060}}];
vibSupKur = [vibSupKur;{'vibSupKur',{Tempo},{Ensaio},3,10,30,{tbl.VibracaoCalotaSuperiorCurtoseM10_3060}}];
vibSupKur = [vibSupKur;{'vibSupKur',{Tempo},{Ensaio},3,30,30,{tbl.VibracaoCalotaSuperiorCurtoseM30_3060}}];
vibSupKur.Properties.VariableNames = {'Grandeza','Tempo','Ensaio','N','M','D','Cluster'};

vibSupVar = table();
vibSupVar = [vibSupVar;{'vibSupVar',{Tempo},{Ensaio},3,5,10,{tbl.VibracaoCalotaSuperiorVarianciaM5_1020}}];
vibSupVar = [vibSupVar;{'vibSupVar',{Tempo},{Ensaio},3,10,10,{tbl.VibracaoCalotaSuperiorVarianciaM10_1020}}];
vibSupVar = [vibSupVar;{'vibSupVar',{Tempo},{Ensaio},3,30,10,{tbl.VibracaoCalotaSuperiorVarianciaM30_1020}}];
vibSupVar = [vibSupVar;{'vibSupVar',{Tempo},{Ensaio},3,5,30,{tbl.VibracaoCalotaSuperiorVarianciaM5_3060}}];
vibSupVar = [vibSupVar;{'vibSupVar',{Tempo},{Ensaio},3,10,30,{tbl.VibracaoCalotaSuperiorVarianciaM10_3060}}];
vibSupVar = [vibSupVar;{'vibSupVar',{Tempo},{Ensaio},3,30,30,{tbl.VibracaoCalotaSuperiorVarianciaM30_3060}}];
vibSupVar.Properties.VariableNames = {'Grandeza','Tempo','Ensaio','N','M','D','Cluster'};

vaz = table();
vaz = [vaz;{'vazao',{Tempo},{Ensaio},3,5,10,{tbl.VazaoM5_1020}}];
vaz = [vaz;{'vazao',{Tempo},{Ensaio},3,10,10,{tbl.VazaoM10_1020}}];
vaz = [vaz;{'vazao',{Tempo},{Ensaio},3,30,10,{tbl.VazaoM30_1020}}];
vaz = [vaz;{'vazao',{Tempo},{Ensaio},3,5,30,{tbl.VazaoM5_3060}}];
vaz = [vaz;{'vazao',{Tempo},{Ensaio},3,10,30,{tbl.VazaoM10_3060}}];
vaz = [vaz;{'vazao',{Tempo},{Ensaio},3,30,30,{tbl.VazaoM30_3060}}];
vaz.Properties.VariableNames = {'Grandeza','Tempo','Ensaio','N','M','D','Cluster'};

vibRMS_LP = table();
vibRMS_LP = [vibRMS_LP;{'vibLp_RMS',{Tempo},{Ensaio},3,5,10,{tbl.lowpassRMSM5_1020}}];
vibRMS_LP = [vibRMS_LP;{'vibLp_RMS',{Tempo},{Ensaio},3,10,10,{tbl.lowpassRMSM10_1020}}];
vibRMS_LP = [vibRMS_LP;{'vibLp_RMS',{Tempo},{Ensaio},3,30,10,{tbl.lowpassRMSM30_1020}}];
vibRMS_LP = [vibRMS_LP;{'vibLp_RMS',{Tempo},{Ensaio},3,5,30,{tbl.lowpassRMSM5_3060}}];
vibRMS_LP = [vibRMS_LP;{'vibLp_RMS',{Tempo},{Ensaio},3,10,30,{tbl.lowpassRMSM10_3060}}];
vibRMS_LP = [vibRMS_LP;{'vibLp_RMS',{Tempo},{Ensaio},3,30,30,{tbl.lowpassRMSM30_3060}}];
vibRMS_LP.Properties.VariableNames = {'Grandeza','Tempo','Ensaio','N','M','D','Cluster'};

vibKur_LP = table();
vibKur_LP = [vibKur_LP;{'vibLp_Kur',{Tempo},{Ensaio},3,5,10,{tbl.lowpassCurtoseM5_1020}}];
vibKur_LP = [vibKur_LP;{'vibLp_Kur',{Tempo},{Ensaio},3,10,10,{tbl.lowpassCurtoseM10_1020}}];
vibKur_LP = [vibKur_LP;{'vibLp_Kur',{Tempo},{Ensaio},3,30,10,{tbl.lowpassCurtoseM30_1020}}];
vibKur_LP = [vibKur_LP;{'vibLp_Kur',{Tempo},{Ensaio},3,5,30,{tbl.lowpassCurtoseM5_3060}}];
vibKur_LP = [vibKur_LP;{'vibLp_Kur',{Tempo},{Ensaio},3,10,30,{tbl.lowpassCurtoseM10_3060}}];
vibKur_LP = [vibKur_LP;{'vibLp_Kur',{Tempo},{Ensaio},3,30,30,{tbl.lowpassCurtoseM30_3060}}];
vibKur_LP.Properties.VariableNames = {'Grandeza','Tempo','Ensaio','N','M','D','Cluster'};

vibRMS_BP = table();
vibRMS_BP = [vibRMS_BP;{'vibBp_RMS',{Tempo},{Ensaio},3,5,10,{tbl.bandpassRMSM5_1020}}];
vibRMS_BP = [vibRMS_BP;{'vibBp_RMS',{Tempo},{Ensaio},3,10,10,{tbl.bandpassRMSM10_1020}}];
vibRMS_BP = [vibRMS_BP;{'vibBp_RMS',{Tempo},{Ensaio},3,30,10,{tbl.bandpassRMSM30_1020}}];
vibRMS_BP = [vibRMS_BP;{'vibBp_RMS',{Tempo},{Ensaio},3,5,30,{tbl.bandpassRMSM5_3060}}];
vibRMS_BP = [vibRMS_BP;{'vibBp_RMS',{Tempo},{Ensaio},3,10,30,{tbl.bandpassRMSM10_3060}}];
vibRMS_BP = [vibRMS_BP;{'vibBp_RMS',{Tempo},{Ensaio},3,30,30,{tbl.bandpassRMSM30_3060}}];
vibRMS_BP.Properties.VariableNames = {'Grandeza','Tempo','Ensaio','N','M','D','Cluster'};

vibKur_BP = table();
vibKur_BP = [vibKur_BP;{'vibBp_Kur',{Tempo},{Ensaio},3,5,10,{tbl.bandpassCurtoseM5_1020}}];
vibKur_BP = [vibKur_BP;{'vibBp_Kur',{Tempo},{Ensaio},3,10,10,{tbl.bandpassCurtoseM10_1020}}];
vibKur_BP = [vibKur_BP;{'vibBp_Kur',{Tempo},{Ensaio},3,30,10,{tbl.bandpassCurtoseM30_1020}}];
vibKur_BP = [vibKur_BP;{'vibBp_Kur',{Tempo},{Ensaio},3,5,30,{tbl.bandpassCurtoseM5_3060}}];
vibKur_BP = [vibKur_BP;{'vibBp_Kur',{Tempo},{Ensaio},3,10,30,{tbl.bandpassCurtoseM10_3060}}];
vibKur_BP = [vibKur_BP;{'vibBp_Kur',{Tempo},{Ensaio},3,30,30,{tbl.bandpassCurtoseM30_3060}}];
vibKur_BP.Properties.VariableNames = {'Grandeza','Tempo','Ensaio','N','M','D','Cluster'};

vibRMS_HP = table();
vibRMS_HP = [vibRMS_HP;{'vibHp_RMS',{Tempo},{Ensaio},3,5,10,{tbl.highpassRMSM5_1020}}];
vibRMS_HP = [vibRMS_HP;{'vibHp_RMS',{Tempo},{Ensaio},3,10,10,{tbl.highpassRMSM10_1020}}];
vibRMS_HP = [vibRMS_HP;{'vibHp_RMS',{Tempo},{Ensaio},3,30,10,{tbl.highpassRMSM30_1020}}];
vibRMS_HP = [vibRMS_HP;{'vibHp_RMS',{Tempo},{Ensaio},3,5,30,{tbl.highpassRMSM5_3060}}];
vibRMS_HP = [vibRMS_HP;{'vibHp_RMS',{Tempo},{Ensaio},3,10,30,{tbl.highpassRMSM10_3060}}];
vibRMS_HP = [vibRMS_HP;{'vibHp_RMS',{Tempo},{Ensaio},3,30,30,{tbl.highpassRMSM30_3060}}];
vibRMS_HP.Properties.VariableNames = {'Grandeza','Tempo','Ensaio','N','M','D','Cluster'};

vibKur_HP = table();
vibKur_HP = [vibKur_HP;{'vibHp_Kur',{Tempo},{Ensaio},3,5,10,{tbl.highpassCurtoseM5_1020}}];
vibKur_HP = [vibKur_HP;{'vibHp_Kur',{Tempo},{Ensaio},3,10,10,{tbl.highpassCurtoseM10_1020}}];
vibKur_HP = [vibKur_HP;{'vibHp_Kur',{Tempo},{Ensaio},3,30,10,{tbl.highpassCurtoseM30_1020}}];
vibKur_HP = [vibKur_HP;{'vibHp_Kur',{Tempo},{Ensaio},3,5,30,{tbl.highpassCurtoseM5_3060}}];
vibKur_HP = [vibKur_HP;{'vibHp_Kur',{Tempo},{Ensaio},3,10,30,{tbl.highpassCurtoseM10_3060}}];
vibKur_HP = [vibKur_HP;{'vibHp_Kur',{Tempo},{Ensaio},3,30,30,{tbl.highpassCurtoseM30_3060}}];
vibKur_HP.Properties.VariableNames = {'Grandeza','Tempo','Ensaio','N','M','D','Cluster'};

results = [cRMS;cKur;cVar;...
           vibInfRMS;vibInfKur;vibInfVar;...
           vibSupRMS;vibSupKur;vibSupVar;...
           vaz;...
           vibRMS_LP;vibKur_LP;...
           vibRMS_BP;vibKur_BP;...
           vibRMS_HP;vibKur_HP];

if nargin == 2
    am = table(repmat(amostra,height(results),1),'VariableNames',{'Amostra'});
    results = [am,results];
else

end
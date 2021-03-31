function [cRMS, cKur, cVar, vibInfRMS, vibInfKur, vibInfVar, vibSupRMS, vibSupKur, vibSupVar] = importClusters(filename)

%% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 109);

% Specify range and delimiter
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Var1", "Tempo", "CorrenteRMSM5_1020", "Var4", "CorrenteRMSM10_1020", "Var6", "CorrenteRMSM30_1020", "Var8", "CorrenteRMSM5_3060", "Var10", "CorrenteRMSM10_3060", "Var12", "CorrenteRMSM30_3060", "Var14", "CorrenteCurtoseM5_1020", "Var16", "CorrenteCurtoseM10_1020", "Var18", "CorrenteCurtoseM30_1020", "Var20", "CorrenteCurtoseM5_3060", "Var22", "CorrenteCurtoseM10_3060", "Var24", "CorrenteCurtoseM30_3060", "Var26", "CorrenteVarianciaM5_1020", "Var28", "CorrenteVarianciaM10_1020", "Var30", "CorrenteVarianciaM30_1020", "Var32", "CorrenteVarianciaM5_3060", "Var34", "CorrenteVarianciaM10_3060", "Var36", "CorrenteVarianciaM30_3060", "Var38", "VibracaoCalotaInferiorRMSM5_1020", "Var40", "VibracaoCalotaInferiorRMSM10_1020", "Var42", "VibracaoCalotaInferiorRMSM30_1020", "Var44", "VibracaoCalotaInferiorRMSM5_3060", "Var46", "VibracaoCalotaInferiorRMSM10_3060", "Var48", "VibracaoCalotaInferiorRMSM30_3060", "Var50", "VibracaoCalotaInferiorCurtoseM5_1020", "Var52", "VibracaoCalotaInferiorCurtoseM10_1020", "Var54", "VibracaoCalotaInferiorCurtoseM30_1020", "Var56", "VibracaoCalotaInferiorCurtoseM5_3060", "Var58", "VibracaoCalotaInferiorCurtoseM10_3060", "Var60", "VibracaoCalotaInferiorCurtoseM30_3060", "Var62", "VibracaoCalotaInferiorVarianciaM5_1020", "Var64", "VibracaoCalotaInferiorVarianciaM10_1020", "Var66", "VibracaoCalotaInferiorVarianciaM30_1020", "Var68", "VibracaoCalotaInferiorVarianciaM5_3060", "Var70", "VibracaoCalotaInferiorVarianciaM10_3060", "Var72", "VibracaoCalotaInferiorVarianciaM30_3060", "Var74", "VibracaoCalotaSuperiorRMSM5_1020", "Var76", "VibracaoCalotaSuperiorRMSM10_1020", "Var78", "VibracaoCalotaSuperiorRMSM30_1020", "Var80", "VibracaoCalotaSuperiorRMSM5_3060", "Var82", "VibracaoCalotaSuperiorRMSM10_3060", "Var84", "VibracaoCalotaSuperiorRMSM30_3060", "Var86", "VibracaoCalotaSuperiorCurtoseM5_1020", "Var88", "VibracaoCalotaSuperiorCurtoseM10_1020", "Var90", "VibracaoCalotaSuperiorCurtoseM30_1020", "Var92", "VibracaoCalotaSuperiorCurtoseM5_3060", "Var94", "VibracaoCalotaSuperiorCurtoseM10_3060", "Var96", "VibracaoCalotaSuperiorCurtoseM30_3060", "Var98", "VibracaoCalotaSuperiorVarianciaM5_1020", "Var100", "VibracaoCalotaSuperiorVarianciaM10_1020", "Var102", "VibracaoCalotaSuperiorVarianciaM30_1020", "Var104", "VibracaoCalotaSuperiorVarianciaM5_3060", "Var106", "VibracaoCalotaSuperiorVarianciaM10_3060", "Var108", "VibracaoCalotaSuperiorVarianciaM30_3060"];
opts.SelectedVariableNames = ["Tempo", "CorrenteRMSM5_1020", "CorrenteRMSM10_1020", "CorrenteRMSM30_1020", "CorrenteRMSM5_3060", "CorrenteRMSM10_3060", "CorrenteRMSM30_3060", "CorrenteCurtoseM5_1020", "CorrenteCurtoseM10_1020", "CorrenteCurtoseM30_1020", "CorrenteCurtoseM5_3060", "CorrenteCurtoseM10_3060", "CorrenteCurtoseM30_3060", "CorrenteVarianciaM5_1020", "CorrenteVarianciaM10_1020", "CorrenteVarianciaM30_1020", "CorrenteVarianciaM5_3060", "CorrenteVarianciaM10_3060", "CorrenteVarianciaM30_3060", "VibracaoCalotaInferiorRMSM5_1020", "VibracaoCalotaInferiorRMSM10_1020", "VibracaoCalotaInferiorRMSM30_1020", "VibracaoCalotaInferiorRMSM5_3060", "VibracaoCalotaInferiorRMSM10_3060", "VibracaoCalotaInferiorRMSM30_3060", "VibracaoCalotaInferiorCurtoseM5_1020", "VibracaoCalotaInferiorCurtoseM10_1020", "VibracaoCalotaInferiorCurtoseM30_1020", "VibracaoCalotaInferiorCurtoseM5_3060", "VibracaoCalotaInferiorCurtoseM10_3060", "VibracaoCalotaInferiorCurtoseM30_3060", "VibracaoCalotaInferiorVarianciaM5_1020", "VibracaoCalotaInferiorVarianciaM10_1020", "VibracaoCalotaInferiorVarianciaM30_1020", "VibracaoCalotaInferiorVarianciaM5_3060", "VibracaoCalotaInferiorVarianciaM10_3060", "VibracaoCalotaInferiorVarianciaM30_3060", "VibracaoCalotaSuperiorRMSM5_1020", "VibracaoCalotaSuperiorRMSM10_1020", "VibracaoCalotaSuperiorRMSM30_1020", "VibracaoCalotaSuperiorRMSM5_3060", "VibracaoCalotaSuperiorRMSM10_3060", "VibracaoCalotaSuperiorRMSM30_3060", "VibracaoCalotaSuperiorCurtoseM5_1020", "VibracaoCalotaSuperiorCurtoseM10_1020", "VibracaoCalotaSuperiorCurtoseM30_1020", "VibracaoCalotaSuperiorCurtoseM5_3060", "VibracaoCalotaSuperiorCurtoseM10_3060", "VibracaoCalotaSuperiorCurtoseM30_3060", "VibracaoCalotaSuperiorVarianciaM5_1020", "VibracaoCalotaSuperiorVarianciaM10_1020", "VibracaoCalotaSuperiorVarianciaM30_1020", "VibracaoCalotaSuperiorVarianciaM5_3060", "VibracaoCalotaSuperiorVarianciaM10_3060", "VibracaoCalotaSuperiorVarianciaM30_3060"];
opts.VariableTypes = ["string", "double", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double", "string", "double"];
opts = setvaropts(opts, [1, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64, 66, 68, 70, 72, 74, 76, 78, 80, 82, 84, 86, 88, 90, 92, 94, 96, 98, 100, 102, 104, 106, 108], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [1, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64, 66, 68, 70, 72, 74, 76, 78, 80, 82, 84, 86, 88, 90, 92, 94, 96, 98, 100, 102, 104, 106, 108], "EmptyFieldRule", "auto");
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
cRMS = [cRMS;{{Tempo},{Ensaio},3,5,10,{tbl.CorrenteRMSM5_1020}}];
cRMS = [cRMS;{{Tempo},{Ensaio},3,10,10,{tbl.CorrenteRMSM10_1020}}];
cRMS = [cRMS;{{Tempo},{Ensaio},3,30,10,{tbl.CorrenteRMSM30_1020}}];
cRMS = [cRMS;{{Tempo},{Ensaio},3,5,30,{tbl.CorrenteRMSM5_3060}}];
cRMS = [cRMS;{{Tempo},{Ensaio},3,10,30,{tbl.CorrenteRMSM10_3060}}];
cRMS = [cRMS;{{Tempo},{Ensaio},3,30,30,{tbl.CorrenteRMSM30_3060}}];
cRMS.Properties.VariableNames = {'Tempo','Ensaio','N','M','D','Cluster'};

cKur = table();
cKur = [cKur;{{Tempo},{Ensaio},3,5,10,{tbl.CorrenteCurtoseM5_1020}}];
cKur = [cKur;{{Tempo},{Ensaio},3,10,10,{tbl.CorrenteCurtoseM10_1020}}];
cKur = [cKur;{{Tempo},{Ensaio},3,30,10,{tbl.CorrenteCurtoseM30_1020}}];
cKur = [cKur;{{Tempo},{Ensaio},3,5,30,{tbl.CorrenteCurtoseM5_3060}}];
cKur = [cKur;{{Tempo},{Ensaio},3,10,30,{tbl.CorrenteCurtoseM10_3060}}];
cKur = [cKur;{{Tempo},{Ensaio},3,30,30,{tbl.CorrenteCurtoseM30_3060}}];
cKur.Properties.VariableNames = {'Tempo','Ensaio','N','M','D','Cluster'};

cVar = table();
cVar = [cVar;{{Tempo},{Ensaio},3,5,10,{tbl.CorrenteVarianciaM5_1020}}];
cVar = [cVar;{{Tempo},{Ensaio},3,10,10,{tbl.CorrenteVarianciaM10_1020}}];
cVar = [cVar;{{Tempo},{Ensaio},3,30,10,{tbl.CorrenteVarianciaM30_1020}}];
cVar = [cVar;{{Tempo},{Ensaio},3,5,30,{tbl.CorrenteVarianciaM5_3060}}];
cVar = [cVar;{{Tempo},{Ensaio},3,10,30,{tbl.CorrenteVarianciaM10_3060}}];
cVar = [cVar;{{Tempo},{Ensaio},3,30,30,{tbl.CorrenteVarianciaM30_3060}}];
cVar.Properties.VariableNames = {'Tempo','Ensaio','N','M','D','Cluster'};

vibInfRMS = table();
vibInfRMS = [vibInfRMS;{{Tempo},{Ensaio},3,5,10,{tbl.VibracaoCalotaInferiorRMSM5_1020}}];
vibInfRMS = [vibInfRMS;{{Tempo},{Ensaio},3,10,10,{tbl.VibracaoCalotaInferiorRMSM10_1020}}];
vibInfRMS = [vibInfRMS;{{Tempo},{Ensaio},3,30,10,{tbl.VibracaoCalotaInferiorRMSM30_1020}}];
vibInfRMS = [vibInfRMS;{{Tempo},{Ensaio},3,5,30,{tbl.VibracaoCalotaInferiorRMSM5_3060}}];
vibInfRMS = [vibInfRMS;{{Tempo},{Ensaio},3,10,30,{tbl.VibracaoCalotaInferiorRMSM10_3060}}];
vibInfRMS = [vibInfRMS;{{Tempo},{Ensaio},3,30,30,{tbl.VibracaoCalotaInferiorRMSM30_3060}}];
vibInfRMS.Properties.VariableNames = {'Tempo','Ensaio','N','M','D','Cluster'};

vibInfKur = table();
vibInfKur = [vibInfKur;{{Tempo},{Ensaio},3,5,10,{tbl.VibracaoCalotaInferiorCurtoseM5_1020}}];
vibInfKur = [vibInfKur;{{Tempo},{Ensaio},3,10,10,{tbl.VibracaoCalotaInferiorCurtoseM10_1020}}];
vibInfKur = [vibInfKur;{{Tempo},{Ensaio},3,30,10,{tbl.VibracaoCalotaInferiorCurtoseM30_1020}}];
vibInfKur = [vibInfKur;{{Tempo},{Ensaio},3,5,30,{tbl.VibracaoCalotaInferiorCurtoseM5_3060}}];
vibInfKur = [vibInfKur;{{Tempo},{Ensaio},3,10,30,{tbl.VibracaoCalotaInferiorCurtoseM10_3060}}];
vibInfKur = [vibInfKur;{{Tempo},{Ensaio},3,30,30,{tbl.VibracaoCalotaInferiorCurtoseM30_3060}}];
vibInfKur.Properties.VariableNames = {'Tempo','Ensaio','N','M','D','Cluster'};

vibInfVar = table();
vibInfVar = [vibInfVar;{{Tempo},{Ensaio},3,5,10,{tbl.VibracaoCalotaInferiorVarianciaM5_1020}}];
vibInfVar = [vibInfVar;{{Tempo},{Ensaio},3,10,10,{tbl.VibracaoCalotaInferiorVarianciaM10_1020}}];
vibInfVar = [vibInfVar;{{Tempo},{Ensaio},3,30,10,{tbl.VibracaoCalotaInferiorVarianciaM30_1020}}];
vibInfVar = [vibInfVar;{{Tempo},{Ensaio},3,5,30,{tbl.VibracaoCalotaInferiorVarianciaM5_3060}}];
vibInfVar = [vibInfVar;{{Tempo},{Ensaio},3,10,30,{tbl.VibracaoCalotaInferiorVarianciaM10_3060}}];
vibInfVar = [vibInfVar;{{Tempo},{Ensaio},3,30,30,{tbl.VibracaoCalotaInferiorVarianciaM30_3060}}];
vibInfVar.Properties.VariableNames = {'Tempo','Ensaio','N','M','D','Cluster'};

vibSupRMS = table();
vibSupRMS = [vibSupRMS;{{Tempo},{Ensaio},3,5,10,{tbl.VibracaoCalotaSuperiorRMSM5_1020}}];
vibSupRMS = [vibSupRMS;{{Tempo},{Ensaio},3,10,10,{tbl.VibracaoCalotaSuperiorRMSM10_1020}}];
vibSupRMS = [vibSupRMS;{{Tempo},{Ensaio},3,30,10,{tbl.VibracaoCalotaSuperiorRMSM30_1020}}];
vibSupRMS = [vibSupRMS;{{Tempo},{Ensaio},3,5,30,{tbl.VibracaoCalotaSuperiorRMSM5_3060}}];
vibSupRMS = [vibSupRMS;{{Tempo},{Ensaio},3,10,30,{tbl.VibracaoCalotaSuperiorRMSM10_3060}}];
vibSupRMS = [vibSupRMS;{{Tempo},{Ensaio},3,30,30,{tbl.VibracaoCalotaSuperiorRMSM30_3060}}];
vibSupRMS.Properties.VariableNames = {'Tempo','Ensaio','N','M','D','Cluster'};

vibSupKur = table();
vibSupKur = [vibSupKur;{{Tempo},{Ensaio},3,5,10,{tbl.VibracaoCalotaSuperiorCurtoseM5_1020}}];
vibSupKur = [vibSupKur;{{Tempo},{Ensaio},3,10,10,{tbl.VibracaoCalotaSuperiorCurtoseM10_1020}}];
vibSupKur = [vibSupKur;{{Tempo},{Ensaio},3,30,10,{tbl.VibracaoCalotaSuperiorCurtoseM30_1020}}];
vibSupKur = [vibSupKur;{{Tempo},{Ensaio},3,5,30,{tbl.VibracaoCalotaSuperiorCurtoseM5_3060}}];
vibSupKur = [vibSupKur;{{Tempo},{Ensaio},3,10,30,{tbl.VibracaoCalotaSuperiorCurtoseM10_3060}}];
vibSupKur = [vibSupKur;{{Tempo},{Ensaio},3,30,30,{tbl.VibracaoCalotaSuperiorCurtoseM30_3060}}];
vibSupKur.Properties.VariableNames = {'Tempo','Ensaio','N','M','D','Cluster'};

vibSupVar = table();
vibSupVar = [vibSupVar;{{Tempo},{Ensaio},3,5,10,{tbl.VibracaoCalotaSuperiorVarianciaM5_1020}}];
vibSupVar = [vibSupVar;{{Tempo},{Ensaio},3,10,10,{tbl.VibracaoCalotaSuperiorVarianciaM10_1020}}];
vibSupVar = [vibSupVar;{{Tempo},{Ensaio},3,30,10,{tbl.VibracaoCalotaSuperiorVarianciaM30_1020}}];
vibSupVar = [vibSupVar;{{Tempo},{Ensaio},3,5,30,{tbl.VibracaoCalotaSuperiorVarianciaM5_3060}}];
vibSupVar = [vibSupVar;{{Tempo},{Ensaio},3,10,30,{tbl.VibracaoCalotaSuperiorVarianciaM10_3060}}];
vibSupVar = [vibSupVar;{{Tempo},{Ensaio},3,30,30,{tbl.VibracaoCalotaSuperiorVarianciaM30_3060}}];
vibSupVar.Properties.VariableNames = {'Tempo','Ensaio','N','M','D','Cluster'};
end
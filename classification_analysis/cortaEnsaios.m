if exist('EnDataA','var')
    for k1 = 1:length(EnDataA)
        for k2 = 1:length(EnDataA{k1})
            ind = (EnDataA{k1}(k2).tempo>0)&(EnDataA{k1}(k2).tempo<=tempoMaxA);
            fields = fieldnames(EnDataA{1}(1));
            for k3 = 1:length(fields)
                if ~strcmp(fields(k3),"name")
                    EnDataA{k1}(k2).(fields{k3}) = EnDataA{k1}(k2).(fields{k3})(ind);
                end
            end
        end
    end
end

if exist('EnDataB','var')
    for k1 = 1:length(EnDataB)
        for k2 = 1:length(EnDataB{k1})
            ind = (EnDataB{k1}(k2).tempo>0)&(EnDataB{k1}(k2).tempo<=tempoMaxB);
            fields = fieldnames(EnDataB{1}(1));
            for k3 = 1:length(fields)
                if ~strcmp(fields(k3),"name")
                    EnDataB{k1}(k2).(fields{k3}) = EnDataB{k1}(k2).(fields{k3})(ind);
                end
            end
        end
    end
end
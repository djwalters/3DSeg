function [Fromi,Toi]=FromTo(GrainPair,GrnStat) %Decided which grain in a pair is the "from" and which is the "to"

    nbrcent=[GrnStat(GrainPair(1)).Centroid(3),GrnStat(GrainPair(2)).Centroid(3)]; %Z centroids of neighbor grains
    [~,Ihi]=max(nbrcent); %Index of highest position Grain
    if Ihi==1 %By default, other grain is lowest
        Fromi=GrainPair(1);
        Toi=GrainPair(2);
        else
        Fromi=GrainPair(2);
        Toi=GrainPair(1);
    end
end
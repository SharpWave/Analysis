function [pairs] = getType2ROIpairs(ClosestT,ROIgroup)

for i = 1:max(ClosestT)
    Closests{i} = [];
end

for i = 1:length(ClosestT)
  if (ROIgroup(i) == 2)
      Closests{ClosestT(i)} = [Closests{ClosestT(i)},i];'good',
  end
end

for i = 1:length(Closests)
    if(~isempty(Closests{i}))
        isgood(i) = 1;
    else
        isgood(i) = 0;
    end
end

pairs = Closests(logical(isgood));
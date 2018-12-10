function [y] = unitba(x)

gh=max(max(x))
gl=min(min(x))

y=255*((x-gl)/(gh-gl))
end


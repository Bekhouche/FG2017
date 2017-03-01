function [features,representation] = PML(image,options)
% Pyramid Multi-Level Features
%   Detailed explanation goes here
%	Usage:
%       features = PML(img)
%       [features,representation] = PML(img, options)

%% Image info
info = whos('image');
[m,n,k] = size(image);

%% PML level
if (~isfield(options, 'level'))
    options.level = 4;
end

%% PML patterns
if (~isfield(options, 'patterns'))
    for i=1:k
        options.patterns(i) = 256;
    end
end


%% Representation
for i=1:options.level
    for j=1:k
        representation{i,j} = imresize(image(:,:,j), [m*(i/options.level),n*(i/options.level)]);
    end
end

%% Features
counter = 0;
features = zeros(sum((1:options.level).^2)* sum(options.patterns),1);
for level=1:options.level
    [md,nd] = size(representation{level,1});
    h = floor(md/level);
    w = floor(nd/level);
    hl = mod(md,h);
    wl = mod(nd,w);
    
    for channel = 1:k
        for mm = 1:h:md-hl
            for nn = 1:w:nd-wl
                sub_block = representation{level,channel}(mm:mm+h-1,nn:nn+w-1,:);
                features((counter*options.patterns(channel))+1:(counter+1)*(options.patterns(channel))) = hist(sub_block(:),0:options.patterns(channel)-1);
                counter = counter + 1;
            end
        end
    end
    
end

end


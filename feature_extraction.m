clc;clear;
addpath('tools');
db.path = '';
load( [db.path 'database'] );

%% Feature extraction
%{%
load ICAtextureFilters_9x9_8bit.mat
options = [];
options.patterns = [2^size(ICAtextureFilters,3) 2^size(ICAtextureFilters,3) 2^size(ICAtextureFilters,3)];

for level =  6
    options.level = level;
    features = zeros(numel(Database),sum(sum((1:level).^2)*options.patterns));
    %%
    for i=1:numel(Database)
        fprintf('Image (PML-%d) %d/%d (%s/%s)\n',level,i,numel(Database), Database(i).folder, Database(i).file);
        img = imread([db.path 'Faces/' Database(i).folder '/' Database(i).file]);
        img = rgb2hsv(img);
        descriptor(:,:,1) = bsif(img(:,:,1),ICAtextureFilters,'im');
        descriptor(:,:,2) = bsif(img(:,:,2),ICAtextureFilters,'im');
        descriptor(:,:,3) = bsif(img(:,:,3),ICAtextureFilters,'im');
        features(i,:) = PML(descriptor,options);
    end
    
    save(['../features/PML_HSV_BSIF_' num2str(options.level) '.mat'],'features', '-v7.3');
    clear features;
end
%}


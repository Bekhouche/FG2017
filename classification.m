clc;clear;
db.path = '';
load( [db.path 'database'] );
db.num = numel(Database);

%% CPU
cpu.num = 4;feature('numCores');

%% Features
fea.level = 6;
fea.name = ['PML_HSV_BSIF_' num2str(fea.level)];
load(['../features/' fea.name]);
fea.data = features; clear features;
fea.num = size(fea.data,2);

%% Folds
for i=1:db.num
    folds(i) = Database(i).fold;
end
train = folds == 1;
fea.train = fea.data(train,:);
valid = folds == 2;
fea.valid = fea.data(valid,:);
clear fea.data;

%% Labels
for i=1:sum(train)
    class_str(i) = Database(i).class2;
end
[dominant.gt,dominant.names]=grp2idx(class_str'); clear class_str;

for i=1:sum(train)
    class_str(i) = Database(i).class1;
end
[complementary.gt,complementary.names]=grp2idx(class_str'); clear class_str;

%% SVM params
%{%
SVM = templateSVM('Solver','SMO',...
    'Standardize',true, ...
    'KernelFunction','rbf',...
    'KernelScale','auto');
pool = parpool(cpu.num);
options = statset('UseParallel',1);
%}

%% Training
%{%
tic;
model_dominant = fitcecoc(fea.train,dominant.gt,'Learners',SVM,'Coding','onevsall','options',options,'Verbose',2);
for i=1:numel(unique(complementary.gt))-1
   lbl_dom = ( dominant.gt == i);
   model_complementary{i} = fitcecoc(fea.train(lbl_dom,:),complementary.gt(lbl_dom),'Learners',SVM,'Coding','onevsall','options',options,'Verbose',2);
end
toc
%}

%% Validation
%{%
tic;
dominant.p = predict(model_dominant, fea.valid);
for i=1:numel(unique(complementary.gt))-1
    lbl_dom = ( dominant.p == i);
    complementary.p(lbl_dom) = predict(model_complementary{i}, fea.valid(lbl_dom,:));
end
complementary.p(dominant.p == 8) = 8;
toc
%}

%% Saving results
%{%
fid = fopen( ['predictions.txt'], 'wt' );
for i = 1:sum(valid)
    fprintf( fid, '%s_%s\n', cell2mat(complementary.names(complementary.p(i))), cell2mat(dominant.names(dominant.p(i))));
end
fclose(fid);
%}
%% end
%{%
poolobj = gcp('nocreate');
delete(poolobj);
%}

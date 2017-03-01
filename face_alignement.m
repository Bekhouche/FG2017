clc;clear;

db.path = '/home/dge/Salah/Databases/emotions/';
db.ext = 'JPG';

%% Training
%{
train.images = dir([db.path 'Training/*.' db.ext]);
train.num = numel(train.images);

for i=2081:train.num
    fprintf('Image Training %d/%d (%s)\n',i,train.num, train.images(i).name);
    img = imread([train.images(i).folder '/' train.images(i).name]);
    img = imresize(img, 0.25);
    fid = fopen([train.images(i).folder '/' train.images(i).name(1:end-3) 'csv']);
    tline = fgets(fid);
    landmarks = strsplit(tline,';');
    
    ld37 = cell2mat(landmarks(37));
    ld37 = strsplit(ld37,',');
    ld40 = cell2mat(landmarks(40));
    ld40 = strsplit(ld40,',');
    ld43 = cell2mat(landmarks(43));
    ld43 = strsplit(ld43,',');
    ld46 = cell2mat(landmarks(46));
    ld46 = strsplit(ld46,',');
    
    
    ReyeX = (str2num(cell2mat(ld37(1)))+str2num(cell2mat(ld40(1))))/2;
    LeyeX = (str2num(cell2mat(ld43(1)))+str2num(cell2mat(ld46(1))))/2;
    ReyeY = (str2num(cell2mat(ld37(2)))+str2num(cell2mat(ld40(2))))/2;
    LeyeY = (str2num(cell2mat(ld43(2)))+str2num(cell2mat(ld46(2))))/2;
    eyes = [ReyeX LeyeX;12+ReyeY LeyeY];
    face = alignement_crop(img,[0.5 1 1.6],[224 224],eyes);
    imwrite(face, [db.path 'Faces/Training/' train.images(i).name]);
    fclose(fid);

end
%}

%% Validation
%{"
valid.images = dir([db.path 'Validation/*.' db.ext]);
valid.num = numel(valid.images);

for i=1:valid.num
    fprintf('Image Validation %d/%d (%s)\n',i,valid.num, valid.images(i).name);
    img = imread([valid.images(i).folder '/' valid.images(i).name]);
    img = imresize(img, 0.25);
    fid = fopen([valid.images(i).folder '/' valid.images(i).name(1:end-3) 'csv']);
    tline = fgets(fid);
    landmarks = strsplit(tline,';');
    
    ld37 = cell2mat(landmarks(37));
    ld37 = strsplit(ld37,',');
    ld40 = cell2mat(landmarks(40));
    ld40 = strsplit(ld40,',');
    ld43 = cell2mat(landmarks(43));
    ld43 = strsplit(ld43,',');
    ld46 = cell2mat(landmarks(46));
    ld46 = strsplit(ld46,',');
    
    
    ReyeX = (str2num(cell2mat(ld37(1)))+str2num(cell2mat(ld40(1))))/2;
    LeyeX = (str2num(cell2mat(ld43(1)))+str2num(cell2mat(ld46(1))))/2;
    ReyeY = (str2num(cell2mat(ld37(2)))+str2num(cell2mat(ld40(2))))/2;
    LeyeY = (str2num(cell2mat(ld43(2)))+str2num(cell2mat(ld46(2))))/2;
    eyes = [ReyeX LeyeX;12+ReyeY LeyeY];
    face = alignement_crop(img,[0.5 1 1.6],[224 224],eyes);
    imwrite(face, [db.path 'Faces/Validation/' valid.images(i).name]);
    fclose(fid);

end
%}
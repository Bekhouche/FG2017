%% Salah Eddine Bekhouche
function Face = alignement_crop(IMG,face_offset,face_size,Eyes)

tg_a = diff(Eyes(2,:))/diff(Eyes(1,:));
angle = tg_a*(180/pi)+2*pi;
tg_a = -angle * (pi/180);
%IMG_R = imrotate(IMG, angle,'bilinear','crop');
IMG_R = imrotate(IMG, angle);
Cx = size(IMG,2)/2;
Cy = size(IMG,1)/2;
Ex = (size(IMG_R,2) - size(IMG,2))/2;
Ey = (size(IMG_R,1) - size(IMG,1))/2;
R_EyeX = (Cx+(Eyes(1,1)-Cx)*cos(tg_a)-(Eyes(2,1)-Cy)*sin(tg_a))+Ex;
R_EyeY = (Cy+(Eyes(1,1)-Cx)*sin(tg_a)+(Eyes(2,1)-Cy)*cos(tg_a))+Ey;
L_EyeX = (Cx+(Eyes(1,2)-Cx)*cos(tg_a)-(Eyes(2,2)-Cy)*sin(tg_a))+Ex;
L_EyeY = (Cy+(Eyes(1,2)-Cx)*sin(tg_a)+(Eyes(2,2)-Cy)*cos(tg_a))+Ey;

L = sqrt((L_EyeX - R_EyeX)^2);
k1 = face_offset(1);
k2 = face_offset(2);
k3 = face_offset(3);
%Face = imcrop(IMG_R,[R_EyeX-(L*face_offset(1)) R_EyeY-(3/2*L*face_offset(2)) L+(2*L*face_offset(1)) L+(5/2*L*face_offset(2))]);
Face=imcrop(IMG_R, [R_EyeX-(k1*L) R_EyeY-(k2*L) L+2*(k1*L) (k2*L)+(k3*L)]);
Face = imresize(Face,face_size);
end


import os
import cv2
import dlib
import numpy



#help(cv2)

# Load files
cascade = cv2.CascadeClassifier('/usr/local/share/OpenCV/haarcascades/haarcascade_frontalface_default.xml')
predictor = dlib.shape_predictor('/usr/share/dlib/shape_predictor_68_face_landmarks.dat')

#
l = 1;
for root, dirs, files in os.walk("/home/dge/Salah/Databases/emotions"):
    for file in files:
        if file.endswith(".JPG"):

             image_file = os.path.join(root, file) # video file path
             print str(l) + " : " + image_file

             img = cv2.imread(image_file) # open video
             #1296 864
             image = cv2.resize(img, (0, 0), fx=0.25, fy=0.25)

             # creat csv file for face landmarks
             csv_file = image_file[:-3] + "csv"
             f = open(csv_file, 'w')

             # Convert frame to gray-scale
             gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

             # Face detection
             faces = cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=3,
                                                  minSize=(300, 300), flags=4)#cv2.cv.CV_HAAR_FIND_BIGGEST_OBJECT)


             pts = ""
             for (x, y, w, h) in faces:
                     #cv2.rectangle(image, (x, y), (x + w, y + h), (0, 255, 0), 2)
                     face = dlib.rectangle(numpy.uint32(x).item(), numpy.uint32(y).item(),
                                       numpy.uint32(x).item() + numpy.uint32(w).item(),
                                       numpy.uint32(y).item() + numpy.uint32(h).item())
                     shape = predictor(image, face)
                     for points in range(0, 67):
                         pts = pts + str(shape.part(points).x) + ',' + str(shape.part(points).y) + ";"
                         #cv2.circle(image, (int(shape.part(points).x), int(shape.part(points).y)), 3,
                         #          color=(0, 255, 255))

             #cv2.imshow('frame', image)
                 #if cv2.waitKey(11) & 0xFF == ord('q'):
             #cv2.waitKey(0);

             f.write(pts + '\n')
             f.close()
             l=l+1
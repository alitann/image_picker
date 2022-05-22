# Flutter Image Picker and Collage

This flutter application takes images from your phone's storage(gallery) or camera and provides you to generate a pdf file that contains collage of selected images.

We are going to use flutter_bloc package for state management for every state changing. We definitely are not using setState. 

Also we are going to use repository pattern for testable and easily maintaible code.

## Screenshots


<br><img src="https://github.com/alitann/image_picker/blob/main/screenshots/1.png" alt="">                    <img src="https://github.com/alitann/image_picker/blob/main/screenshots/2.png" alt="">                    <img src="https://github.com/alitann/image_picker/blob/main/screenshots/3.png" alt="">

<br><img src="https://github.com/alitann/image_picker/blob/main/screenshots/4.png" alt="">                    <img src="https://github.com/alitann/image_picker/blob/main/screenshots/5.png" alt="">                    <img src="https://github.com/alitann/image_picker/blob/main/screenshots/6.png" alt="">

<br><img src="https://github.com/alitann/image_picker/blob/main/screenshots/7.png" alt="">                    <img src="https://github.com/alitann/image_picker/blob/main/screenshots/8.png" alt="">                    <img src="https://github.com/alitann/image_picker/blob/main/screenshots/9.png" alt="">

<br><img src="https://github.com/alitann/image_picker/blob/main/screenshots/10.png" alt="">                    <img src="https://github.com/alitann/image_picker/blob/main/screenshots/11.png" alt="">                    <img src="https://github.com/alitann/image_picker/blob/main/screenshots/12.png" alt="">

## Description

The application has property of 

- Taking images from your phone's storage or camera.    
- Generating  pdf file with selected images. 
- Setting images quality.
- Reordering selected images. 
- Showing detail page of created pdf file and listing. 
- Showing created pdf file with collage images. 
- Pdf file sharing.
- Deleting existing pdf files on the application storage.   
- Using bloc and repository pattern.

## Setup
- Download code and run
- Run this code for downloading packages on pubspec.yaml
  * flutter pub get
  * flutter run
- Run test code
  * flutter test test/

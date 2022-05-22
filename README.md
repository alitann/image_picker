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

Features of the application 

- Load multiple images from the gallery.
- Load the image from the camera. 
- Reorder selected images before creating a collage. 
- Set image quality before selecting images. 
- Reset the page to reselect the images.
- Showing warning if collage created or get failed. 
- List pdf files on the my list page. 
- Show the pdf collage file from the list. 
- Share the pdf file from the list. 
- Delete the pdf file from the list. 
- Using bloc and repository pattern.

## Setup
- Download code and run
- Run this code for downloading packages on pubspec.yaml
  * flutter pub get
  * flutter run
- Run test code
  * flutter test test/

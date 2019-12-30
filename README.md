# Swole

A Flutter fitness application made for our Mobile Development Course!
## Developer Setup

### Pre-requisites:
- Flutter SDK
- Android Studio
- Git
- VS Code (Optional, but highly recommended)

### Setup

Once you are set up and familiar with Flutter, it is time to set up this project.
First, clone this project using:

Once  you have cloned the project, the next step is to get the SHA1 key associated with your computer. This is important so that Google Sign In will work with your development set up. There are many ways to do this, however the way we have done it will be mentioned below.

- Open up Android Studio with any project (Swole would work too)
- On the far right, there will be a button that says "Gradle" written vertically, click it
- Go under ":app" > "Tasks" > "android" > "signingReport"
- Double click it and it'll show a report revealing your SHA1 key. Send that to me in order to be able to login to the application

Once you have completed the above steps, you should be good to go! Executing `flutter run` should let you run the app on an Android Simulator or attached device. 
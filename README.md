
# CryptoApp

A brief description of what this project does:

A Flutter application that provides real-time cryptocurrency data, allowing users to view and explore various cryptocurrencies. The app features a dynamic home screen, a coin listing screen with search functionality, and navigation to detailed crypto information.



## Demo



[Watch Demo Video on Google Drive](https://drive.google.com/file/d/1uuW9y-u5wi5hjwJdgO36DmhXYWj_AR4h/view?usp=sharing)
## Deployment

Prerequisites

Ensure you have Flutter installed on your system. Follow the Flutter installation guide for detailed instructions.

Dependencies: 

Flutter Packages-:

Flutter Packages
flutter: The Flutter SDK for building the app.

web_socket_channel: A package for WebSocket communication.

flutter_spinkit: A collection of loading indicators for Flutter.

flutter_animated_button: A package for animated buttons.

flutter_animate: A package for animations in Flutter.


cupertino_icons: A set of icons for iOS-style user interfaces.

fl_chart: A package for creating charts and graphs.

flutter_staggered_animations: A package for staggered animations in Flutter.

provider: A state management solution for Flutter.

Development Dependencies

flutter_test: The Flutter testing framework.

flutter_lints: A package that provides recommended lints for 
Flutter projects to encourage good coding practices.

Installation:

To install the dependencies, run:

```bash
  flutter pub get
```
Building the App

To build and run the app, follow these steps:

Clone the Repository

First, clone the repository to your local machine using the following command:
```bash
  git clone https://github.com/richa-pandey96/Ampiy_home_page/tree/master
```
Navigate to the Project Directory

Change to the project directory:
```bash
  cd Ampiy_home_page
```
Install Dependencies

Install the required dependencies using Flutter:
```bash
  flutter pub get
```

Build and Run the App

To build and run the app on an emulator or physical device, use the following command:

```bash
  flutter run
```
If you want to build the app for a specific platform, you can use:
```bash
  flutter build [platform]
```
Replace [platform] with apk for Android, ios for iOS, web for web applications, etc.



## Code_Structure

lib/:
 Contains the main source code of the app.

main.dart: Entry point of the application.

crypto_model.dart: Defines the Crypto model class.

web_socket_service.dart: Handles WebSocket connections for real-time data.

crypto_screen.dart: Implements the home screen with animations and interactive elements.

coins_screen.dart: Implements the screen that lists and searches for cryptocurrencies.

crypto_detailpage.dart: Displays detailed information for a selected cryptocurrency.
## Features

Home Screen: Displays a dynamic background with animations and various interactive buttons.

Coins Screen: Lists cryptocurrencies fetched from an API with a search feature.

Crypto Detail Page: Provides detailed information about a selected cryptocurrency.

Real-Time Data: Updates cryptocurrency data in real-time using WebSocket.

Responsive UI: Designed to be user-friendly and visually appealing.
## Usage

Home Screen:
View animated UI elements and interact with buttons.
Search for cryptocurrencies using the search bar.

Coins Screen:
View a list of cryptocurrencies.
Use the search bar to filter cryptocurrencies by symbol.
Tap on a cryptocurrency to view detailed information.

Crypto Detail Page:
See detailed information about the selected cryptocurrency.
## Acknowledgements

 - Flutter: The framework used for building the app.[Flutter](https://flutter.dev/)
 - WebSocket: Provides real-time data updates.[Websocket](https://websocket.org/)
 - Provider: For state management, though you chose not to use it in this case. Provider

- JSON Serialization Libraries: Tools used for parsing and handling JSON data. json_serializable
- Icons and Images: Any sources of icons or images used in the app. [Unsplash](https://unsplash.com/) for images, Material Icons for icons.



## Screenshots

![App Screenshot](https://github.com/richa-pandey96/Ampiy_home_page/blob/master/coinsScreeen.jpeg)
https://github.com/richa-pandey96/Ampiy_home_page/blob/master/coinsScreeen.jpeg

![App Screenshot](https://github.com/richa-pandey96/Ampiy_home_page/blob/master/homescreen.jpeg)
https://github.com/richa-pandey96/Ampiy_home_page/blob/master/homescreen.jpeg




## 🔗 Links
[![github](https://img.shields.io/badge/github-000?style=for-the-badge&logo=ko-fi&logoColor=white)](https://github.com/richa-pandey96)
[![linkedin](https://img.shields.io/badge/linkedin-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/richa-pandey09/)



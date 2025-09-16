This is a graded project for the Mobile Application course at HTWG Konstanz, Summer Semester 2025.
The project was created by Phat Gia Huy Nguyen.
Feel free to use it for educational purposes.

Disclaimer
This is a solo project, so it may not be perfect. However, I believe it is a complete and well-rounded project that covers all stages of the development process from start to finish.
I wish I had more time to further refine it, but I am proud of what I have accomplished.

How to Run the Project
To use and test the application, please follow these steps:

Install Android Studio to emulate virtual devices on your computer.

This is an Android application, so Android Studio is recommended for the best experience.

It can also run on Microsoft platforms (e.g., Visual Studio), but Android Studio is ideal.

The app was carefully designed for Google Pixel 9 Pro, though I also worked to make it responsive for all screen sizes.

Best viewed on Pixel 9 Pro.

Install Flutter by following the official installation instructions from the Flutter website.

Clone the repository and open it with VS Code or any preferred IDE.

Run the following command:

<flutter run>
  
Then choose the device or channel you want to use.

Features and Backend

The project follows a feature-first structure and uses Firebase and Cloudinary as backend services (Cloudinary is used for image storage).
So Posts can be save remotely and not just locally. Once user open the app, Posts will be loaded and fill the HomePage and SwipePage for user to surf or swipe.
Once there are any changes remotely or in cloud, the app is able to dynamically update and rebuild itself.

Implemented features include:

User Authentication

Post management (save, load, and delete dynamically)

Swipe functionality

Book Page: displays and stores the user's posts

Note
Some minor features could not be implemented due to time constraints. However, the core features and the main concept of the application are fully functional and usable.
Tests have been written, but they are not fully comprehensive and can be improved.

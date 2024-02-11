# IOSAppTimetonic App 📱

## Overview 👀
The IOSAppTimetonic App is a native iOS application developed in SwiftUI, employing the Model-View-ViewModel (MVVM) architecture. It's designed to provide a seamless and intuitive user experience, adhering to Apple's Human Interface Guidelines. This application allows users to log in using Timetonic's public API, view a list of books associated with their account, and look their bookshelf with ease.

## Features 🌟

### Login Page 🔑
- Custom-built login interface with email and password fields.
- Authentication against Timetonic's public API using `/createAppkey`, `/createOauthkey`, `/createSesskey` endpoints.
- Secure storage of the session token for subsequent API requests.

### Landing Page 📚
- Displays a scrollable list of books fetched from `/getAllBooks` endpoint using the authenticated session token.
- Each book is presented with its name and cover image, excluding "contacts books".
- Images are dynamically loaded of the API response.

### Testing 🧪
Comprehensive testing ensures the reliability and stability of the IOSAppTimetonic App. The testing strategy includes:

- **Unit Tests:** Verifying the functionality of individual components.
- **Integration Tests:** Ensuring components work together as expected.
- **UI Tests:** Automating user interactions with the app to verify the UI behaves correctly.

Tests are written using XCTest and are run automatically via GitHub Actions on every push and pull request to ensure code integrity.

### Workflows and GitHub Actions 🔄
The project utilizes GitHub Actions to automate our development workflows, including:

- **Continuous Integration (CI):** Automatically build and test the project to ensure changes don't break existing functionality.
- **Automated Testing:** Run all tests against every commit to verify code quality and functionality.

These actions help us maintain a high standard of code quality and streamline the review and deployment processes.

## Evaluation Criteria 📋

### Functionality ✅
- The app correctly performs login authentication, session management, Secure storage of the session token for subsequent API requests and displays the book list as specified.

### Project Organization 🏗️
- The project structure is clear and logical, promoting easy navigation and maintenance.

### Git Management 🔄
- Utilizes Git for version control with meaningful commit messages that accurately describe each change.

### Code Readability 📖
- The code is well-commented, adhering to Swift's coding conventions and best practices for readability and maintainability.

### Design Patterns 🧩
- Demonstrates the effective use of the MVVM architecture and other design patterns, ensuring a clean separation of concerns and scalability.

### Dependencies 🔗
- Dont use of third-party libraries to keep the project lightweight and maintainable.

## Getting Started 🚀

### Prerequisites 📋
- Xcode 15.0.1 or later
- iOS 15.0 or later
- Swift 5.3 or later

### Installation 💻
```bash
# 1. Clone the repository to your local machine
git clone https://github.com/Jaime-A-Perez/iOSAppTimetonic.git

# 2. Open the project in Xcode

# 3. Build and run the application on your device or simulator

```

## Contributing 🤝
I welcome contributions to the IOSAppTimetonic App!

## License 📜
Distributed under the MIT License. See `LICENSE` for more information.

## Acknowledgements
Timetonic API for access to book data.

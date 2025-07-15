# ContactsApp

## Project Overview

ContactsApp is a simple iOS application for managing contacts. It supports adding, editing, deleting, and sorting contacts by name or by the date they were last edited. Contacts include a name, phone number, and optionally a photo. Also you can try some luck and add some random contacts.

## Features

- Add new contacts with name, phone, and optional photo
- Edit existing contacts including changing the photo
- Delete contacts
- Sort contacts by name or by date last edited (most recent first)
- Data persistence using UserDefaults with JSON encoding
- Unit tests for JSON decoding and sorting functionality

## Project Structure

- `Models/`
- `Views/`
- `Controllers/`
- `Services/`
- `Persistence/`
- `Sorting/`
- `Tests/`

## Minimum Deployment Requirements

- **iOS**: 16.0 or later  

## Getting Started

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/YourUsername/ContactsApp.git
   cd ContactsApp
   ```

2. Open ContactsApp.xcodeproj in Xcode.
3. Build and run the project on the simulator or your device.

### Running Tests

To run unit tests in Xcode:

Select Product > Test from the menu or press Cmd + U.

To run tests from the terminal:
```bash
xcodebuild test -scheme ContactsApp -destination 'platform=iOS Simulator,name=iPhone 16'
```

### CI (GitHub Actions)

GitHub Actions is configured to run tests automatically on push and pull requests to the main branch.
See: 
```bash
.github/workflows/swift.yml
```

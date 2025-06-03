# BAG Wiki Admin (Admin Dashboard)

A Flutter Web admin dashboard for managing content on the BAG Wiki website.

## Features

- **Complete CRUD Operations**
  - View all website sections in a responsive grid/list layout
  - Create new sections with title, content, and image URL
  - Edit existing section content with real-time image preview
  - Delete sections with confirmation dialog

- **Responsive Design**
  - Adapts between grid view (desktop) and list view (mobile)
  - Clean, intuitive interface with proper form validation
  - Optimized for various screen sizes and orientations

- **Modern State Management**
  - Utilizes GetX for efficient state management
  - Reactive UI updates without excessive rebuilds
  - Clean separation of concerns (MVC architecture)

- **API Integration**
  - Connects to BAG Wiki API for section management
  - Handles asynchronous operations with loading states
  - Provides user feedback for all operations

## Project Structure

```
bag_wiki_admin/
├── lib/
│   ├── controllers/
│   │   └── section_controller.dart  # Business logic and state management
│   ├── models/
│   │   └── section_model.dart       # Data model for content sections
│   ├── services/
│   │   └── section_service.dart     # API service for section operations
│   ├── views/
│   │   ├── dashboard_view.dart      # Main dashboard with section listing
│   │   └── edit_section_view.dart   # Form for creating/editing sections
│   └── main.dart                    # Application entry point
├── pubspec.yaml                     # Flutter dependencies
└── vercel.json                      # Vercel deployment configuration
```

## Prerequisites

- Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher
- Web browser (Chrome recommended for development)
- BAG Wiki API running and accessible

## Local Development

1. Clone the repository:
   ```bash
   git clone https://github.com/alkhatib99/bag_wiki_admin.git
   cd bag_wiki_admin
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application in debug mode:
   ```bash
   flutter run -d chrome
   ```

## API Integration

The admin dashboard is configured to connect to the BAG Wiki API at `https://bag-wiki-api.onrender.com`. This endpoint is set in `lib/services/section_service.dart`.

If you need to change the API endpoint, update the `baseUrl` variable in this file:

```dart
// lib/services/section_service.dart
class SectionService {
  final String baseUrl = 'https://bag-wiki-api.onrender.com/api/sections';
  // ...
}
```

## Building for Production

Generate a production build with:

```bash
flutter build web --release
```

The built files will be available in the `build/web` directory.

## Deployment to Vercel

### Option 1: Using Vercel CLI (Recommended)

1. Install Vercel CLI:
   ```bash
   npm install -g vercel
   ```

2. Build the application:
   ```bash
   flutter build web --release
   ```

3. Deploy to Vercel:
   ```bash
   vercel
   ```

4. Follow the prompts to link to your Vercel account and project

### Option 2: Using Vercel Dashboard

1. Build the application:
   ```bash
   flutter build web --release
   ```

2. Create a new project on Vercel
3. Upload the `build/web` directory or connect your GitHub repository
4. Vercel will automatically detect the `vercel.json` configuration

### Option 3: GitHub Integration

1. Push your code to GitHub
2. Connect your GitHub repository to Vercel
3. Configure the build settings:
   - Framework Preset: Other
   - Build Command: `flutter build web --release`
   - Output Directory: `build/web`
4. Deploy the project

## Theme Customization

The admin dashboard inherits its theme from the BAG Guild websites (https://dapp.bagguild.com/ and https://bag-wiki.vercel.app). The theme is defined in `lib/main.dart` with the following color scheme:

- Primary Color: `#9353D3` (Purple)
- Background: Dark theme with gradient
- Accent: `#E0A82E` (Gold)

To modify the theme, edit the `ThemeData` in `lib/main.dart`.

## Related Projects

- **BAG Wiki**: Public frontend for displaying content (https://github.com/alkhatib99/bag_wiki)
- **BAG Wiki API**: Backend API for content management (https://github.com/alkhatib99/bag_wiki_api_dart)

## License

This project is proprietary and owned by BAG Guild.

---

© 2025 BAG Guild. All Rights Reserved.

# 📱 Flutter & Dart Masterclass: 11 Distinct Course Projects

[![Flutter](https://img.shields.io/badge/Flutter-3.47.1-blue.svg?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13.1-0175C2.svg?logo=dart)](https://dart.dev)
[![Status: Complete](https://img.shields.io/badge/Projects-11%20Distinct%20Projects-brightgreen.svg)]()

This repository contains **11 completely separate, standalone Flutter projects** covering all topics and practical exercises taught across the entire **Udemy Flutter & Dart Course** (Sections 1 through 20). 

Each project folder is completely independent with its own `pubspec.yaml`, `lib/main.dart`, and platform runners. You can open, build, and run any project individually!

---

## 📂 Project Directory & How to Run Each Project

| Project Folder | Udemy Section | Project Title | How to Run |
|---|---|---|---|
| [`01_hello_world/`](01_hello_world/) | Section 3 | **Hello World App** | `cd 01_hello_world && flutter run -d chrome` |
| [`02_widgets_and_layouts/`](02_widgets_and_layouts/) | Sections 4, 5, 6 | **Widgets & Layouts Showcase** | `cd 02_widgets_and_layouts && flutter run -d chrome` |
| [`03_random_color_generator/`](03_random_color_generator/) | Section 8 | **Random Color Generator (Stateful Lifecycle)** | `cd 03_random_color_generator && flutter run -d chrome` |
| [`04_navigation_and_auth/`](04_navigation_and_auth/) | Sections 9 & 10 | **Navigation & Data Passing (Splash, Login, Register, Dashboard)** | `cd 04_navigation_and_auth && flutter run -d chrome` |
| [`05_named_routes/`](05_named_routes/) | Section 11 | **Named Routes Navigation** | `cd 05_named_routes && flutter run -d chrome` |
| [`06_form_validation/`](06_form_validation/) | Sections 12 & 13 | **Form Input & Real-time Validation** | `cd 06_form_validation && flutter run -d chrome` |
| [`07_getx_state_management/`](07_getx_state_management/) | Section 14 | **GetX State Management Suite (Counter, User, DI)** | `cd 07_getx_state_management && flutter run -d chrome` |
| [`08_sqlite_notes_app/`](08_sqlite_notes_app/) | Sections 15 & 16 | **SQLite Local Database Notes App (MVC Architecture)** | `cd 08_sqlite_notes_app && flutter run -d chrome` |
| [`09_quotes_app/`](09_quotes_app/) | Section 17 | **Quotes App (GetX + REST API + JSON Parsing)** | `cd 09_quotes_app && flutter run -d chrome` |
| [`10_todo_api_crud/`](10_todo_api_crud/) | Section 18 | **Todo CRUD App (REST API without GetX)** | `cd 10_todo_api_crud && flutter run -d chrome` |
| [`11_firebase_firestore_users/`](11_firebase_firestore_users/) | Sections 19 & 20 | **Firebase Cloud Firestore User Management CRUD** | `cd 11_firebase_firestore_users && flutter run -d chrome` |

---

## 🔍 Detailed Project Descriptions

### 1. [`01_hello_world/`](01_hello_world/) — Section 3: First App: "Hello World"
- **Key Concepts**: `MaterialApp`, `Scaffold`, `AppBar`, `Container` dimensions and colors, `Center`, and `TextStyle`.
- **Run command**:
  ```bash
  cd 01_hello_world
  flutter run -d chrome
  ```

### 2. [`02_widgets_and_layouts/`](02_widgets_and_layouts/) — Sections 4, 5, 6: Widgets & Layouts
- **Key Concepts**:
  - Text styling, alignment, and overflow handling with ellipsis.
  - Button types: `ElevatedButton`, `TextButton`, `OutlinedButton`.
  - Network images with `loadingBuilder` and `errorBuilder`.
  - Multi-child layouts: `Row` (`mainAxisAlignment.spaceEvenly`), `Column`, `ListView`.
  - Flex space distribution: `Expanded(flex: 2)` and `Flexible`.
  - Container styling: `BoxDecoration`, borders, box shadows, and 3D transformation with `Matrix4.rotationZ`.
- **Run command**:
  ```bash
  cd 02_widgets_and_layouts
  flutter run -d chrome
  ```

### 3. [`03_random_color_generator/`](03_random_color_generator/) — Section 8: Stateful Widget & Random Color
- **Key Concepts**: Converting `StatelessWidget` to `StatefulWidget`, role of `setState()`, dynamic RGB calculation using `Random().nextInt(256)`, and mathematical relative luminance contrast calculation (`0.299R + 0.587G + 0.114B`) to ensure the text and FAB remain legible.
- **Run command**:
  ```bash
  cd 03_random_color_generator
  flutter run -d chrome
  ```

### 4. [`04_navigation_and_auth/`](04_navigation_and_auth/) — Sections 9 & 10: Navigation & Data Passing
- **Key Concepts**:
  - `SplashScreen`: 3-second delay timer with `Future.delayed` and `pushReplacement`.
  - `LoginScreen`: `TextEditingController` handling and input validation.
  - `RegistrationScreen`: Pushed onto navigation stack with automatic AppBar back button.
  - `DashboardScreen`: Receives username as constructor argument and displays personalized greeting.
- **Run command**:
  ```bash
  cd 04_navigation_and_auth
  flutter run -d chrome
  ```

### 5. [`05_named_routes/`](05_named_routes/) — Section 11: Named Routes
- **Key Concepts**: Centralized routing table (`initialRoute: '/'`, `routes: { ... }`), `onGenerateRoute` extracting `RouteSettings.arguments`, `pushNamed` and `pushReplacementNamed`.
- **Run command**:
  ```bash
  cd 05_named_routes
  flutter run -d chrome
  ```

### 6. [`06_form_validation/`](06_form_validation/) — Sections 12 & 13: Forms & Real-time Validation
- **Key Concepts**: `Form` widget with `GlobalKey<FormState>()`, custom `FormValidator` class (Email regex, strong password rules, 10-digit phone regex), cross-field password matching, `DropdownButtonFormField`, `CheckboxListTile`, autovalidateMode, and form reset.
- **Run command**:
  ```bash
  cd 06_form_validation
  flutter run -d chrome
  ```

### 7. [`07_getx_state_management/`](07_getx_state_management/) — Section 14: GetX State Management
- **Key Concepts**:
  - Reactive Counter with `.obs` and granular `Obx()` rebuilds.
  - Reactive User profile model with `user.update((val) { ... })`.
  - Dependency Injection with `Get.put(ApiService())` and `Get.find<ApiService>()`.
  - Context-less snackbars with `Get.snackbar()`.
- **Run command**:
  ```bash
  cd 07_getx_state_management
  flutter run -d chrome
  ```

### 8. [`08_sqlite_notes_app/`](08_sqlite_notes_app/) — Sections 15 & 16: SQLite Database (MVC)
- **Key Concepts**: Full relational SQLite local database CRUD using the **MVC (Model-View-Controller)** pattern:
  - `models/note_model.dart`: Entity with `toMap()` and `fromMap()`.
  - `helpers/notes_db_helper.dart`: Singleton pattern with SQL table creation, insert, query, update, delete.
  - `controllers/notes_controller.dart`: Controller intermediary.
  - `views/notes_list_screen.dart` & `views/add_edit_note_screen.dart`: Asynchronous `FutureBuilder`, date formatting with `intl`, and dual Add/Edit modes.
- **Run command**:
  ```bash
  cd 08_sqlite_notes_app
  flutter run -d chrome
  ```

### 9. [`09_quotes_app/`](09_quotes_app/) — Section 17: Quotes App (GetX + REST API)
- **Key Concepts**: Fetching remote data over HTTP, JSON deserialization with QuickType pattern, reactive state controller (`QuotesController`) with `quotes.obs` and `isLoading.obs`, and `Obx()` reactive widget rebuilds.
- **Run command**:
  ```bash
  cd 09_quotes_app
  flutter run -d chrome
  ```

### 10. [`10_todo_api_crud/`](10_todo_api_crud/) — Section 18: Todo CRUD without GetX
- **Key Concepts**: Complete CRUD (Create, Read, Update, Delete) via HTTP REST API using standard Flutter `StatefulWidget` and `setState()`. Features `Expanded` row input, timestamp ID generation, and `CheckboxListTile` with leading checkbox.
- **Run command**:
  ```bash
  cd 10_todo_api_crud
  flutter run -d chrome
  ```

### 11. [`11_firebase_firestore_users/`](11_firebase_firestore_users/) — Sections 19 & 20: Cloud Firestore User CRUD
- **Key Concepts**: Cloud Firestore real-time data storage, `StreamBuilder<QuerySnapshot>` listening to collection snapshots, dual-mode Form supporting user creation and in-place document updates via `selectedId`, and instant document deletion.
- **Run command**:
  ```bash
  cd 11_firebase_firestore_users
  flutter run -d chrome
  ```

---

## 🎓 Google Classroom Submission Guide

### Step 1: Push Your Repository to GitHub (`manavkasundra/fllutter_project`)
The Git remote `origin` is already set to `https://github.com/manavkasundra/fllutter_project.git`.

Run this in your terminal:
```bash
cd /Users/manavkasundra/fllutter_project
git push -u origin main
```

*(When prompted for your password, paste your GitHub Personal Access Token or authenticate via GitHub CLI `gh auth login` / SSH).*

### Step 2: Submit on Google Classroom
1. Go to your assignment on [Google Classroom](https://classroom.google.com).
2. Click **+ Add or create** > **Link**.
3. Paste your public GitHub URL:
   ```text
   https://github.com/manavkasundra/fllutter_project
   ```
4. Click **Add Link** and press **Turn In**.

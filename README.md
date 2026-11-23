# 📱 Flutter Course Video Projects

[![Flutter](https://img.shields.io/badge/Flutter-3.47.1-blue.svg?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13.1-0175C2.svg?logo=dart)](https://dart.dev)
[![Video Sections](https://img.shields.io/badge/Projects-7%20Video%20Projects-brightgreen.svg)]()

This repository contains **only the applications built and demonstrated in the video lectures** of the Udemy Flutter & Dart Course. Each video section project is structured as its own standalone, fully runnable Flutter application with its own `pubspec.yaml`, `lib/main.dart`, and platform runners.

---

## 📂 The 7 Video Section Projects & How to Run

| # | Project Folder | Udemy Video Section | Video Topic & Description | How to Run |
|:---:|---|---|---|---|
| **01** | [`01_hello_world_app/`](01_hello_world_app/) | **Section 3 Video** | **Building Your First App: "Hello World"**<br>Scaffold, AppBar, Container (color red), Center, and styled Text. | `cd 01_hello_world_app && flutter run -d chrome` |
| **02** | [`02_random_color_app/`](02_random_color_app/) | **Section 8 Video** | **Stateful Widget & Random Color Generator**<br>StatefulWidget lifecycle, dynamic RGB calculation (`Random().nextInt(256)`), luminance contrast formula for text/FAB, `setState()`. | `cd 02_random_color_app && flutter run -d chrome` |
| **03** | [`03_navigation_auth_app/`](03_navigation_auth_app/) | **Sections 9, 10, 11 Videos** | **Navigation, Auth Flow & Named Routes**<br>3s Splash delay (`Future.delayed`), pushReplacement, Login with validation, Registration with automatic back button, Dashboard receiving username argument, centralized named routes (`onGenerateRoute`). | `cd 03_navigation_auth_app && flutter run -d chrome` |
| **04** | [`04_sqlite_notes_app/`](04_sqlite_notes_app/) | **Section 16 Video** | **SQLite Notes App (Local Database MVC)**<br>Local SQLite storage: Note Model, Singleton `DatabaseHelper`, Controller, `FutureBuilder` NotesListScreen, Add/Edit Note Form. | `cd 04_sqlite_notes_app && flutter run -d chrome` |
| **05** | [`05_quotes_app/`](05_quotes_app/) | **Section 17 Video** | **Quotes App (GetX + REST API + JSON Parsing)**<br>HTTP package integration, QuickType model parsing `q` (quote) and `a` (author), reactive `QuotesController` with `quotes.obs`, `Obx` reactive UI, refresh FAB. | `cd 05_quotes_app && flutter run -d chrome` |
| **06** | [`06_todo_api_crud/`](06_todo_api_crud/) | **Section 18 Video** | **Todo CRUD App (REST API without GetX)**<br>Pure `StatefulWidget` & `setState()`, HTTP CRUD operations (GET, POST, PUT, DELETE), `Expanded` row with text field + add button, `CheckboxListTile` with leading checkbox, trailing delete. | `cd 06_todo_api_crud && flutter run -d chrome` |
| **07** | [`07_firestore_user_management/`](07_firestore_user_management/) | **Section 20 Video** | **Cloud Firestore User Management CRUD**<br>Cloud Firestore real-time data storage, `StreamBuilder` listening to collection snapshots, dual-mode Form (Insert vs Update by `selectedId`), document deletion. | `cd 07_firestore_user_management && flutter run -d chrome` |

---

## 🚀 How to Run Any Video Project

1. Open your terminal and change directory to the video project you want to test:
   ```bash
   cd 01_hello_world_app
   # or
   cd 04_sqlite_notes_app
   # or
   cd 05_quotes_app
   ```

2. Run in **Google Chrome**:
   ```bash
   flutter run -d chrome
   ```

3. Or run as a native **macOS desktop app**:
   ```bash
   flutter run -d macos
   ```

---

## 🎓 Google Classroom Submission Guide

### Step 1: Push Repository to GitHub (`manavkasundra/fllutter_project`)
The Git remote `origin` is already set to `https://github.com/manavkasundra/fllutter_project.git`.

Run this in your terminal:
```bash
cd /Users/manavkasundra/fllutter_project
git push -u origin main
```

*(When prompted for password, enter your GitHub Personal Access Token or authenticate via GitHub CLI / SSH).*

### Step 2: Submit on Google Classroom
1. Open your assignment in **Google Classroom**.
2. Click **+ Add or create** > **Link**.
3. Paste:
   ```text
   https://github.com/manavkasundra/fllutter_project
   ```
4. Click **Add Link** and press **Turn In**.

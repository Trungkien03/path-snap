# PathSnap

> **Project Specification Document**  
> **Target Framework:** Flutter (Dart)  
> **Model:** Local-First / Offline-First / Event-Driven Location Tracking  
> **Version:** 1.0.0

---

## 📋 TABLE OF CONTENTS

1. [Project Overview & Core Principles](#1-project-overview--core-principles)
2. [Functional Requirements](#2-functional-requirements)
3. [Non-Functional Requirements](#3-non-functional-requirements)
4. [Flutter Tech Stack & Architecture](#4-flutter-tech-stack--architecture)
5. [Folder Structure](#5-folder-structure)
6. [Data Model (Database & File System Schema)](#6-data-model-database--file-system-schema)
7. [Implementation Roadmap](#7-implementation-roadmap)
8. [Edge Cases & Exception Handling](#8-edge-cases--exception-handling)

---

## 1. PROJECT OVERVIEW & CORE PRINCIPLES

### 1.1. Purpose

A personal mobile application enabling users to log, manage, and review their travel journeys (trips, hikes, road trips) as a timeline of moments. Each moment is linked directly to geographical coordinates $(Latitude, Longitude)$ captured at creation time, allowing the app to reconstruct and render the full travel route on an interactive map.

### 1.2. Core Design Principles

- **Local-First & 100% Offline:** All data (structured database and media files) is stored strictly on the local device. No backend server, user account, or active internet connection is required.
- **Event-Driven Location Tracking:** GPS coordinates are retrieved strictly when the user performs an active capture action (taking a photo, creating a text note, or importing media). **Background location services are strictly avoided** to maintain minimal battery consumption ($< 1\%$ per day).
- **Privacy by Design:** Location data and personal photos belong exclusively to the user and never leave the device.

---

## 2. FUNCTIONAL REQUIREMENTS

### 2.1. Journey Management

- **FR-1.1 (Create Journey):** Allows creating a new journey with a required Title, optional Description, Start Date (defaults to current time), and an optional Cover Photo.
- **FR-1.2 (Journey Dashboard):** Main screen listing all journeys in a Card/Grid layout ordered by start date descending. Filterable via two tabs: `Active` and `Completed`.
- **FR-1.3 (Edit & Complete):** Allows updating journey metadata or setting the status to "Completed" (sets `end_date` = current timestamp).
- **FR-1.4 (Cascading Delete):** Deleting a journey permanently purges the journey record, all associated Moment records from the database, and all corresponding local media files from the filesystem.

### 2.2. Moment Management

- **FR-2.1 (In-App Camera Capture):** Captures photos directly in-app $\rightarrow$ Automatically requests current foreground GPS coordinates $(Lat, Lng)$ $\rightarrow$ Persists compressed media file and optional note.
- **FR-2.2 (Text-Only Note):** Creates a location-stamped textual moment $\rightarrow$ Automatically retrieves foreground GPS coordinates at save time.
- **FR-2.3 (Gallery Import with EXIF Parsing):** Allows selecting existing photos from the device gallery $\rightarrow$ Parses `GPSLatitude`, `GPSLongitude`, and `DateTimeOriginal` from the image EXIF metadata.
- **FR-2.4 (Manual Pin Drop Fallback):** If an imported image lacks EXIF GPS metadata or location permissions are denied, the app provides a manual pin-drop map picker fallback.

### 2.3. Map & Route Visualization

- **FR-3.1 (Custom Photo Markers):** Displays moments on an interactive map using circular thumbnail previews of the captured photos.
- **FR-3.2 (Chronological Polyline Route):** Orders moments by `captured_at` ascending and renders a polyline path connecting sequential points $P_1 \rightarrow P_2 \rightarrow ... \rightarrow P_n$.
- **FR-3.3 (Interactive Marker Preview):** Tapping a map marker smoothly animates the camera to center on the coordinates and presents a Bottom Sheet with image preview, timestamp, and notes.

---

## 3. NON-FUNCTIONAL REQUIREMENTS

- **NFR-1.1 (Image Processing Pipeline):** Images are automatically resized to a maximum dimension of **2048px** and compressed to **80–85% quality (JPEG/WebP)**. A separate **150x150px thumbnail** is generated for high-performance map marker rendering.
- **NFR-1.2 (Map Performance):** Maintains a continuous **60 FPS** during map pan and zoom operations when rendering vector map layers and markers.
- **NFR-1.3 (GPS Timeout & Accuracy):** Location acquisition requests enforce a **10-second timeout** with a target accuracy threshold of **15–30 meters**.
- **NFR-1.4 (Minimal Permissions):** Requests only `Camera`, `Photos`, and `Location When In Use` permissions. Never requests `Location Always / Background`.

---

## 4. FLUTTER TECH STACK & ARCHITECTURE

### 4.1. Core Ecosystem Packages

| Technical Requirement | Recommended Package                        | Selection Rationale                                                             |
| :-------------------- | :----------------------------------------- | :------------------------------------------------------------------------------ |
| **SDK & UI**          | Flutter 3.x (Dart 3) + Material 3          | High performance, expressive UI, robust cross-platform engine                   |
| **State Management**  | `flutter_riverpod` + `riverpod_annotation` | Compile-time type safety, clean separation of concerns, testable                |
| **Local Database**    | `drift` + `sqlite3_flutter_libs`           | Type-safe SQLite ORM supporting reactive streams and schema migrations          |
| **Map Rendering**     | `flutter_map` + `latlong2`                 | Lightweight OpenStreetMap engine; fully offline-capable, zero API keys required |
| **Camera & Gallery**  | `image_picker` / `camerawesome`            | Native platform media pickers and in-app camera controls                        |
| **GPS Location**      | `geolocator`                               | Efficient foreground location acquisition with configurable timeouts            |
| **EXIF Parsing**      | `native_exif` / `exif`                     | Fast extraction of embedded coordinates and original timestamps                 |
| **Image Processing**  | `image` + `flutter_image_compress`         | Background isolate execution for image resizing and thumbnail generation        |
| **File System**       | `path_provider` + `path`                   | Cross-platform local application directory access                               |

### 4.2. Application Architecture (Feature-First Clean Architecture)

```text
┌─────────────────────────────────────────────────────────┐
│                 PRESENTATION LAYER                      │
│     [Flutter Widgets / Screens / Custom Painters]       │
│                           ▲                             │
│                           │ (Listen State)              │
│               [Riverpod Notifiers / State]              │
└───────────────────────────┬─────────────────────────────┘
                            │
┌───────────────────────────▼─────────────────────────────┐
│                   DOMAIN LAYER                          │
│     [Entities / Value Objects / UseCase Controllers]    │
└───────────────────────────┬─────────────────────────────┘
                            │
┌───────────────────────────▼─────────────────────────────┐
│                    DATA LAYER                           │
│   ┌───────────────────────┐   ┌─────────────────────┐   │
│   │ Drift DAO (SQLite)    │   │ FileStorageService  │   │
│   └───────────────────────┘   └─────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

# 1. State Management & Navigation

flutter_riverpod riverpod_annotation go_router

# 2. Local Database & Storage

drift sqlite3_flutter_libs path_provider path uuid

# 3. Location & Maps

flutter pub add flutter_map latlong2 geolocator flutter_map_marker_cluster

# 4. Media, Camera & EXIF

image_picker native_exif flutter_image_compress

# 5. Dev Dependencies (Code Generator)

- drift_dev riverpod_generator custom_lint riverpod_lint

lib/
├── config/ # Cấu hình app (Environments, Themes)
│ └── app_config.dart
│
├── data/ # Tầng xử lý dữ liệu (Drift, DB, Repositories Implementation)
│ ├── database/ # Khởi tạo Drift DB & Định nghĩa bảng SQLite
│ │ ├── app_database.dart
│ │ └── tables/
│ │ ├── journeys_table.dart
│ │ └── journey_moments_table.dart
│ ├── model/ # Data models / DTOs (Data Transfer Objects)
│ ├── repositories/ # Hiện thực hóa (Implementation) các Repository từ domain
│ │ └── journey_repository_impl.dart
│ └── services/ # File I/O, Location service, Image Picker service
│
├── domain/ # Tầng nghiệp vụ (Pure Dart - Không dính UI / Flutter package)
│ ├── models/ # Entity chuẩn nghiệp vụ (Journey, JourneyMoment)
│ └── repositories/ # Giao diện (Abstract Interfaces) của Repositories
│ └── i_journey_repository.dart
│
├── routing/ # Điều hướng (GoRouter hoặc Navigator 2.0)
│ └── app_router.dart
│
├── ui/ # Tầng hiển thị (Cupertino Widgets & Riverpod Controllers)
│ ├── journeys/ # UI các màn hình quản lý Journey
│ │ ├── controllers/ # Riverpod Providers / StateNotifiers
│ │ ├── widgets/ # Components con (JourneyCard, MomentTile)
│ │ └── journeys_screen.dart
│ ├── map/ # UI màn hình Map Journal
│ └── settings/ # UI màn hình Settings
│
├── utils/ # Hàm tiện ích chung (Formatters, Constants, Extensions)
│
├── main.dart # Entry point cho PROD
├── main_development.dart # Entry point cho DEV
└── main_staging.dart # Entry point cho STAGING

# 📱 Offline-First Task Management App (Flutter + GetX)

## 🧾 Overview

This is a mobile task management application built using **Flutter** with an **offline-first architecture**.  
Users can authenticate using JWT, manage tasks, update task status and remarks, and continue working even without internet connectivity.  

Offline changes are stored locally and automatically synced with the backend when connectivity is restored.

---

## 🎯 Core Features

### 🔐 Authentication
- User registration and login
- JWT authentication
- Persistent login across app restarts
- Secure logout

### 📋 Task Management
- View task list
- Task detail screen
- Create new tasks
- Update title, description, status, and remarks
- Loading and error handling

### 🌐 Offline Support
- Cached tasks displayed when offline
- Offline task creation
- Offline task updates
- Sync queue for pending changes
- Auto sync when internet restores
- Pull to refresh sync

---

## 🏗 Architecture

The app follows a layered architecture:

UI (Screens)  
↓  
Controllers (GetX)  
↓  
Repository  
↓  
Network Service (Dio)  
↓  
Backend API  

Offline layer:

Hive (Local Cache)  
Sync Queue  
Connectivity Service  

---

## 🧠 Offline Logic

### 📦 Local Caching
Tasks are stored locally using Hive so users can view tasks without internet.

### 📝 Offline Updates
When the device is offline:
- Task creations and updates are added to a sync queue
- Changes are immediately reflected in UI
- Tasks are marked as offline

### 🔄 Auto Sync
When connectivity is restored:
- Pending changes are sent to backend
- Local cache is updated
- Offline flags are removed

---

## 🛠 Tech Stack

- Flutter
- Dart
- GetX (State Management)
- Dio (Networking)
- Hive (Local Storage)
- Connectivity Plus (Network detection)
- JWT Authentication

---

## 📱 Screens

- Login Screen
- Register Screen
- Task List Screen
- Task Detail Screen
- Create Task Dialog

---

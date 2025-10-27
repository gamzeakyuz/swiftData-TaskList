📝 Task Manager App (SwiftUI + SwiftData)

🌟 Overview

Task Manager App is a minimalist yet powerful iOS application built entirely with SwiftUI and SwiftData.
It helps users create, organize, and track tasks efficiently, with local notification reminders and a clean UI experience.

Designed for both productivity enthusiasts and iOS learners, this project showcases modern Swift concepts like data persistence, reactive UI updates, and contextual interactions.


⸻

🧩 Features

	•	🆕 Add, Edit & Delete Tasks
Manage all your tasks with ease and persistent storage via SwiftData.
	•	⏰ Smart Notifications
Long-press on any task to schedule or cancel a reminder for its due date.
	•	🧠 Dynamic Sorting
Sort by name, priority, or due date directly in the app.
	•	🏷️ Task Categories & Priority Levels
Personalize your workflow with categories and urgency tags.
	•	🎨 Elegant SwiftUI Interface
A modern, adaptive design that looks great in both Light and Dark modes.
	•	💬 Context Menus & Swipe Gestures
Intuitive interactions for managing tasks quickly.
	•	🪄 Smooth Animations
Empty states, transitions, and sheet presentations enhanced with SwiftUI animations.

🧩 Tech Stack

    Framework                         Purpose
SwiftUI                         Declarative UI framework
SwiftData                       Local data persistence
UserNotifications               Notification scheduling and management
MVVM Architecture               Code organization
Xcode 16 / iOS 18 SDK           Development environment  


🖼️ Screenshots

![Simulator Screen Recording - iPhone 17 Pro - 2025-10-27 at 19 14 48](https://github.com/user-attachments/assets/5ed6663c-b756-43cb-8b58-210d4137f0b7)


🧠 Architecture Diagram

+----------------------+
|      HomeView        |
|----------------------|
| - Displays tasks     |
| - Sorting options     |
| - Handles sheets      |
+----------+-----------+
           |
           v
+----------------------+
|   NewTaskListView    |
|----------------------|
| - Add tasks          |
| - Input validation   |
| - Uses ModelContext  |
+----------+-----------+
           |
           v
+----------------------+
|     Task Model       |
|----------------------|
| - title              |
| - dueDate            |
| - priority           |
| - category           |
| - isCompleted        |
+----------------------+
           |
           v
+----------------------+
| NotificationManager  |
|----------------------|
| - Schedule/cancel    |
| - Permission control |
+----------------------+


⭐️ Support

If you like this project, please star the repository 🌟
and share it with your network — feedback is always welcome!

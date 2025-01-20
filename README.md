# Fitness App

## Overview
The Fitness App is a dual-portal mobile application designed to connect individuals with similar fitness goals. The app provides two primary roles:

1. **Workout Buddy Finder:** Find and connect with workout partners based on preferences and proximity.
2. **Fitness Group Organizer:** Create and manage fitness groups, track member activities, and facilitate group interactions.

This application is developed using **Django** for the backend and **Flutter** for the frontend, ensuring a seamless and efficient user experience.

## Features

### 1. Authentication
#### a. User Sign-Up/Login Methods
- **Username and Password:**
  - Users can create an account with a unique username and password.
  - Option to upload a profile picture or use a default image.
  - Users select one of the following roles during sign-up:
    - **Find a Workout Buddy:** Match with individuals sharing similar fitness goals.
    - **Create/Manage a Fitness Group:** Organize and lead group activities.

#### b. Role-Based Onboarding
- **Workout Buddy:**
  - Fill out fitness details:
    - Fitness goals
    - Workout preferences (e.g., gym, yoga, running)
    - Availability

- **Fitness Group Organizer:**
  - Provide group-specific details:
    - Activity type
    - Location
    - Schedule (editable later)

### 2. Dual-Portals
- **Buddy Finder:** Discover and connect with workout buddies.
- **Group Organizer:** Create and manage fitness groups with ease.

### 3. Dashboard
#### a. Buddy Finder Perspective
- **Recommended Buddies:**
  - View a list of workout buddies based on preferences and proximity.
- **Available Groups:**
  - Discover fitness groups with links to detailed pages.
- **Filters:**
  - Filter by activity type, skill level, and location.
  - Leverage the Distance Matrix API for proximity-based recommendations.

#### b. Group Organizer Perspective
- **Manage Fitness Groups:**
  - Edit group details and schedules.
- **Join Requests:**
  - View and approve/reject user requests.
- **Filters:**
  - Search for workout buddies by proximity, availability, etc.

### 4. Group Page
- **Group Details:**
  - Display activity type, schedule, location, and group description.
- **Member List:**
  - Profiles of current group members.
- **Interactions:**
  - Real-time group chat feature.
  - Send join requests.
- **Organizer Details:**
  - Display organizer’s contact information.

### 5. Profile
#### a. Buddy Profile
- **Personal Information:**
  - Name, profile picture, fitness goals, and bio.
- **Fitness History:**
  - Activities and milestones.
- **Contact Details:**
  - Optional visibility for phone/email.

#### b. Group Profile
- **Organizer Information:**
  - Organizer name, profile picture, and contact details.
- **Group Goals:**
  - Description of activities and goals.
- **Privacy Settings:**
  - Control visibility of contact information.

### 6. Notification Feed
#### a. Buddy Finder Perspective
- Real-time notifications for:
  - New buddy matches.
  - Groups matching preferences.
  - Updates on join requests and group chats.

#### b. Group Organizer Perspective
- Real-time notifications for:
  - New join requests.
  - Updates on group chats.

**Implementation Notes:**
- Use WebSockets for real-time updates.
- Alternatively, use a polling mechanism to refresh the feed every 5 seconds.

## Setup and Installation

### Prerequisites
- Install **Flutter** for mobile development.
- Backend setup with **Django**.
- Install dependencies listed in `pubspec.yaml` for Flutter.
- Ensure API keys for services like Distance Matrix API are set up.

### Steps to Run Locally
1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```
2. Navigate to the project directory:
   ```bash
   cd fitness_app
   ```
3. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```
5. For backend setup:
   - Install Django dependencies:
     ```bash
     pip install -r requirements.txt
     ```
   - Run migrations:
     ```bash
     python manage.py migrate
     ```
   - Start the server:
     ```bash
     python manage.py runserver
     ```
6. Connect the app to the backend by updating the API base URL in the configuration file.




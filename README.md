# DormLink - KFUPM Roommate Finder Architecture

## Overview
A mobile app helping KFUPM students find compatible roommates with filtering, chat, and portal redirection.

## Color Palette (KFUPM Brand)
- Primary: KFUPM Green (#008540)
- Secondary: KFUPM Gold (#DAC961)
- Accent: KFUPM Forest (#00573F)
- Background Light: KFUPM Light Gray (#D9DAE4)
- Text Dark: KFUPM Dark Gray (#373938)
- Accent Dark: KFUPM Petrol (#003E51)

## Data Models
1. **User** - id, name, email, major, city, year, bio, avatarUrl, smokingPreference, sleepSchedule, studyHabits, createdAt, updatedAt
2. **RoommateRequest** - id, userId, title, description, roomType, preferences, isActive, createdAt, updatedAt
3. **ChatConversation** - id, participants, lastMessage, lastMessageAt, createdAt
4. **ChatMessage** - id, conversationId, senderId, content, sentAt, isRead
5. **RoomType** - id, name, description, capacity, imageUrl

## Screens
1. **Home/Dashboard** - Overview with navigation to all features
2. **Room Types** - Browse available room configurations
3. **Roommate Requests** - Browse/filter requests with filtering capability
4. **Create Request** - Form to post roommate request
5. **Chat List** - List of conversations
6. **Chat Detail** - Individual chat conversation
7. **Profile** - User profile view/edit
8. **Portal Redirect** - Redirect to KFUPM portal

## Navigation
- Bottom navigation with: Home, Requests, Create Request, Chat, Profile
- Drawer menu for additional options

## Services
- UserService - User data management with local storage
- RoommateRequestService - Request CRUD with local storage
- ChatService - Messaging with local storage
- RoomService - Room types data

## Tech Stack
- Flutter with Provider for state management
- Local storage (SharedPreferences) for data persistence
- Google Fonts for typography

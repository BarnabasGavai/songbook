# Hindi Christian Songbook App

## Android Worship Music Application (Flutter)

Hindi Christian Songbook is a Flutter-based Android application designed to provide easy access to Hindi Christian hymns with integrated music playback, offline access, and a clean distraction-free worship experience.

The app focuses on usability, offline accessibility, and seamless playback for both personal worship and church environments.

## Live Store Listing

Amazon Appstore:
https://www.amazon.in/Barnabas-Christian-Hindi-Songbook/dp/B0DCP4TQWJ

## APK Download

Direct APK:
https://drive.google.com/file/d/1ftScdhUiopTROPW6WBNrpgA7_wETHpHK/view?usp=sharing

---

## Overview

The application allows users to browse Hindi Christian songs, read lyrics, listen to music, and access saved content offline. The system is designed using an offline-first approach to ensure reliability even with limited internet access.

This project demonstrates mobile application development, state management, offline storage strategies, and cloud data synchronization using Flutter.

---

## Core Features

### Music Playback

• Built-in audio player  
• Continuous playback support  
• Random song playback feature  
• Lyrics displayed alongside music  

### Nonstop Worship Mode

• Radio-style continuous playback  
• Automatic random song transitions  
• Automatic lyric updates  
• Screen remains active during playback  

### Offline Support

• Songs accessible without internet  
• Local caching using Hive  
• Fast local data retrieval  
• Reduced network dependency  

### Song Navigation

• Letter-based indexing  
• Search functionality  
• Fast navigation between songs  

### User Experience Features

• Dark mode support  
• Adjustable font size  
• Landscape support  
• Wide screen optimization  
• Clean and simple UI  

---

## Technology Stack

### Mobile Framework
- Flutter (Dart)

### State Management
- Provider

### Database & Storage
- Firebase (Cloud data)
- Hive (Local storage)

### Architecture Concepts
- Offline-first design
- Local caching strategy
- Responsive UI design

---

## Application Architecture

Application flow:

App launch  
→ Load songs from local storage  
→ Sync data from Firebase (if available)  
→ User selects song  
→ Audio playback starts  
→ Lyrics displayed  
→ Continuous playback option available  

---

## Engineering Challenges Solved

Key technical problems addressed:

• Designing offline-first mobile architecture  
• Implementing smooth audio playback flow  
• Managing local caching using Hive  
• Ensuring UI responsiveness across devices  
• Implementing fast search functionality  

---

## Design Decisions

Important architectural decisions:

• Use Hive for fast offline storage  
• Use Firebase for centralized data management  
• Provider for predictable state management  
• Offline-first architecture for reliability  
• Simple UI for accessibility during worship  

---

## Screenshots

<p align="center">
  <img src="https://m.media-amazon.com/images/I/61mavcJ6b1L.png" width="200"/>
  <img src="https://m.media-amazon.com/images/I/61NoSkBO18L.png" width="200"/>
  <img src="https://m.media-amazon.com/images/I/718-JHHLIiL.png" width="200"/>
</p>

<p align="center">
  <img src="https://m.media-amazon.com/images/I/5170l7dGAmL.png" width="200"/>
  <img src="https://m.media-amazon.com/images/I/61bJ0tQSWxL.png" width="200"/>

</p>
---

## Possible Future Improvements

Potential enhancements:

• Playlist creation  
• Favorites system  
• Song categorization  
• UI improvements  
• Performance optimizations  

---

## Author

Barnabas Gavai

GitHub:
https://github.com/BarnabasGavai

LinkedIn:
https://in.linkedin.com/in/barnabas-gavai01

Email:
barnabasgavai@gmail.com

---

## Notes

This project demonstrates mobile development using Flutter, offline data handling, state management, and cloud integration.

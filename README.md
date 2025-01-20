# JoiningIn-17-SUSTAIN-AI-THON
brief intro

Mental Wellness Companion is a digital platform designed to empower individuals on their mental health journey by providing accessible, personalized, and stigma-free support. This web app integrates tools like mood tracking, guided self-care exercises, a supportive community forum, and crisis management resources into a single, user-friendly interface.

By addressing key barriers such as affordability, accessibility, and lack of awareness, the platform promotes mental well-being, aligns with global health goals, and fosters a proactive approach to mental health care. Whether through self-care activities, peer interaction, or professional guidance, the app helps users navigate their mental health journey with confidence and support.



WORKFLOW
![image](https://github.com/user-attachments/assets/e74a4128-2fe9-4b7d-9501-77e28e39f715)


Login --> Dashboard
Login --> Community
Login --> Analysis
Login --> Chat Bot
Login --> Goal Tracker

Dashboard <--> Community
Dashboard <--> Analysis
Dashboard <--> Chat Bot
Dashboard <--> Goal Tracker

Community <--> Analysis
Community <--> Chat Bot
Community <--> Goal Tracker

Analysis <--> Chat Bot
Analysis <--> Goal Tracker

Chat Bot <--> Goal Tracker

All Features --> Logout





CONCEPT MAP



Mental Wellness Companion
    |
    |---> Problem
    |       |---> Inaccessible mental health resources
    |       |---> Stigma surrounding mental health
    |       |---> Lack of personalized support
    |
    |---> Solution
    |       |---> Holistic Platform
    |       |       |---> Mood tracking
    |       |       |---> Guided self-care exercises
    |       |       |---> Community forums
    |       |       |---> Crisis tools
    |       |
    |       |---> Personalization
    |       |       |---> Data-driven insights
    |       |       |---> Tailored recommendations
    |       |
    |       |---> Accessibility
    |       |       |---> Affordable and mobile-friendly
    |       |       |---> Easy to use for all audiences
    |       |
    |       |---> Community Support
    |       |       |---> Anonymous peer-to-peer interactions
    |       |       |---> Reduced stigma
    |       |
    |       |---> Crisis Readiness
    |               |---> Emergency tools
    |               |---> Immediate resources
    |
    |---> Features
            |---> Dashboard
            |---> Community Forum
            |---> Analysis Tools
            |---> Chat Bot
            |---> Goal Tracker
            |---> Logout


Central Node (Mental Wellness Companion): Represents the core project.
Problem Branch: Highlights the main challenges the app aims to address.
Solution Branch: Outlines how the app solves these challenges using holistic, personalized, and accessible features.
Features Branch: Lists specific functionalities available within the app.





TECHSTACK


1. Frontend: Flutter (Web)
   Framework: Flutter Web (for building cross-platform web apps).
   Programming Language: Dart (used with Flutter).
   State Management: provider for managing app state.
   UI Components: Flutter widgets for building a calming, user-friendly UI.
   Notifications: flutter_local_notifications for reminders and alerts.
   Charts: charts_flutter for visualizing mood tracking.
   Custom Fonts: google_fonts for a soothing design.


2. Backend: Python
   Framework: Flask (for building REST APIs to handle backend logic).
   Firebase Integration: firebase-admin for connecting Flask with Firebase.
   Data Analysis: pandas, matplotlib for analyzing mood data and generating insights.
   Notifications & Alerts: Python libraries like requests for integrating with external services (e.g., Twilio for SMS).


3. Database & Authentication: Firebase
   Authentication: Firebase Authentication (email/password, Google login).
   Database: Firebase Firestore (real-time, NoSQL database for storing user data).
   Storage: Firebase Cloud Storage (for storing images, videos).
   Serverless Functions: Firebase Cloud Functions (for executing backend code like sending notifications).
   Analytics: Firebase Analytics (for tracking user behavior and engagement).

4. Deployment
   Web Hosting: Firebase Hosting (for hosting the Flutter web app).
   Backend Hosting: Deploy Python backend on Heroku or AWS Lambda





NOVELTY


Holistic Platform: Combines mood tracking, self-care tools, community forums, and professional resources.

Personalization: Offers tailored recommendations using data-driven insights.

Accessibility: Affordable, mobile-friendly, and easy to use for diverse audiences.

Community Support: Provides anonymous peer-to-peer interaction to reduce stigma.

Crisis Tools: Includes emergency resources for acute mental health needs.






SOLUTION

The solution is a web app that helps users manage their mental health with easy-to-use tools and resources. It provides a secure login, a questionnaire to assess mental well-being, and personalized recommendations like mindfulness exercises and coping strategies. Users can track their progress with simple charts, connect with a supportive community, and get help from a chatbot for instant guidance. The app also allows users to set mental health goals and track their progress while offering access to professionals for extra support.


OTHERS

1. Supports SDG 3 (Good Health and Well-Being): Focuses on mental wellness and aligns with Target 3.4 to promote mental health.

2. Promotes Accessibility: Offers digital tools for mental health support, making resources available to a broader audience.

3. Encourages Community Support: Reduces stigma by fostering a supportive online community.

4. Focuses on Prevention: Provides assessments, tracking, and early interventions to address mental health issues proactively.

5. Empowers Goal Achievement: Helps users set and achieve personal mental health goals for long-term well-being.






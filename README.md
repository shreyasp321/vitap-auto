App name: vit auto

Problem :Students lack real-time information about campus departure demand, causing long waiting times and higher transport charges.

Solution :
VIT Auto provides a real-time, slot-based view of student departure demand inside campus.
By allowing students to:
   Join a time slot representing when they plan to   leave,
   Instantly see how many others are leaving at the same time, and
   Communicate through a slot-based group chat,
the app helps students:
   Reduce waiting time for autos,
   Share rides more efficiently,
   Avoid overpaying due to low demand or poor  coordination.

FULL APP FLOW
SCREEN 1 – SPLASH SCREEN
App name: VIT Auto
Tagline: Where there is Auto, there is a way
Shows for ~2 seconds
Checks login status
Logged in → Poll Screen
Not logged in → Sign-in Screen

SCREEN 2 – SIGN IN
Email input (above auto image)
OTP input placed on auto number plate
Button: Enter Auto
Flow:
User enters VIT-AP email
OTP sent to email
User enters OTP
Successful verification → logged in

SCREEN 3 – PROFILE SETUP (FIRST TIME ONLY)
Input: Name
Button: Enter Auto
Name is mandatory
Screen shown only once
Name used in chat messages

SCREEN 4 – POLL RECTANGLES (MAIN SCREEN)
21 time-slot rectangles
Above 5 AM
5–6 AM
…
Below 12 AM
Each rectangle shows:
Time slot
Number of joined users
Enter Chat button
Rules:
User can join only one slot per day
Joined rectangle becomes highlighted
Tapping again removes vote
Enter Chat enabled only for joined slot
Top Bar:
3-line menu → Sign out
Text label: Make a poll

SCREEN 5 – GROUP CHAT
Normal chat interface
Shows:
Sender name
Message text
Time
Text messages only
Rules:
Chat accessible only after voting
Leaving slot removes chat access
One chat per user per day

TECHNOLOGY STACK
Flutter (mobile app)
Firebase Authentication (email + OTP)
Firebase Firestore (votes and chat data)
GitHub (version control)
Google Drive (APK demo link)

MVP FEATURES (VERSION 1)
VIT-AP only login
Daily time-slot voting
Slot-based group chat
Visual highlight for selected slot
Daily automatic reset

Team members:

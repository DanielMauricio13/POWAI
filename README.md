# PowAI

PowAI is a Swift-based iOS fitness application that uses generative AI to build personalized workout plans and track daily nutrition. Create a profile, answer a brief questionnaire, and receive routines tailored to your goals and schedule.

## Features
- **Account creation and login** with JWT-based authentication.
- **AI-generated workouts** based on your fitness level, location and time available.
- **Live Activities** and notifications to monitor rest periods during workouts.
- **Food tracking** powered by generative AI to estimate calories, protein, carbs and sugars.
- **Daily goal tracking** for calories and macronutrients.

## Getting Started
1. Clone this repository and open `Gym-app-ioss.xcodeproj` in Xcode.
2. Add your Google Generative AI API key in `GenerativeAi-Info.plist`.
3. Build and run on an iOS device or simulator.
4. Sign up with your email, set your goals and start training!

## Workouts
After logging in your personalized routine is displayed on the main screen. Selecting a workout shows each exercise with sets, reps and estimated calories. Begin the session to activate the Live Activity timer and track your progress.

![Workout list](https://github.com/user-attachments/assets/17227519-7285-4d65-9dec-28ff6bc50672)
![Workout detail](https://github.com/user-attachments/assets/6ca7773b-c59a-4e18-b257-5dd5870fbe9e)

## Nutrition
Enter any food item and PowAI will retrieve its nutritional content. Your current intake is compared against the daily targets provided by the AI.

![Food entry](https://github.com/user-attachments/assets/0a37e332-9fd1-4348-be5d-e5fa6ca51904)
![Daily goal progress](https://github.com/user-attachments/assets/98997647-36b1-436a-b79e-19ddac21bb31)

## Screenshots
![Login](https://github.com/user-attachments/assets/871892ac-ded1-45d6-a87f-bd7bce5949a5)
![Rest timer](https://github.com/user-attachments/assets/863eceba-4a7d-4dbe-bf15-8861dcccec22)

Enjoy your workouts with **PowAI**!

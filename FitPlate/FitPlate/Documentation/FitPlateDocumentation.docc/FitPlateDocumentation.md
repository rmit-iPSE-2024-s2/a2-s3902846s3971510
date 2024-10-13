# ``FitPlate``

## Overview

FitPlate is a simple fitness tracking app built using SwiftUI and SwiftData. It allows users to sign up, log in, edit their profiles, and set personal fitness goals such as step goal completion, water intake goals. Users can also save workout routines from the app. It also allows users to fetch and generate recipes by selecting filters from an external API. The app is backed by data persistence using SwiftData, ensuring user data is saved and retained across sessions.

FitPlate's main features include:
- User account management with sign-up and login functionality.
- Recipe generation with filters via external API.
- Fitness goal tracking (steps, calories, water intake).
- Saved workout routines.
- Profile management and editing.
- A dashboard displaying key metrics and progress.

## Views

### [ContentView](FitPlate/View/ContentView.swift)

### [SignupView](FitPlate/View/SignupView.swift)

### [LoginView](FitPlate/View/LoginView.swift)

### [HomeView](FitPlate/View/HomeView.swift)

### [BottomNavBarView](FitPlate/View/BottomNavBarView.swift)

### [EditProfileView](FitPlate/View/EditProfileView.swift)

### [AnimatedTextView](FitPlate/View/AnimatedTextView.swift)

### [WorkoutView](FitPlate/View/WorkoutView.swift)

### [RecipeView](FitPlate/View/RecipeView.swift)

### [FilteredRecipesView](FitPlate/View/FilteredRecipesView.swift)

### [FitnessGoalView](FitPlate/View/FitnessGoalView.swift)

### [ImagePicker](FitPlate/View/Components/ImagePicker.swift)

## Models

### [User](FitPlate/Model/User.swift)

### [Profile](FitPlate/Model/Profile.swift)

### [FitnessGoal](FitPlate/Model/FitnessGoal.swift)

### [SavedRoutine](FitPlate/Model/SavedRoutine.swift)

### [WorkoutRoutine](FitPlate/Model/WorkoutRoutine.swift)

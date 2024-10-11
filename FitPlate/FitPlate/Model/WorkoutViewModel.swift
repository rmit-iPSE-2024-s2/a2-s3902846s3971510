import SwiftData
import SwiftUI

class WorkoutViewModel: ObservableObject {
    @Query(sort: \.name, order: .forward) var workouts: [Workout]  // Automatically fetch from SwiftData

    // Function to seed data if not already there
    func seedDataIfNeeded(context: ModelContext) {
        if workouts.isEmpty {
            let initialWorkouts = [
                Workout(name: "Pull Day Routine", imageName: "strength1", time: "90 mins", workoutDescription: "Push the limits with pull day exercises."),
                Workout(name: "Push Day Routine", imageName: "strength2", time: "90 mins", workoutDescription: "Push the limits with push day exercises."),
                Workout(name: "Intense Glute Workout", imageName: "strength3", time: "90 mins", workoutDescription: "Train your glutes with this high intensity lower body workout."),
                Workout(name: "7 Minute Daily Workout", imageName: "fullbody1", time: "7 mins", workoutDescription: "7 mins a day keeps the doctor away."),
                Workout(name: "Fullbody Mat Routine", imageName: "fullbody2", time: "20 mins", workoutDescription: "Grab your yoga mat and complete this low intensity full body workout."),
                Workout(name: "Moderate Intensity Fullbody Workout", imageName: "fullbody3", time: "30 mins", workoutDescription: "Moderate in intensity for a full body workout at home."),
                Workout(name: "Strength Dumbbell Workout", imageName: "dumbbell1", time: "20 mins", workoutDescription: "Train your core strength with this dumb bell only workout."),
                Workout(name: "Lower Body Workout", imageName: "dumbbell2", time: "15 mins", workoutDescription: "Minimal equipment lower body workout."),
                Workout(name: "Upper Body Workout", imageName: "dumbbell3", time: "15 mins", workoutDescription: "Minimal equipment upper body workout."),
                Workout(name: "Everyday Stretch Routine", imageName: "stretch1", time: "7 mins", workoutDescription: "Low intensity, quick and perfect to incorporate into your everyday life."),
                Workout(name: "Flexibility Stretch Routine", imageName: "stretch2", time: "10 mins", workoutDescription: "Perfect for those trying to increase their flexibility."),
                Workout(name: "Full Body Stretch Routine", imageName: "stretch3", time: "10 mins", workoutDescription: "Essential start for a great workout."),
                Workout(name: "Skipping Warm Up Routine", imageName: "cardio1", time: "10 mins", workoutDescription: "Warm up before your workout with this skipping routine."),
                Workout(name: "Outdoor Cardio Routine", imageName: "cardio2", time: "30 mins", workoutDescription: "Perfect for outdoors."),
                Workout(name: "Easy Treadmill Workout", imageName: "cardio3", time: "20 mins", workoutDescription: "Grab a friend and get your heart pumping with this treadmill routine.")
            ]

            for workout in initialWorkouts {
                context.insert(workout)
            }
        }
    }
}

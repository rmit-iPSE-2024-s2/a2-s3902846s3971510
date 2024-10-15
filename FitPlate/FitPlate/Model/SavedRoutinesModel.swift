import Foundation
import SwiftData

/**
 The `SavedRoutine` class represents a workout routine that a user has saved.
 
 The `SavedRoutine` model is managed by SwiftData to persist workout data across app sessions.
 
 Each `SavedRoutine` contains details about a workout, including the name, image, duration, and a brief description. This model is used in the FitPlate app to store and manage workout routines that the user has chosen to save.
  */


@Model
class SavedRoutine {
    /// The name of the workout routine.
    var name: String
    
    /// The name of the workout routine image.
    var imageName: String
    
    /// The duration of the workout routine as a string.
    var time: String
    
    /// A brief description of the workout routine.
    var workoutDescription: String

    /**
     Initialises a new `SavedRoutine` object with the provided name, image name, duration, and description.
     
     - Parameters:
        - name: The name of the workout routine.
        - imageName: The name of the image file associated with the workout.
        - time: The duration of the workout.
        - workoutDescription: A brief description of the workout routine.
     */
    
    init(name: String, imageName: String, time: String, workoutDescription: String) {
        self.name = name
        self.imageName = imageName
        self.time = time
        self.workoutDescription = workoutDescription
    }
}



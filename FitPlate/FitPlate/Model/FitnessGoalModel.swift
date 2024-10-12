import Foundation
import SwiftData

@Model
class FitnessGoal {
    var date: Date
    var workoutCompleted: Bool
    var stepsGoalMet: Bool
    var waterIntakeMet: Bool
    var sleepGoalMet: Bool
    
    var profile: Profile?
    
    init(date: Date, workoutCompleted: Bool = false, stepsGoalMet: Bool = false, waterIntakeMet: Bool = false, sleepGoalMet: Bool = false, profile: Profile? = nil) {
        self.date = date
        self.workoutCompleted = workoutCompleted
        self.stepsGoalMet = stepsGoalMet
        self.waterIntakeMet = waterIntakeMet
        self.sleepGoalMet = sleepGoalMet
        self.profile = profile
    }
}

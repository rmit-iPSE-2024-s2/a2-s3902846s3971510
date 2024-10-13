import Foundation
import SwiftData

@Model
class FitnessGoal {

    var workoutCompleted: Bool
    var stepsGoalMet: Bool
    var waterIntakeMet: Bool
    var sleepGoalMet: Bool
    var activeGoals: [String]
    var completedGoals: [String: Bool]
    var availableGoals: [String]

    init(workoutCompleted: Bool = false,
         stepsGoalMet: Bool = false,
         waterIntakeMet: Bool = false,
         sleepGoalMet: Bool = false,
         activeGoals: [String] = [],
         completedGoals: [String: Bool] = [:],
         availableGoals: [String] = []) {
        self.workoutCompleted = workoutCompleted
        self.stepsGoalMet = stepsGoalMet
        self.waterIntakeMet = waterIntakeMet
        self.sleepGoalMet = sleepGoalMet
        self.activeGoals = activeGoals
        self.completedGoals = completedGoals
        self.availableGoals = availableGoals  
    }
}

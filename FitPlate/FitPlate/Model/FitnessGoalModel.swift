import Foundation
import SwiftData

@Model
/**
A model class representing a user's fitness goals and tracking the status of various fitness goals
 */

class FitnessGoal {

    var workoutCompleted: Bool
    var stepsGoalMet: Bool
    var waterIntakeMet: Bool
    var sleepGoalMet: Bool
    var activeGoals: [String]
    var completedGoals: [String: Bool]
    var availableGoals: [String]

    /**
     Initializes a new `FitnessGoal` instance with default or provided values for each goal.
     */
    
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

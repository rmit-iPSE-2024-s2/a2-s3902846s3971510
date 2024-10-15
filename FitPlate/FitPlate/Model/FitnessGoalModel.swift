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
     Initialises a new `FitnessGoal` instance with default or provided values for each goal.
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
extension FitnessGoal {
    func addActiveGoal(_ goal: String) {
        activeGoals.append(goal)
    }
    
    func removeActiveGoal(_ goal: String) {
        activeGoals.removeAll { $0 == goal }
    }
    
    func completeGoal(_ goal: String) {
        completedGoals[goal] = true
        removeActiveGoal(goal)
    }
    
    func isGoalCompleted(_ goal: String) -> Bool {
        completedGoals[goal] ?? false
    }
    
    func hasMetAllGoals() -> Bool {
        stepsGoalMet && waterIntakeMet && sleepGoalMet && workoutCompleted
    }
    
    func hasActiveGoal(_ goal: String) -> Bool {
        activeGoals.contains(goal)
    }
    
    /// to mark completed
    func updateWorkoutCompletion(status: Bool) {
        workoutCompleted = status
    }
    
    func updateStepsGoal(status: Bool) {
        stepsGoalMet = status
    }
    
    func updateWaterIntake(status: Bool) {
        waterIntakeMet = status
    }
    
    func updateSleepGoal(status: Bool) {
        sleepGoalMet = status
    }
    
}



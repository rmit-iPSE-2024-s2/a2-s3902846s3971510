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

extension FitnessGoal  {
    // Updates the completion status of each fitness goal
    func updateGoals(workout: Bool, steps: Bool, water: Bool, sleep: Bool) {
        workoutCompleted = workout
        stepsGoalMet = steps
        waterIntakeMet = water
        sleepGoalMet = sleep
    }
    
    // Validates if all goals are met for a perfect day
    func isPerfectDay() -> Bool {
        return workoutCompleted && stepsGoalMet && waterIntakeMet && sleepGoalMet
    }
    
    // Returns the proportion of goals met
    func proportionOfGoalsMet() -> Double {
        let goals = [workoutCompleted, stepsGoalMet, waterIntakeMet, sleepGoalMet]
        let metGoals = goals.filter { $0 }.count
        return Double(metGoals) / Double(goals.count)
    }
}



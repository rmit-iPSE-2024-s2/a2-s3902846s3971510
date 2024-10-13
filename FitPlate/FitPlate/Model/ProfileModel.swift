import Foundation
import SwiftData

/**
 The `Profile` class represents a user's profile information within the FitPlate app.
 
 */
@Model
class Profile {
    
    var username: String
    var goal: String
    var goalWeight: Int
    var calories: Int
    var stepGoal: Int

    /**
     Initializes a new `Profile` instance with default or provided values.
     
     - Parameters:
       - username: The user's username. Defaults to `"Username"`.
       - goal: The user's fitness goal. Defaults to an empty string.
       - goalWeight: The target goal weight in kilograms. Defaults to `0`.
       - calories: The daily calorie intake goal. Defaults to `2000`.
       - stepGoal: The daily step goal. Defaults to `10000`.
     */
    init(username: String = "Username", goal: String = "", goalWeight: Int = 0, calories: Int = 2000, stepGoal: Int = 10000) {
        self.username = username
        self.goal = goal
        self.goalWeight = goalWeight
        self.calories = calories
        self.stepGoal = stepGoal
    }
}
extension Profile {
    
    func updateProfile(goal: String, goalWeight: Int, calories: Int, stepGoal: Int) {
        self.goal = goal
        self.goalWeight = goalWeight
        self.calories = calories
        self.stepGoal = stepGoal
    }
    
    func progressTowardsStepGoal(currentSteps: Int) -> Double {
        return Double(currentSteps) / Double(stepGoal)
    }

    func progressTowardsWeightGoal(currentWeight: Int) -> Double {
        if goalWeight == 0 || currentWeight == 0 {
            return 0.0
        }
        return Double(goalWeight - currentWeight) / Double(goalWeight)
    }
    
    func validateCalories() -> Bool {
        return calories >= 1200 && calories <= 4000
    }

    func validateStepGoal() -> Bool {
        return stepGoal >= 1000 && stepGoal <= 30000
    }
}

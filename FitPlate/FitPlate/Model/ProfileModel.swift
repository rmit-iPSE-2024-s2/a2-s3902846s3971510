import Foundation
import SwiftData

@Model
class Profile {
    var username: String
    var nutrition: String
    var goal: String
    var goalWeight: Int
    var calories: Int
    var stepGoal: Int

    init(username: String = "Username", nutrition: String = "Default", goal: String = "", goalWeight: Int = 0, calories: Int = 2000, stepGoal: Int = 10000) {
        self.username = username
        self.nutrition = nutrition
        self.goal = goal
        self.goalWeight = goalWeight
        self.calories = calories
        self.stepGoal = stepGoal
    }
    
    
}

extension Profile {
    
    func updateProfile(nutrition: String, goal: String, goalWeight: Int, calories: Int, stepGoal: Int) {
        self.nutrition = nutrition
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

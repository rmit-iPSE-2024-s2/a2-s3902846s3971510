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

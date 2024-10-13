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

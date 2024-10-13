//
//  FitPlateTest.swift
//  FitPlateTest
//
//  Created by Monessha Vetrivelan on 13/10/2024.
//

import XCTest
@testable import FitPlate

final class FitPlateTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUpdateProfile() {
        let profile = Profile()
        profile.updateProfile( goal: "Lose Weight", goalWeight: 150, calories: 1800, stepGoal: 12000)
        
        XCTAssertEqual(profile.goal, "Lose Weight")
        XCTAssertEqual(profile.goalWeight, 150)
        XCTAssertEqual(profile.calories, 1800)
        XCTAssertEqual(profile.stepGoal, 12000)
    }
    
    func testProgressTowardsStepGoal() {
        let profile = Profile(stepGoal: 10000)
        let progress = profile.progressTowardsStepGoal(currentSteps: 5000)
        
        XCTAssertEqual(progress, 0.5)
    }
    
    func testProgressTowardsWeightGoal() {
        let profile = Profile(goalWeight: 200)
        let progress = profile.progressTowardsWeightGoal(currentWeight: 150)
        XCTAssertEqual(progress, 0.25, "The progress towards weight goal calculation is incorrect.")
        
        // Testing edge cases
        profile.goalWeight = 0
        XCTAssertEqual(profile.progressTowardsWeightGoal(currentWeight: 150), 0.0, "Progress should be 0 when goal weight is zero.")
        
        profile.goalWeight = 200
        XCTAssertEqual(profile.progressTowardsWeightGoal(currentWeight: 0), 0.0, "Progress should be 0 when current weight is zero.")
    }
    
    func testValidateCalories() {
        let profile = Profile(calories: 1800)
        XCTAssertTrue(profile.validateCalories(), "Calories should be valid when within the range.")
        
        profile.calories = 1100
        XCTAssertFalse(profile.validateCalories(), "Calories should be invalid when below the minimum range.")
        
        profile.calories = 4100
        XCTAssertFalse(profile.validateCalories(), "Calories should be invalid when above the maximum range.")
    }
    
    func testValidateStepGoal() {
        let profile = Profile(stepGoal: 5000)
        XCTAssertTrue(profile.validateStepGoal(), "Step goal should be valid within the acceptable range.")
        
        profile.stepGoal = 500
        XCTAssertFalse(profile.validateStepGoal(), "Step goal should be invalid when below the minimum range.")
        
        profile.stepGoal = 31000
        XCTAssertFalse(profile.validateStepGoal(), "Step goal should be invalid when above the maximum range.")
    }
    
    func testInitialValues() {
        let profile = Profile()
        XCTAssertEqual(profile.username, "Username", "Initial username should be 'Username'.")
        XCTAssertEqual(profile.goal, "", "Initial goal should be empty.")
        XCTAssertEqual(profile.goalWeight, 0, "Initial goal weight should be zero.")
        XCTAssertEqual(profile.calories, 2000, "Initial calories should be 2000.")
        XCTAssertEqual(profile.stepGoal, 10000, "Initial step goal should be 10000.")
    }
    
    func testAddActiveGoal() {
        let goal = FitnessGoal()
        goal.addActiveGoal("Run 5k")
        XCTAssertTrue(goal.activeGoals.contains("Run 5k"))
    }

    func testRemoveActiveGoal() {
        let goal = FitnessGoal(activeGoals: ["Run 5k"])
        goal.removeActiveGoal("Run 5k")
        XCTAssertFalse(goal.activeGoals.contains("Run 5k"))
    }

    func testCompleteGoal() {
        let goal = FitnessGoal(activeGoals: ["Run 5k"])
        goal.completeGoal("Run 5k")
        XCTAssertTrue(goal.isGoalCompleted("Run 5k"))
        XCTAssertFalse(goal.hasActiveGoal("Run 5k"))
    }

    func testHasMetAllGoals() {
        let goal = FitnessGoal(workoutCompleted: true, stepsGoalMet: true, waterIntakeMet: true, sleepGoalMet: true)
        XCTAssertTrue(goal.hasMetAllGoals())
    }

    func testUpdateWorkoutCompletion() {
        let goal = FitnessGoal()
        goal.updateWorkoutCompletion(status: true)
        XCTAssertTrue(goal.workoutCompleted)
    }

}

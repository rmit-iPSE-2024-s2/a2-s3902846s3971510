//
//  RecipeView.swift
//  FitPlate
//
//  Created by margaret on 31/8/2024.
//

import SwiftUI

struct RecipeView: View {
    // hard coded for the dropdown menus
    let dietTypes = ["Any", "Keto", "Paleo", "Vegan", "Vegetarian"]
    let cuisineTypes = ["Any", "Italian", "Mexican", "Indian", "Chinese", "Mediterranean"]
    let preparationTimes = ["Any", "< 15 mins", "15-30 mins", "30-45 mins", "> 45 mins"]
    let calorieRanges = ["<200", "<300", "<400", ">500"]
    
    // state variables for drop down data
    @State private var selectedDietType = "Select"
    @State private var selectedCuisineType = "Select"
    @State private var selectedPreparationTime = "Select"
    @State private var selectedCalorieRange = "Select"
    
    var body: some View {
        VStack {
            Text("Recipes")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.404, green: 0.773, blue: 0.702))
                .padding()
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color(red: 0.404, green: 0.773, blue: 0.702))
                Text("Recipe Search")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 16)

            // Drop downs for recipe generation
            VStack(alignment: .leading, spacing: 16) {
                // Diet type
                VStack(alignment: .leading) {
                    Text("Diet Type")
                        .font(.headline)
                    Menu {
                        ForEach(dietTypes, id: \.self) { diet in
                            Button(action: { selectedDietType = diet }) {
                                Text(diet)
                            }
                        }
                    } label: {
                        Text(selectedDietType)
                            .foregroundColor(selectedDietType == "Select" ? Color(red: 0.404, green: 0.773, blue: 0.702) : .black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                }

                // Cuisine type
                VStack(alignment: .leading) {
                    Text("Cuisine Type")
                        .font(.headline)
                    Menu {
                        ForEach(cuisineTypes, id: \.self) { cuisine in
                            Button(action: { selectedCuisineType = cuisine }) {
                                Text(cuisine)
                            }
                        }
                    } label: {
                        Text(selectedCuisineType)
                            .foregroundColor(selectedCuisineType == "Select" ? Color(red: 0.404, green: 0.773, blue: 0.702) : .black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                }

                // prep time
                VStack(alignment: .leading) {
                    Text("Preparation Time")
                        .font(.headline)
                    Menu {
                        ForEach(preparationTimes, id: \.self) { time in
                            Button(action: { selectedPreparationTime = time }) {
                                Text(time)
                            }
                        }
                    } label: {
                        Text(selectedPreparationTime)
                            .foregroundColor(selectedPreparationTime == "Select" ? Color(red: 0.404, green: 0.773, blue: 0.702) : .black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                }

                // Calorie range
                VStack(alignment: .leading) {
                    Text("Calories")
                        .font(.headline)
                    Menu {
                        ForEach(calorieRanges, id: \.self) { range in
                            Button(action: { selectedCalorieRange = range }) {
                                Text(range)
                            }
                        }
                    } label: {
                        Text(selectedCalorieRange)
                            .foregroundColor(selectedCalorieRange == "Select" ? Color(red: 0.404, green: 0.773, blue: 0.702) : .black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                }
            }
            .padding()

            // generate button
            Button(action: {
            }) {
                Text("Generate")
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 1.0, green: 0.569, blue: 0.396))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    RecipeView()
}

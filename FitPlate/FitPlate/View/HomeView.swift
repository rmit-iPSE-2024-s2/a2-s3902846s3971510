//
//  HomeView.swift
//  FitPlate
//
//  Created by margaret on 31/8/2024.
//

import SwiftUI

import SwiftUI

// initialise data
struct Recipe: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let time: String
    let description: String
}

struct Workout: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let time: String
    let description: String
}

struct HomeView: View {
    // hard coded data for recipes and workouts
    let recipes = [
        Recipe(name: "Salmon with Asparagus", imageName: "recipe1", time: "30 mins", description: "Tender salmon fillets with garlic butter asparagus."),
        Recipe(name: "Easy Beef Stir Fry", imageName: "recipe2", time: "15 mins", description: "Delicious and healthy Chinese style beef stirfry."),
        Recipe(name: "High Protein Oat Cookies", imageName: "recipe3", time: "20 mins", description: "Convenient and customisable oat cookie recipe."),

    ]
    
    let workouts = [
        Workout(name: "HIIT Workout", imageName: "workout1", time: "45 mins", description: "A high-intensity interval training session to burn fat."),
        Workout(name: "Full Body Workout", imageName: "workout2", time: "60 mins", description: "A moderate intensity workout tackling all areas of the body."),
        Workout(name: "Calming Yoga", imageName: "workout3", time: "50 mins", description: "Release inner tensions with this calming yoga routine.")
    ]
    
    var body: some View {
        ScrollView {
            VStack {
                // logo header
                HStack {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)

                    HStack(spacing: 0) {
                        Text("Fit")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 1.0, green: 0.569, blue: 0.396))

                        Text("Plate")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.404, green: 0.773, blue: 0.702))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding([.top, .leading, .trailing])
                .multilineTextAlignment(.center)

                // welcome message
                Text("Welcome User!")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding([.leading, .trailing, .bottom])

                // DASHBOARD  Vstack for quick stats
                VStack(alignment: .leading) {
                    Text("Dashboard")
                        .font(.headline)
                        .padding(.leading)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Steps Walked")
                            Text("10,000")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Image(systemName: "figure.walk")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .foregroundColor(.blue)
                            
                        }
                        .padding()
                        .frame(width: 160, height: 130)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                        
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("Weight Tracker")
                            Image(systemName: "chart.bar.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 60)
                                .padding(.top)
                        }
                        .padding()
                        .frame(width: 160, height: 130)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                    }
                    .padding([.leading, .trailing, .bottom])
                }

                // Trending Recipes Carousel
                Text("Trending Recipes")
                    .font(.headline)
                    .padding(.leading)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(recipes) { recipe in
                            VStack(alignment: .leading, spacing: 0) {
                                Image(recipe.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 250, height: 150)
                                    .clipped()
                                
                                
                                Text(recipe.name)
                                    .font(.headline)
                                    .padding([.top, .leading, .trailing])
                                
                                HStack {
                                    Image(systemName: "clock")
                                    Text(recipe.time)
                                        .font(.subheadline)
                                }
                                .padding([.leading, .trailing, .bottom])
                                
                                Text(recipe.description)
                                    .font(.subheadline)
                                    .lineLimit(2)
                                    .padding([.leading, .trailing, .bottom])
                            }
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .frame(width: 250)
                        }
                    }
                }
                .padding(.bottom)

                // Trending Workouts Carousel
                Text("Trending Workouts")
                    .font(.headline)
                    .padding(.leading)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(workouts) { workout in
                            VStack(alignment: .leading, spacing: 0) {
                                Image(workout.imageName)  // workout images
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 250, height: 150)
                                    .clipped()
                                
                                Text(workout.name)
                                    .font(.headline)
                                    .padding([.top, .leading, .trailing])
                                
                                HStack {
                                    Image(systemName: "clock")
                                    Text(workout.time)
                                        .font(.subheadline)
                                }
                                .padding([.leading, .trailing, .bottom])
                                
                                Text(workout.description)
                                    .font(.subheadline)
                                    .lineLimit(2)
                                    .padding([.leading, .trailing, .bottom])
                            }
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .frame(width: 250)
                        }
                    }
                }
                .padding(.bottom)
            }
        }
        .padding()
    }
}

#Preview {
    HomeView()
}



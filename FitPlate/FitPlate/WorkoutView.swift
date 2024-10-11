//
//  WorkoutView.swift
//  FitPlate
//
//  Created by margaret on 31/8/2024.
//

import SwiftUI

struct WorkoutView: View {
    // state to switch between workout views
    @State private var selectedTab = "Explore"
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        VStack {
            // ScrollView with offset detection
            ScrollView {
                GeometryReader { geometry in
                    Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).minY)
                }
                .frame(height: 0)
                
                VStack {
        
                    Text("Workouts")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 1.0, green: 0.569, blue: 0.396))
                        .padding(.top, scrollOffset > -100 ? 20 : 0)
                        .opacity(scrollOffset > -100 ? 1 : 0)

                    // nav tabs
                    HStack {
                        Button(action: {
                            withAnimation {
                                selectedTab = "Explore"
                            }
                        }) {
                            Text("Explore")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedTab == "Explore" ? Color(red: 0.819, green: 0.302, blue: 0.408) : Color.white)
                                .foregroundColor(selectedTab == "Explore" ? Color.white : Color.black)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(red: 0.819, green: 0.302, blue: 0.408), lineWidth: selectedTab == "Explore" ? 0 : 1)
                                )
                        }
                        .cornerRadius(8)
                        
                        Button(action: {
                            withAnimation {
                                selectedTab = "My Routines"
                            }
                        }) {
                            Text("My Routines")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedTab == "My Routines" ? Color(red: 0.819, green: 0.302, blue: 0.408) : Color.white)
                            
                                .foregroundColor(selectedTab == "My Routines" ? Color.white : Color.black)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(red: 0.819, green: 0.302, blue: 0.408), lineWidth: selectedTab == "My Routines" ? 0 : 1)
                                )
                        }
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    .opacity(scrollOffset > -100 ? 1 : 0)
                }
                .padding(.bottom, scrollOffset > -100 ? 20 : 0)
                .background(Color.white)
                .offset(y: scrollOffset > -100 ? 0 : -100)
                .animation(.easeInOut(duration: 0.3), value: scrollOffset)
                
                
                // Explore content
                
                if selectedTab == "Explore" {
                    // hardcoded values for workout carousels
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // STRENGTH
                        
                        WorkoutCategoryView(category: "Strength Training", imagePrefix: "strength", workoutNames: [
                            "Pull Day Routine", "Push Day Routine", "Intense Glute Workout"
                        ], descriptions: [
                            "Push the limits with pull day exercises.",
                            "Push the limits with push day exercises.",
                            "Train your glutes with this high intensity lower body workout."
                        ], durations: [
                            "90 mins", "90 mins", "90 mins"
                        ])
                        
                        // FULLBODY
                        WorkoutCategoryView(category: "Full Body Workouts", imagePrefix: "fullbody", workoutNames: [
                            "7 Minute Daily Workout", "Fullbody Mat Routine", "Moderate Intensity Fullbody Workout"
                        ], descriptions: [
                            "7 mins a day keeps the doctor away.",
                            "Grab your yoga mat and complete this low intensity full body workout.",
                            "Moderate in intensity for a full body workout at home."
                        ], durations: [
                            "7 mins", "20 mins", "30 mins"
                        ])
                        
                        //DUMBBELL
                        WorkoutCategoryView(category: "DumbBell Only", imagePrefix: "dumbbell", workoutNames: [
                            "Strength Dumbbell Workout", "Lower Body Workout", "Upper Body Workout"
                        ], descriptions: [
                            "Train your core strength with this dumb bell only workout. ",
                            "Minimal equipment lower body workout.",
                            "Minimal equipment upper body workout."
                        ], durations: [
                            "20 mins", "15 mins", "15 mins"
                        ])
                        
                        // STRETCHING
                        
                        WorkoutCategoryView(category: "Stretching Routines", imagePrefix: "stretch", workoutNames: [
                            "Everyday Stretch Routine", "Flexibility Stretch Routine", "Full Body Stretch Routine"
                        ], descriptions: [
                            "Low intensity, quick and perfect to incorporate into your everyday life.",
                            "Perfect for those trying to increase their flexibility.",
                            "Essential start for a great workout."
                        ], durations: [
                            "7 mins", "10 mins", "10 mins"
                        ])
                        
                        // CARDIO
                        WorkoutCategoryView(category: "Cardio", imagePrefix: "cardio", workoutNames: [
                            "Skipping Warm Up Routine", "Outdoor Cardio Routine", "Easy Tredmil Workout"
                        ], descriptions: [
                            "Warm up before your workout with this skipping routine.",
                            "Perfect for outdoors.",
                            "Grab a friend and get your heart pumping with this tredmil routine."
                        ], durations: [
                            "10 mins", "30 mins", "20 mins"
                        ])
                    }
                    .padding()
                } else {
                    // my routines content
                    Text("My Routines, this will be added later.")
                        .font(.headline)
                        .padding()
                    
                    Spacer()
                }
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                withAnimation {
                    scrollOffset = value
                }
            }
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


// initialising data for workout carousel views
struct WorkoutCategoryView: View {
    let category: String
    let imagePrefix: String
    let workoutNames: [String]
    let descriptions: [String]
    let durations: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(category)
                .font(.headline)
                .padding(.leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<3) { index in
                        VStack(alignment: .leading, spacing: 0) {
                            Image("\(imagePrefix)\(index + 1)")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 250, height: 150)
                                .clipped()
                            
                            Text(workoutNames[index])
                                .font(.headline)
                                .padding([.top, .leading, .trailing])
                            
                            HStack {
                                Image(systemName: "clock")
                                Text(durations[index])
                                    .font(.subheadline)
                            }
                            .padding([.leading, .trailing, .bottom])
                            
                            Text(descriptions[index])
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
        }
        .padding(.bottom)
    }
}

#Preview {
    WorkoutView()
}

//
//  HomeView.swift
//  FitPlate
//
//  Created by margaret on 31/8/2024.
//

import SwiftUI

/**
 The `HomeView` serves as the main landing page for users after logging in. 
 
 It provides a welcome message, displays the app's logo, and includes a simple dashboard with quick stats like steps walked and weight tracking.
 
 These are hard coded values are are not currently fetched or stored in SwiftData.
 */

struct HomeView: View {

    var body: some View {
        ScrollView {
            VStack {
                // App logo and header section
                HStack {
                    // Display app logo
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)

                    // App name as header "FitPlate"
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

                // Welcome message for the user
                Text("Welcome User!")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding([.leading, .trailing, .bottom])

                // Dashboard section displaying user fitness stats
                VStack(alignment: .leading) {
                    // Dashboard heading
                    Text("Dashboard")
                        .font(.headline)
                        .padding(.leading)
                    
                    // Display quick stats: Steps walked and weight tracker
                    HStack {
                        // Steps walked stat box
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
                        
                        // Weight tracker stat box
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
            }
        }
        .padding()
    }
}

#Preview {
    HomeView()
}

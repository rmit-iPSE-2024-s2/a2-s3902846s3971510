//
//  HomeView.swift
//  FitPlate
//
//  Created by margaret on 31/8/2024.
//

import SwiftUI

import SwiftUI


struct HomeView: View {

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
            }
        }
        .padding()
    }
}

#Preview {
    HomeView()
}

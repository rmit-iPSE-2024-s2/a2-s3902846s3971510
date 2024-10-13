//
//  ProfileView.swift
//  FitPlate
//
//  Created by margaret on 31/8/2024.
//

import SwiftUI
import SwiftData
import UIKit

struct ProfileView: View {
    @State private var profileImage: Image? = nil  // var to hold profile image displayed
    @State private var showImagePicker = false  // to toggle UIKit image picker
    @State private var inputImage: UIImage? = nil  // to hold selected image from UIKit image picker
    @Environment(\.modelContext) var modelContext  // access to swiftData model
    @Query var profiles: [Profile]  // query profile

    var body: some View {
        let profile = profiles.first

        VStack(spacing: 20) {
            // My Profile header
            Text("My Profile")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.404, green: 0.773, blue: 0.702))  // green
                .padding(.leading, 20)

            HStack {
                // Profile picture
                if let profileImage = profileImage {
                    profileImage
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .padding(.leading, 20)
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color.gray)
                        .padding(.leading, 20)
                }

                // username
                Text(profile?.username ?? "Username")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading, 10)

                Spacer()
            }
            .padding(.top, 30)

            // buttons for Edit Picture and Edit Profile
            HStack(spacing: 20) {
                // UIKit-based Image Picker button
                Button(action: {
                    showImagePicker = true  // Show the UIKit Image Picker
                }) {
                    Text("Edit Picture")
                        .font(.headline)
                        .frame(minWidth: 120)
                        .padding()
                        .background(Color(red: 0.819, green: 0.302, blue: 0.408))  // pink
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .sheet(isPresented: $showImagePicker) {
                    // Present the UIKit Image Picker
                    ImagePicker(selectedImage: $inputImage)
                }
                .onChange(of: inputImage) {
                    loadImage()  // Load the image when it's selected
                }

                // Edit Profile button
                NavigationLink(destination: EditProfileView(profile: profile)) {
                    Text("Edit Profile")
                        .font(.headline)
                        .frame(minWidth: 120)
                        .padding()
                        .background(Color(red: 1.0, green: 0.569, blue: 0.396))  // orange
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 60)

            // My Goals section
            VStack(alignment: .leading, spacing: 10) {
                Text("My Goals")
                    .font(.headline)
                    .fontWeight(.bold)

                if let profile = profile {
                    Text("Goal: \(profile.goal)")
                    Text("Goal Weight: \(profile.goalWeight) kg")
                    Text("Calories: \(profile.calories)")
                    Text("Step Goal: \(profile.stepGoal)")
                } else {
                    Text("You have not selected your goals.")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()
        }
        .padding()
    }

    // Function to convert UIImage to SwiftUI Image and assign to profileImage
    private func loadImage() {
        guard let inputImage = inputImage else { return }
        profileImage = Image(uiImage: inputImage)
    }
}

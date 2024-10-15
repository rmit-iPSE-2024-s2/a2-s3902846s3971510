//
//  ProfileView.swift
//  FitPlate
//
//  Created by margaret on 31/8/2024.
//

import SwiftUI
import SwiftData
import UIKit

/**
 The `ProfileView` displays the user's profile, including the profile picture, username, and fitness goals.
 */

struct ProfileView: View {
    
    /// A SwiftUI `Image` representing the user's profile picture. If nil, a default placeholder image is shown.
    @State private var profileImage: Image? = nil
    
    /// A boolean that toggles the display of the UIKit-based image picker when set to true.
    @State private var showImagePicker = false
    
    /// A `UIImage` that holds the image selected by the user from the UIKit image picker.
    @State private var inputImage: UIImage? = nil
    
    /// Provides access to the SwiftData model context for saving or fetching data.
    @Environment(\.modelContext) var modelContext

    @Query var profiles: [Profile]

    var body: some View {
        /// Fetch the first profile from the query results.
        let profile = profiles.first

        VStack(spacing: 20) {
            // Header displaying "My Profile"
            Text("My Profile")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.404, green: 0.773, blue: 0.702))  // green color
                .padding(.leading, 20)

            HStack {
                // Display the profile picture if available, or a default placeholder if not.
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

                // Display the username, or "Username" if no profile is found.
                Text(profile?.username ?? "Username")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading, 10)

                Spacer()
            }
            .padding(.top, 30)

            // Buttons to edit profile picture or edit profile details.
            HStack(spacing: 20) {
                // Button to show the UIKit image picker.
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
                    /// Present the UIKit Image Picker
                    ImagePicker(selectedImage: $inputImage)
                }
                .onChange(of: inputImage) {
                    loadImage()  /// Load the image when it's selected
                }

                /// Navigation link to the Edit Profile view.
                NavigationLink(destination: EditProfileView(profile: profile)) {
                    Text("Edit Profile")
                        .font(.headline)
                        .frame(minWidth: 120)
                        .padding()
                        .background(Color(red: 1.0, green: 0.569, blue: 0.396))  // orange color
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 60)

            /// Display user's fitness goals or a placeholder message if no goals are set.
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

            Spacer()  /// Pushes content to the top of the view.
        }
        .padding()
        .onAppear {
            if let profile = profiles.first, let imageData = profile.profileImageData {
                if let uiImage = UIImage(data: imageData) {
                    profileImage = Image(uiImage: uiImage)
                }
            }
        }
    }

    /**
     Converts the selected `UIImage` from the UIKit image picker into a SwiftUI `Image` and assigns it to `profileImage`.
     
     This function is triggered whenever the `inputImage` changes.
     */
    
    private func loadImage() {
        guard let inputImage = inputImage else { return }
        profileImage = Image(uiImage: inputImage)
        
        if let profile = profiles.first {
            if let imageData = inputImage.jpegData(compressionQuality: 0.8) {
                profile.profileImageData = imageData
                try? modelContext.save()
            }
        }
    }
}

import SwiftUI
struct SignupView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var signedUp = false  // to track if sign-up is successful
    var body: some View {
        VStack(spacing: 20) {
            Text("Sign Up")
                .font(.largeTitle)
                .fontWeight(.bold)
            // Email
            TextField("Email", text: $email)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .keyboardType(.emailAddress)
            // Password
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            // Confirm Password
            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            // Sign Up Button
            Button(action: {
                signedUp = true
            }) {
                Text("Sign Up")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.404, green: 0.773, blue: 0.702))  // Green color
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 40)
            .navigationDestination(isPresented: $signedUp) {
                LoginView()  // nav to login after signup
            }
            Spacer()
            // nav to login view if already a member
            NavigationLink(destination: LoginView()) {
                Text("Already a member? Login")
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
}

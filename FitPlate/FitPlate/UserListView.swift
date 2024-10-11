import SwiftUI
import SwiftData

struct UsersView: View {
    @Query var users: [User]
    @Environment(\.modelContext) var modelContext

    var body: some View {
        List(users, id: \.email) { user in
            HStack {
                Text(user.email)  // Display the user's email instead of name
                    .fontWeight(.medium)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Optional: Display some other information or an icon
                Image(systemName: "person.fill")
                    .foregroundColor(.blue)
                    .padding()
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .padding(.horizontal)
        }
    }

    init(sortOrder: [SortDescriptor<User>]) {
        // Assuming you adjust your query to fetch based on your model's capabilities
        _users = Query(filter: nil, sort: sortOrder)
    }
}

// Assuming you are still using SortDescriptor if it's part of your environment setup
#Preview {
    UsersView(sortOrder: [SortDescriptor(\User.email)])
        .modelContainer(for: User.self)
}


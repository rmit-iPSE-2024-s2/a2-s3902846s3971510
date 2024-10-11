import SwiftUI
import SwiftData

struct UsersView: View {
    @Query var users: [User]
    @Environment(\.modelContext) var modelContext

    var body: some View {
        List(users, id: \.email) { user in
            HStack {
                Text(user.email) 
                    .fontWeight(.medium)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)

                
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

        _users = Query(filter: nil, sort: sortOrder)
    }
}

#Preview {
    UsersView(sortOrder: [SortDescriptor(\User.email)])
        .modelContainer(for: User.self)
}


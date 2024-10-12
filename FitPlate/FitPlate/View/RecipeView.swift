import SwiftUI

struct RecipeView: View {
    struct CategoriesResponse: Codable {
        let categories: [Category]
    }

    struct Category: Codable {
        let strCategory: String
    }

    struct CuisinesResponse: Codable {
        let meals: [Cuisine]
    }

    struct Cuisine: Codable {
        let strArea: String
    }
    // Start with the default values and add to them
    @State private var categoryTypes: [String] = ["Any"]
    @State private var cuisineTypes: [String] = ["Any"]
    @State private var selectedDietType = "Select"
    @State private var selectedCuisineType = "Select"
    @State private var navigateToFiltered = false

    var body: some View {
        VStack {
            Text("Recipes")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.404, green: 0.773, blue: 0.702))
                .padding()

            // Dynamic drop-downs for recipe generation
            VStack(alignment: .leading, spacing: 16) {
                menuDropdown(title: "Diet Type", items: categoryTypes, selectedItem: $selectedDietType)
                menuDropdown(title: "Cuisine Type", items: cuisineTypes, selectedItem: $selectedCuisineType)
            }
            .padding()

            // Generate button
            Button("Generate") {
                navigateToFiltered = true  // This will trigger navigation
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal, 40)
            .navigationDestination(isPresented: $navigateToFiltered, destination: {
                FilteredRecipesView(selectedCategory: selectedDietType, selectedCuisine: selectedCuisineType)
            })
            Spacer()
        }
        .onAppear {
            fetchCategoryTypes()
            fetchCuisineTypes()
        }
    }

    private func fetchCategoryTypes() {
        let urlString = "https://www.themealdb.com/api/json/v1/1/categories.php"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(CategoriesResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.categoryTypes += decodedResponse.categories.map { $0.strCategory }
                    }
                }
            } else {
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }

    private func fetchCuisineTypes() {
        let urlString = "https://www.themealdb.com/api/json/v1/1/list.php?a=list"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(CuisinesResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.cuisineTypes += decodedResponse.meals.map { $0.strArea }
                    }
                }
            } else {
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }

    @ViewBuilder
    private func menuDropdown(title: String, items: [String], selectedItem: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(title).font(.headline)
            Menu {
                ForEach(items, id: \.self) { item in
                    Button(item) {
                        selectedItem.wrappedValue = item
                    }
                }
            } label: {
                HStack {
                    Text(selectedItem.wrappedValue)
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .padding()
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
            }
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(Color(red: 0.404, green: 0.773, blue: 0.702))
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView()
    }
}

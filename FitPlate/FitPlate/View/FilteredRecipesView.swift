import SwiftUI

struct FilteredRecipesView: View {
    var selectedCategory: String
    var selectedCuisine: String
    @State private var filteredRecipes: [Recipe] = []

    var body: some View {
        NavigationView {
            // Check if the list is empty and display appropriate content
            if filteredRecipes.isEmpty {
                // If no recipes are loaded yet or none match the criteria, show a message
                VStack {
                    Spacer()
                    Text("No recipes found for \(selectedCategory) in \(selectedCuisine).")
                        .padding()
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            } else {
                // Display the list of recipes
                List(filteredRecipes, id: \.id) { recipe in
                    VStack(alignment: .leading) {
                        if let imageUrl = URL(string: recipe.strMealThumb) {
                            AsyncImage(url: imageUrl) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 200)
                                    .clipped()
                            } placeholder: {
                                ProgressView()
                                    .frame(height: 200)
                            }
                        }
                        
                        Text(recipe.strMeal)
                            .font(.headline)
                        Text(recipe.strArea ?? "No region info")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                }
            }
        }
        .onAppear {
            loadRecipesByCategory()
        }
    }

    func loadRecipesByCategory() {
        let categoryLowercased = selectedCategory.lowercased()
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(categoryLowercased)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let mealsResponse = try JSONDecoder().decode(MealResponse.self, from: data)
                for meal in mealsResponse.meals {
                    self.loadRecipeDetail(for: meal.idMeal)
                }
            } catch {
                print("Decoding failed: \(error)")
            }
        }.resume()
    }

    func loadRecipeDetail(for idMeal: String) {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(idMeal)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let detailResponse = try JSONDecoder().decode(MealResponse.self, from: data)
                if let detailedMeal = detailResponse.meals.first {
                    DispatchQueue.main.async {
                        if detailedMeal.strArea?.lowercased() == self.selectedCuisine.lowercased() {
                            self.filteredRecipes.append(detailedMeal)
                        }
                    }
                }
            } catch {
                print("Detailed decoding failed: \(error)")
            }
        }.resume()
    }
}


struct Recipe: Codable, Identifiable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    var strArea: String?  // This should be optional to handle cases where area might not be provided

    var id: String { idMeal }
}

struct MealResponse: Codable {
    let meals: [Recipe]
}

struct FilteredRecipesView_Previews: PreviewProvider {
    static var previews: some View {
        FilteredRecipesView(selectedCategory: "Chicken", selectedCuisine: "Japanese")
    }
}

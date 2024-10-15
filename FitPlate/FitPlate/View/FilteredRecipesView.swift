import SwiftUI

/**
 The `FilteredRecipesView` displays recipes based on the user's selected dropdowns in category and cuisine type.
 
 This view fetches recipes from TheMealDB API by category and cuisine type. If no recipes match the criteria, a message is shown to the user.
 */
struct FilteredRecipesView: View {
    
    var selectedCategory: String
    var selectedCuisine: String
    @State private var filteredRecipes: [Recipe] = []
    @State private var zoomedRecipeID: String? = nil

    var body: some View {
        NavigationView {
            if filteredRecipes.isEmpty {
                Text("No recipes found for \(selectedCategory) in \(selectedCuisine).")
                    .multilineTextAlignment(.center)
            } else {
                List(filteredRecipes, id: \.id) { recipe in
                    RecipeCardView(recipe: recipe,
                                   isZoomed: Binding<Bool>(
                                       get: { self.zoomedRecipeID == recipe.id },
                                       set: { isZoomed in
                                           self.zoomedRecipeID = isZoomed ? recipe.id : nil
                                       }
                                   ))
                }
            }
        }
        .onAppear {
            loadRecipesByCategory()
        }.padding(.bottom, 10)
    }

    /**
     Fetches recipes from TheMealDB API based on the selected category.
     
     This function makes an API call to retrieve recipes for the selected category and then loads detailed information for each recipe to filter them by cuisine type.
     */
    
    struct RecipeCardView: View {
        let recipe: Recipe
        @Binding var isZoomed: Bool

        var body: some View {
            VStack(alignment: .leading) {
                AsyncImage(url: URL(string: recipe.strMealThumb)) { image in
                    image.resizable()
                         .aspectRatio(contentMode: .fill)
                         .frame(height: isZoomed ? 100 : 200)
                         .clipped()
                } placeholder: {
                    ProgressView().frame(height: 200)
                }

                Text(recipe.strMeal)
                    .font(isZoomed ? .title : .headline)
                    .padding(.top, 5)

                if let area = recipe.strArea {
                    Text(area)
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }

                if isZoomed {
                    Text("Ingredients and Instructions:")
                        .font(.headline)
                    // Assuming ingredients and instructions are available
                    Text(recipe.strInstructions ?? "")
                        .font(.body)
                        .padding()
                }

            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .onTapGesture (count:2) {
                withAnimation {
                    isZoomed.toggle()
                }
            }
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
                print("Error decoding the category response: \(error)")
            }
        }.resume()
    }

    /**
     Loads detailed information for a specific recipe by its ID and filters by the selected cuisine.
     
     If the recipe matches the selected cuisine, it is added to the list of filtered recipes.
     
     - Parameter idMeal: The unique ID of the meal to fetch details for.
     */
    
    
    func loadRecipeDetail(for idMeal: String) {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(idMeal)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let detailResponse = try JSONDecoder().decode(MealResponse.self, from: data)
                if let detailedMeal = detailResponse.meals.first {
                    DispatchQueue.main.async {
                        // Add the recipe to the list if it matches the selected cuisine
                        if detailedMeal.strArea?.lowercased() == self.selectedCuisine.lowercased() {
                            self.filteredRecipes.append(detailedMeal)
                        }
                    }
                }
            } catch {
                print("Error decoding the recipe details: \(error)")
            }
        }.resume()
    }
}

/**
 The `Recipe` model represents a recipe fetched from TheMealDB API.
 
 It contains basic information such as the meal name, ID, thumbnail URL, and optional region information.
 */


struct Recipe: Codable, Identifiable {
    /// The unique ID of the meal.
    let idMeal: String
    
    /// The name of the meal.
    let strMeal: String
    
    /// The URL of the meal's thumbnail image.
    let strMealThumb: String
    
    /// The region or cuisine the meal belongs to. This property is optional as not all recipes may have region information.
    var strArea: String?
    
    var strInstructions: String?

    /// The computed ID, required to conform to the `Identifiable` protocol.
    var id: String { idMeal }
}


/**
 The `MealResponse` model represents the response from TheMealDB API for a list of meals.
 
 It contains a list of `Recipe` objects retrieved from the TheMealDB API.
 */


struct MealResponse: Codable {
    
    /// An array of `Recipe` objects fetched from the API.
    let meals: [Recipe]
}

struct FilteredRecipesView_Previews: PreviewProvider {
    static var previews: some View {
        FilteredRecipesView(selectedCategory: "Chicken", selectedCuisine: "Japanese")
    }
}

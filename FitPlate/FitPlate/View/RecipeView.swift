import SwiftUI


/**
 The `RecipeView` allows users to select a diet type and cuisine type, and generate filtered recipes based on their selection from an external TheMealDB API.
 
 */

struct RecipeView: View {
    
    /// Represents the response from the categories API, containing a list of `Category` objects.
    struct CategoriesResponse: Codable {
        let categories: [Category]
    }

    /// Represents a single category in the `CategoriesResponse`.
    struct Category: Codable {
        let strCategory: String
    }

    /// Represents the response from the cuisines API, containing a list of `Cuisine` objects.
    struct CuisinesResponse: Codable {
        let meals: [Cuisine]
    }

    /// Represents a single cuisine in the `CuisinesResponse`.
    struct Cuisine: Codable {
        let strArea: String
    }

    /// Holds the available diet types fetched from the API, with "Any" as the default value.
    @State private var categoryTypes: [String] = ["Any"]
    
    /// Holds the available cuisine types fetched from the API, with "Any" as the default value.
    @State private var cuisineTypes: [String] = ["Any"]
    
    /// Holds the user's selected diet type from the dropdown.
    @State private var selectedDietType = "Select"
    
    /// Holds the user's selected cuisine type from the dropdown.
    @State private var selectedCuisineType = "Select"
    
    /// A boolean that triggers navigation to the `FilteredRecipesView` when set to true.
    @State private var navigateToFiltered = false

    // MARK: - Body View

    var body: some View {
        VStack {
            /// Displays the "Recipes" title at the top of the view.
            Text("Recipes")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.404, green: 0.773, blue: 0.702))  // green color
                .padding()

            // Dropdown menus for selecting diet and cuisine types
            VStack(alignment: .leading, spacing: 16) {
                /// Creates a dropdown menu for selecting the diet type.
                menuDropdown(title: "Diet Type", items: categoryTypes, selectedItem: $selectedDietType)
                
                /// Creates a dropdown menu for selecting the cuisine type.
                menuDropdown(title: "Cuisine Type", items: cuisineTypes, selectedItem: $selectedCuisineType)
            }
            .padding()

            // Generate button to navigate to filtered recipes
            Button("Generate") {
                navigateToFiltered = true  // Trigger navigation when the button is pressed
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal, 40)
            .navigationDestination(isPresented: $navigateToFiltered, destination: {
                /// Navigates to `FilteredRecipesView` with selected diet and cuisine types.
                FilteredRecipesView(selectedCategory: selectedDietType, selectedCuisine: selectedCuisineType)
            })
            
            Spacer()
        }
        .onAppear {
            /// Fetches available diet types when the view appears.
            fetchCategoryTypes()
            
            /// Fetches available cuisine types when the view appears.
            fetchCuisineTypes()
        }
    }

    /**
     Fetches the available diet categories from a remote API and updates the `categoryTypes` array.
     
     If the fetch is successful, the diet categories will be appended to the existing array, starting with "Any". The API used is from TheMealDB.
     */
    
    
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

    /**
     Fetches the available cuisine types from a remote API and updates the `cuisineTypes` array.
     
     If the fetch is successful, the cuisine types will be appended to the existing array, starting with "Any". The API used is from TheMealDB.
     */
    
    
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
    
    
    /**
     A reusable view component for creating dropdown menus.
     
     - Parameters:
       - title: The title of the dropdown
       - items: The list of items to populate the dropdown.
       - selectedItem: The currently selected item that is bound to the dropdown.
     */
    
    
    @ViewBuilder
    private func menuDropdown(title: String, items: [String], selectedItem: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(title).font(.headline)
            Menu {
                ForEach(items, id: \.self) { item in
                    Button(item) {
                        selectedItem.wrappedValue = item  // Update the selected item
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

/**
 A custom button style that provides a consistent look for buttons in the app.
 
 The button uses a green background with white text and scales down slightly when pressed.
 */


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

# Project Structure

This README outlines the structure of the Swift files within the project directories.

## Noms

### Model
The `Model` directory contains the data models used throughout the Noms app.

- `Client.swift`: Defines the client-side interactions.
- `Colors.swift`: Contains the color definitions for the UI.
- `Meal.swift`: Represents a meal entity.
- `MealCategory.swift`: Defines the categories of meals.
- `PreviewResources`: Includes mock data for previews.

### View
The `View` directory contains the UI components and screens of the Noms app.

#### Navigation
The `Navigation` directory contains components and screens related to the navigation within the app.

- `Components/NavigationHeader.swift`: The header component used in navigation.
- `Screens/Categories.swift`: The screen displaying the meal categories.
- `Screens/MealDetail.swift`: The screen showing the meal details.
- `Screens/Meals.swift`: The screen that lists meals.

- `SearchView.swift`: A view component for searching within the app.

### ViewModel
The `ViewModel` directory includes the view models which contain the logic for processing data for the views.

- `BaseViewModel.swift`: The base class for other view models.
- `NavigationViewModel.swift`: Manages the navigation state.
- `SearchViewModel.swift`: Handles the logic for the search functionality.

## Utilities

- `utils.swift`: Contains utility functions used across the Noms app.

## Testing

- `NomsTests.swift`: Contains unit tests for the Noms app.
- `NomsUITests.swift`: Includes UI tests for the Noms app.
- `NomsUITestsLaunchTests.swift`: Contains the launch tests for UI testing.

Please refer to the respective directories for detailed documentation on each component.


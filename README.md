# Project Structure
iOS 17+ because my phone is on 17.

## Noms

### Model
Defines a client and model objects for the client to collect from the recieved JSON as well as resources that are used throughout the codebase.

- `Client.swift`: Defines functions to asyncronously request data from themealdb endpoints
- `Colors.swift`: Contains the color definitions for the UI.
- `Meal.swift`: Represents a meal entity as well as the partial meal information provided before a full meal is loaded.
- `MealCategory.swift`: Defines the categories of meals.
- `PreviewResources`: Includes mock data for previews and a script to load them.

### View
The `View` directory contains the UI components and screens of the Noms app. Views support dynamic-type, light/dark color-scheme and basic VoiceOver.

#### Navigation
The `Navigation` directory contains components and screens related to the navigation within the app.

- `Components/NavigationHeader.swift`: The header component used in navigation.
- `Screens/Categories.swift`: The screen displaying the meal categories.
- `Screens/MealDetail.swift`: The screen showing the meal details.
- `Screens/Meals.swift`: The screen that lists meals.
- `SearchView.swift`: A view component for searching meals by keyword.

### ViewModel
The `ViewModel` directory includes the view models which contain the logic for processing data for the views.

- `BaseViewModel.swift`: The base class for other view models. This is where helper functions for both error handling and configuring the behavior of @Published variables of child views are.
- `NavigationViewModel.swift`: Manages the navigation state.
- `SearchViewModel.swift`: Handles the logic for the search functionality.

## Utilities

- `utils.swift`: Contains the fontSize function which both supports dynamic type and doesn't allow text to become impossibly small or view-breakingly large.

## Testing

- `NomsTests.swift`: This isn't a unit test as much as it is a location where I tested the client until I got the qualitative results I was looking for. It would certainly be better to unittest the client, but I didn't have time to do the level of mocking it would require to truly unittest my client.

# Code Review (Top 5):
- TODO: VoiceOver works but Speak Screen is broken. Focus Managment is nonexistant in this view heierarchy. It probably has to do with it first recognizing the header and not knowing where to go from there. 
- TODO: The client is too messy and not great for teams. Move `AsyncClient.fetchData` and `.fetchImage` to `BaseAsyncClient` which is a `public static singleton`. Define `SearchClient` and `NavigationClient` child classes. They can be owned by their respective view models since `BaseAsyncClient` is a singleton.
- TODO: `@Published` Dictionaries *cringe*! Move these to repository classes. Probably same inheritance structure as `*AsyncClient` and `*ViewModel`. There's probably something clever we could do with Combine + getter/setter logic in these repos to expose this data and not redraw the entire view every time a dictionary changes. This will probably require medium to medium-well swiftUI refactoring.
- TODO: Only load data when resources are not available or override is supplied to load functions. I started to do this in `SearchViewModel` but I got distracted and now it is time to turn it in lol
- TODO: Better indication that a load is occuring. There should be some View in `View/Navigation/Components` that takes a `@ViewBuilder` and `@Binding` and shows a `ProgressView` if the binding is true and the view if the binding is false.


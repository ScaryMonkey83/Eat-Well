//
//  SearchViewModel.swift
//  Noms
//
//  Created by Jacob Lehn Detwiler on 11/3/23.
//

import Foundation

class SearchViewModel: BaseViewModel {
    @Published var meals: [Meal]?
    @Published var mealImages = NSMutableDictionary()
    
    func search(_ query: String, callback: ((MealsResponse?) -> Void)? = nil) {
        self.client.fetchMealsByName(query) { [weak self] result in
            guard let mealsResponse = self?.handleResponse(result: result) else {
                DispatchQueue.main.async {
                    callback?(nil)
                }
                return
            }
            DispatchQueue.main.async {
                self?.meals = mealsResponse.meals
                callback?(mealsResponse)
            }
            for meal in mealsResponse.meals {
                if self?.mealImages.object(forKey: meal.idMeal) == nil {
                    self?.client.fetchImage(from: meal.strMealThumb) { [weak self] result in
                        guard let imageResponse = self?.handleResponse(result: result) else { return }
                        DispatchQueue.main.async {
                            self?.mealImages[meal.idMeal] = imageResponse
                        }
                    }
                }
            }
        }
    }
}

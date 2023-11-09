//
//  NavigationViewModel.swift
//  Noms
//
//  Created by Jacob Lehn Detwiler on 11/3/23.
//

import Foundation
import SwiftUI

// TODO: only load when resources are not available or override is supplied to load functions
// TODO: Rather than
class NavigationViewModel : BaseViewModel {
    @Published var categories: [MealCategory]?
    
    @Published var partialMeals: [MealCategory:[PartialMeal]] = [:]
    @Published var meals: [PartialMeal:Meal] = [:] // PartialMeal : Meal
    @Published var categoryImages: [MealCategory:UIImage] = [:]  // Category : UIImage
    @Published var mealImages: [String:UIImage] = [:]  // (Meal|PartialMeal).idMeal : UIImage
    
    override init() {
        super.init()
        self.configureCollectionBindings($categories, debounceRate: 800)
        self.configureCollectionBindings($partialMeals, debounceRate: 800)
        self.configureCollectionBindings($meals, debounceRate: 800)
        self.configureCollectionBindings($categoryImages, debounceRate: 800)
        self.configureCollectionBindings($mealImages, debounceRate: 800)
    }
    
    func loadCategories(callback: ((CategoryResponse) -> Void)? = nil) {
        // get the categories to start.
        self.client.fetchCategories() { [weak self] result in
            guard let categoriesResponse = self?.handleResponse(result: result) else { return }
            DispatchQueue.main.async {
                self?.categories = categoriesResponse.categories
                callback?(categoriesResponse)
            }
            
            // if fetch categories was successful lets get the images next.
            for category in categoriesResponse.categories {
                self?.client.fetchImage(from: category.thumbnailURL) { [weak self] result in
                    guard let imageResponse = self?.handleResponse(result: result) else { return }
                    DispatchQueue.main.async {
                        self?.categoryImages[category] = imageResponse
                    }
                }
            }
        }
    }
    
    func loadMealPreviews(for mealCategory: MealCategory, 
                          callback: ((PartialMealsResponse) -> Void)? = nil) {
        // get the PartialMeals
        self.client.fetchPartialMealsByCategory(mealCategory) { [weak self] result in
            guard let partialMealResponse = self?.handleResponse(result: result) else { return }
            DispatchQueue.main.async {
                // This'll get the deserts category covered indirectly ;)
                self?.partialMeals[mealCategory] = partialMealResponse.partialMeals.sorted { $0.strMeal.lowercased() < $1.strMeal.lowercased() }
                callback?(partialMealResponse)
            }
            
            // if fetch partial meals was successful lets get the images next.
            for partialMeal in partialMealResponse.partialMeals {
                self?.client.fetchImage(from: partialMeal.strMealThumb) { [weak self] result in
                    guard let imageResponse = self?.handleResponse(result: result) else { return }
                    DispatchQueue.main.async {
                        self?.mealImages[partialMeal.idMeal] = imageResponse
                    }
                }
            }
        }
    }
    
    func loadMeal(for partialMeal: PartialMeal,
                  callback: ((Meal) -> Void)? = nil) {
        // get the Meal
        self.client.fetchMeal(partialMeal) { [weak self] result in
            guard let meal = self?.handleResponse(result: result) else { return }
            DispatchQueue.main.async {
                self?.meals[partialMeal] = meal
                callback?(meal)
            }
            if self?.mealImages[partialMeal.idMeal] != nil { return }  // return early if we have the image already
            self?.client.fetchImage(from: partialMeal.strMealThumb) { [weak self] result in
                guard let imageResponse = self?.handleResponse(result: result) else { return }
                DispatchQueue.main.async {
                    self?.mealImages[partialMeal.idMeal] = imageResponse
                }
            }
        }
    }
}

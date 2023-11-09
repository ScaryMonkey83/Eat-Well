//
//  LoadResource.swift
//  Noms
//
//  Created by Jacob Lehn Detwiler on 11/5/23.
//

import Foundation

var categories: CategoryResponse = load("categories.json")
var partialMeals: PartialMealsResponse = load("partial_meals.json")
var meal_r: MealsResponse = load("partial_meals.json")
var meal: Meal? {
    return meal_r.meals.first
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}


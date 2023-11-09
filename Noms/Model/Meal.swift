//
//  Meal.swift
//  Noms
//
//  Created by Jacob Lehn Detwiler on 11/2/23.
//

import Foundation


struct MealsResponse: Decodable {
    let meals: [Meal]
}

struct PartialMealsResponse: Decodable {
    let partialMeals: [PartialMeal]
    
    enum CodingKeys: String, CodingKey {
        case partialMeals = "meals"
    }
}

struct PartialMeal: Decodable, Identifiable, Hashable {
    var id: String {
        return idMeal
    }
    
    let strMeal: String
    let strMealThumb: URL
    let idMeal: String
}

struct Ingredient: Decodable, Identifiable {
    var id: String {
        return name
    }
    
    let name: String
    let measure: String
}

struct Meal: Decodable, Identifiable, Equatable {
    static func == (lhs: Meal, rhs: Meal) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: String {
        return idMeal
    }
    
    let idMeal: String
    let strMeal: String
    let strDrinkAlternate: String?
    let strCategory: String
    let strArea: String
    let strInstructions: String
    let strMealThumb: URL
    let strTags: String?
    let strYoutube: URL?
    let ingredients: [Ingredient]
    let strSource: URL?
    let strImageSource: URL?
    let strCreativeCommonsConfirmed: String?
    let dateModified: Date?
    
    var partialMeal: PartialMeal {
        return PartialMeal(strMeal: self.strMeal, strMealThumb: self.strMealThumb, idMeal: self.idMeal)
    }
    
    private enum CodingKeys: String, CodingKey {
        case idMeal, strMeal, strDrinkAlternate, strCategory, strArea, strInstructions, strMealThumb, strTags, strYoutube, strSource, strImageSource, strCreativeCommonsConfirmed, dateModified
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5, strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10, strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15, strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20
        case strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5, strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10, strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15, strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20
    }
    
    init(from decoder: Decoder) throws {
        // TODO: do catch
        let container = try decoder.container(keyedBy: CodingKeys.self)
        idMeal = try container.decode(String.self, forKey: .idMeal)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        strDrinkAlternate = try? container.decodeIfPresent(String.self, forKey: .strDrinkAlternate)
        strCategory = try container.decode(String.self, forKey: .strCategory)
        strArea = try container.decode(String.self, forKey: .strArea)
        strInstructions = try container.decode(String.self, forKey: .strInstructions)
        strMealThumb = try container.decode(URL.self, forKey: .strMealThumb)
        strTags = try? container.decodeIfPresent(String.self, forKey: .strTags)
        strYoutube = try? container.decodeIfPresent(URL.self, forKey: .strYoutube)
        strSource = try? container.decodeIfPresent(URL.self, forKey: .strSource)
        strImageSource = try? container.decodeIfPresent(URL.self, forKey: .strImageSource)
        strCreativeCommonsConfirmed = try? container.decodeIfPresent(String.self, forKey: .strCreativeCommonsConfirmed)
        dateModified = try? container.decodeIfPresent(Date.self, forKey: .dateModified)
        
        var ingredients = [Ingredient]()
        for i in 1...20 {
            // fun little trick
            let ingredientKeyRaw = "strIngredient\(i)"
            let measureKeyRaw = "strMeasure\(i)"
            
            if let ingredientKey = CodingKeys(rawValue: ingredientKeyRaw),
               let measureKey = CodingKeys(rawValue: measureKeyRaw),
               let ingredientName = try container.decodeIfPresent(String.self, forKey: ingredientKey), !ingredientName.isEmpty,
               let measure = try container.decodeIfPresent(String.self, forKey: measureKey), !measure.isEmpty {
                
                let ingredient = Ingredient(name: ingredientName, measure: measure)
                ingredients.append(ingredient)
            }
        }
        self.ingredients = ingredients
    }
}

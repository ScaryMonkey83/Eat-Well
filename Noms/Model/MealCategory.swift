//
//  Category.swift
//  Noms
//
//  Created by Jacob Lehn Detwiler on 11/2/23.
//

import Foundation


struct CategoryResponse: Decodable {
    let categories: [MealCategory]
}

struct MealCategory: Decodable, Identifiable, Hashable {
    let id: String
    let name: String
    let thumbnailURL: URL
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idCategory"
        case name = "strCategory"
        case thumbnailURL = "strCategoryThumb"
        case description = "strCategoryDescription"
    }
}

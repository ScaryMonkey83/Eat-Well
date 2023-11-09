//
//  Client.swift
//  Noms
//
//  Created by Jacob Lehn Detwiler on 11/1/23.
//

import Foundation
import SwiftUI


protocol FreeMealAPIClient {
    // thumbnail is too small to look good. all images are full res. easy enough to change later for perf if a concern.
    func fetchCategories(dataCallback: @escaping (Result<CategoryResponse,Error>) -> Void)
    func fetchPartialMealsByCategory(_ category: MealCategory, dataCallback: @escaping (Result<PartialMealsResponse,Error>) -> Void)
    func fetchMealsByName(_ search: String, dataCallback: @escaping (Result<MealsResponse,Error>) -> Void)
    func fetchMeal(_ partialMeal: PartialMeal, dataCallback: @escaping (Result<Meal,Error>) -> Void)
    func fetchImage(from endpoint: URL, completion: @escaping (Result<UIImage, Error>) -> Void)
}


// TODO: If time turn AsyncClient into BaseAsyncClient
class AsyncClient : FreeMealAPIClient {
    private init() { }
    
    /**
     Lets save developers from themselves by making this object a singleton. We don't want a million of these floating around in production.
     */
    private static var singleton: AsyncClient? // TODO: make weak with ownership falling to VMs. Unsure if trivial.
    public static func get() -> AsyncClient {
        if let existingInstance = singleton {
            return existingInstance
        } else {
            let newInstance = AsyncClient()
            singleton = newInstance
            return newInstance
        }
    }

    func fetchCategories(dataCallback: @escaping (Result<CategoryResponse, Error>) -> Void) {
        let categoriesURL = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php")
        // using ! is alright here because if it crashes that means the hard-coded url is bad and that can be fixed in dev.
        self.fetchData(from: categoriesURL!, completion: { (result: Result<CategoryResponse, Error>) in
            // might need to come back later and put this (and others like it) in a the main dispatch queue.
            dataCallback(result)
        })
    }
    
    func fetchPartialMealsByCategory(_ category: MealCategory, dataCallback: @escaping (Result<PartialMealsResponse, Error>) -> Void) {
        var partialMealsURL = URLComponents(string: "https://www.themealdb.com/api/json/v1/1/filter.php")
        let queryItems = [URLQueryItem(name: "c", value: category.name)]
        partialMealsURL?.queryItems = queryItems
        guard let url = partialMealsURL?.url else {
            dataCallback(.failure(URLError(.badURL)))
            return
        }
        
        self.fetchData(from: url, completion: { (result: Result<PartialMealsResponse, Error>) in
            dataCallback(result)
        })
    }
    
    func fetchMealsByName(_ search: String, dataCallback: @escaping (Result<MealsResponse, Error>) -> Void) {
        var searchURL = URLComponents(string: "https://www.themealdb.com/api/json/v1/1/search.php")
        let queryItems = [URLQueryItem(name: "s", value: search)]
        searchURL?.queryItems = queryItems
        guard let url = searchURL?.url else {
            dataCallback(.failure(URLError(.badURL)))
            return
        }
        
        self.fetchData(from: url, completion: { (result: Result<MealsResponse, Error>) in
            dataCallback(result)
        })
    }
    
    func fetchMeal(_ partialMeal: PartialMeal, dataCallback: @escaping (Result<Meal, Error>) -> Void) {
        var singleMealURL = URLComponents(string: "https://www.themealdb.com/api/json/v1/1/lookup.php")
        let queryItems = [URLQueryItem(name: "i", value: partialMeal.idMeal)]
        singleMealURL?.queryItems = queryItems
        guard let url = singleMealURL?.url else {
            dataCallback(.failure(URLError(.badURL)))
            return
        }
        
        self.fetchData(from: url, completion: { (result: Result<MealsResponse, Error>) in
            switch (result) {
            case .success(let data):
                guard let meal = data.meals.first else {
                    dataCallback(.failure(URLError(.badServerResponse)))
                    return
                }
                dataCallback(.success(meal))
            case .failure(let err):
                dataCallback(.failure(err))
            }
        })
    }
    
    func fetchImage(from endpoint: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        URLSession.shared.dataTask(with: endpoint) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -2, userInfo: nil)))
                return
            }
            
            if let image = UIImage(data: data) {
                    completion(.success(image))
            } else {
                    completion(.failure(NSError(domain: "Invalid image data", code: -3, userInfo: nil)))
            }
        }.resume()
    }

    private func fetchData<T: Decodable>(from endpoint: URL, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: endpoint) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -2, userInfo: nil)))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                print("error for endpoint: \(endpoint.absoluteString)")
                print(String(describing: error))
                completion(.failure(error))
            }
        }.resume()
    }
}



//
//  NomsTests.swift
//  NomsTests
//
//  Created by Jacob Lehn Detwiler on 11/1/23.
//

import XCTest
@testable import Noms

final class NomsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        AsyncClient.get().fetchCategories() { result in
            switch (result) {
            case .success(let data):
                print("+ Category: " + (data.categories.first?.name ?? "no"))
                guard let cat = data.categories.first else {
                    return
                }
                AsyncClient.get().fetchPartialMealsByCategory(cat) { result in
                    switch (result) {
                    case .success(let data):
                        print("+ PartialMeal: " + (data.partialMeals.first?.strMeal ?? "no"))
                        guard let part = data.partialMeals.first else {
                            return
                        }
                        AsyncClient.get().fetchMeal(part) { result in
                            switch (result) {
                            case .success(let data):
                                print("+ Meal Instructions: " + data.strInstructions)
                            case .failure(let err):
                                print("+ Meal data issue: " + String(describing: err))
                            }
                        }
                    case .failure(let err):
                        print("+ PartialMeal data issue: " + String(describing: err))
                    }
                }
            case .failure(let err):
                print("+ Category data issue: " + String(describing: err))
            }
        }
        AsyncClient.get().fetchMealsByName("Ar") { result in
            switch(result) {
            case .success(let data):
                print("+ Search: " + (data.meals.first?.strMeal ?? "no"))
            case .failure(let err):
                print("+ Search data issue: " + String(describing: err))
            }
        }
        AsyncClient.get().fetchImage(from: URL(string: "https://www.themealdb.com/images/media/meals/yrstur1511816601.jpg")!) { result in
            switch(result) {
            case .success(let image):
                print("+ Image dimens: " + image.size.debugDescription)
            case .failure(let err):
                print("+ Image data issue: " + String(describing: err))
            }
        }
        sleep(20)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            
        }
    }

}

//
//  MealDetail.swift
//  Noms
//
//  Created by Jacob Lehn Detwiler on 11/1/23.
//

import SwiftUI
import Foundation

fileprivate let titleScale = 0.08
fileprivate let contentScale = 0.05

fileprivate struct IngredientDetail: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.dynamicTypeSize) var dynSize
    
    var meal: Meal?
    let fullGeo: GeometryProxy
    
    var body: some View {
        if let ingredients = meal?.ingredients {
            VStack {
                Text("Ingredients: ")
                    .foregroundStyle(colorScheme.blkOrWhtInverse)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: fontSize(dynSize) * fullGeo.size.height * titleScale, weight: .semibold, design: .serif))
                    .shadow(color: colorScheme.blkOrWht, radius: 1, x: 1)
                    .shadow(color: colorScheme.blkOrWhtInverse, radius: 0.5, x: 1)
                    .shadow(color: colorScheme.blkOrWhtInverse, radius: 0.5)
                    .shadow(color: colorScheme.blkOrWhtInverse, radius: 0.5)

                VStack {
                    ForEach(ingredients) { ingredient in
                        Text("- \(ingredient.name), \(ingredient.measure)")
                            .foregroundStyle(colorScheme.blkOrWhtInverse)
                            .font(.system(size: fontSize(dynSize) * fullGeo.size.height * contentScale, weight: .medium, design: .default))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }.padding([.leading, .trailing])
            }
            .padding([.top, .bottom, .leading, .trailing])
            .frame(width: fullGeo.size.width * 0.9)
        } else {
            Text("There was a problem.")
                .foregroundStyle(colorScheme.blkOrWhtInverse)
        }
    }
}

fileprivate struct InstructionsDetail: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.dynamicTypeSize) var dynSize
    
    var meal: Meal?
    let fullGeo: GeometryProxy
    
    var body: some View {
        if let instructions = meal?.strInstructions {
            VStack {
                Text("Directions: ")
                    .foregroundStyle(colorScheme.blkOrWhtInverse)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: fontSize(dynSize) * fullGeo.size.height * titleScale, weight: .semibold, design: .serif))
                    .shadow(color: colorScheme.blkOrWht, radius: 1, x: 1)
                    .shadow(color: colorScheme.blkOrWhtInverse, radius: 0.5, x: 1)
                    .shadow(color: colorScheme.blkOrWhtInverse, radius: 0.5)
                    .shadow(color: colorScheme.blkOrWhtInverse, radius: 0.5)

                Text(instructions)
                    .padding([.bottom, .leading, .trailing])
                    .foregroundStyle(colorScheme.blkOrWhtInverse)
                    .font(.system(size: fontSize(dynSize) * fullGeo.size.height * contentScale, weight: .medium, design: .default))
            }
            .padding([.top, .bottom, .leading, .trailing])
            .frame(width: fullGeo.size.width * 0.9)
        } else {
            Text("There was a problem.")
                .foregroundStyle(colorScheme.blkOrWht)
        }
    }
}

struct MealDetail: View {
    let partialMeal: PartialMeal
    let shouldHaveSearch: Bool
    
    @EnvironmentObject private var navigationViewModel: NavigationViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.colorSchemeContrast) private var contrast
    
    @State private var title = ""
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                if let image = navigationViewModel.mealImages[partialMeal.idMeal] {
                    Image(uiImage: image)
                        .resizable()
                        .ignoresSafeArea(.all)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                }
                if let meal = navigationViewModel.meals[partialMeal] {
                    ScrollView(showsIndicators: false) {
                        VStack {
                            Rectangle()
                                .frame(height: geo.size.height / 2)
                                .opacity(0)
                            ZStack {
                                Rectangle()
                                    .fill(colorScheme.blkOrWht)
                                    .frame(width: geo.size.width * 0.9)
                                    .opacity(contrast == .standard ? 0.75 : 0.9)
                                    .scaledToFill()
                                Rectangle()
                                    .fill(.clear)
                                    .border(colorScheme.blkOrWhtInverse, width: 2)
                                    .frame(width: geo.size.width * 0.9)
                                    .scaledToFill()
                                VStack {
                                    IngredientDetail(meal: meal, fullGeo: geo)
                                    Spacer()
                                    InstructionsDetail(meal: meal, fullGeo: geo)
                                }
                                
                            }
                        }
                    }
                }
                NavigationHeader(
                    shouldHaveBack: true,
                    shouldHaveSearch: shouldHaveSearch,
                    title: $title
                )
            }.onAppear() {
                navigationViewModel.loadMeal(for: partialMeal)
                if let meal = navigationViewModel.meals[partialMeal] {
                    self.title = meal.strMeal
                } else {
                    navigationViewModel.loadMeal(for: partialMeal) { meal in
                        self.title = meal.strMeal
                    }
                }
            }
        }
    }
}

struct MealDetailPreviewWrapper: View {
    var partialMeal: PartialMeal? {
        return partialMeals.partialMeals.first
    }
    
    var body: some View {
        if let p = partialMeal {
            MealDetail(partialMeal: p, shouldHaveSearch: true).environmentObject(NavigationViewModel())
        } else {
            Text("there was a problem")
        }
    }
}

#Preview {
    MealDetailPreviewWrapper()
}

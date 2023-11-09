//
//  Meals.swift
//  Noms
//
//  Created by Jacob Lehn Detwiler on 11/1/23.
//

import SwiftUI


struct MealRow: View {
    @EnvironmentObject private var navigationViewModel: NavigationViewModel
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynType
    
    @State private var image = UIImage()
    let partialMeal: PartialMeal
    
    var body: some View {
                
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                Text(partialMeal.strMeal)
                    .foregroundStyle(colorScheme.blkOrWhtInverse)
                    .font(.system(size: fontSize(dynType) * 50, weight: .semibold,design: .rounded))
                    .multilineTextAlignment(.leading)
                    .padding([.top, .bottom])
                Spacer()
            }
            Divider()
                .frame(minHeight: 2)
                .background(colorScheme.blkOrWhtInverse)
        }
        .padding([.leading, .trailing])
        .background(alignment: .center) {
            GeometryReader { geo in
                if let image = navigationViewModel.mealImages[partialMeal.idMeal] {
                    Image(uiImage: image)
                        .resizable() // Make the image resizable
                        .aspectRatio(contentMode: .fill) // Fill the available space
                        .ignoresSafeArea(.all)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                }
                Rectangle()
                    .fill(LinearGradient(colors: [colorScheme.blkOrWht,colorScheme.blkOrWht.opacity(0.9), .clear], startPoint: .leading, endPoint: .trailing))
            }
        }
    }
}

struct MealsList: View {
    @EnvironmentObject private var navigationViewModel: NavigationViewModel
    @Environment(\.colorScheme) private var colorScheme
    @State private var title = ""
    
    let category: MealCategory
    
    var body: some View {
        GeometryReader { geo in
            NavigationStack {
                ZStack {
                    if let partialMeals = navigationViewModel.partialMeals[category] {
                        // had to use scroll view cuz List wouldn't let me embed a rectangle at the top.
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                Rectangle()
                                    .fill(colorScheme.blkOrWht)
                                    .frame(width: geo.size.width, height: geo.size.height * 0.13)
                                ForEach(partialMeals) { partialMeal in
                                    NavigationLink {
                                        MealDetail(partialMeal: partialMeal, shouldHaveSearch: true)
                                            .navigationBarBackButtonHidden(true)
                                    } label: {
                                        MealRow(partialMeal: partialMeal)
                                    }
                                }
                            }
                        }
                    } else {
                        // categories are not ready yet. Do something to indicate this.
                    }
                    NavigationHeader(
                        shouldHaveBack: true,
                        shouldHaveSearch: true,
                        title: $title
                    )
                }
            }
            .onAppear() {
                self.title = category.name
                navigationViewModel.loadMealPreviews(for: category)
            }
        }
    }
}


struct MealListPreviewWrapper: View {
    
    
    var category: MealCategory? {
        return categories.categories.first
    }
    
    var body: some View {
        if let c = category {
            MealsList(category: c).environmentObject(NavigationViewModel())
        } else {
            Text("there was a problem")
        }
    }
}

#Preview {
    MealListPreviewWrapper()
}

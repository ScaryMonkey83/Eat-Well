//
//  Categories.swift
//  Noms
//
//  Created by Jacob Lehn Detwiler on 11/1/23.
//

import SwiftUI

import SwiftUI

// There is a lot of repeated code from Meals here but when I tried to break it out the
// parameters were out of control. Made it totally unreadable.
struct CategoryRow: View {
    @EnvironmentObject private var navigationViewModel: NavigationViewModel
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynType
    
    @State private var image = UIImage()
    let category: MealCategory
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                Spacer()
                Text(category.name)
                    .foregroundStyle(colorScheme.blkOrWhtInverse)
                    .font(.system(size: fontSize(dynType) * 50, weight: .semibold,design: .rounded))
                    .padding([.top, .bottom])
                    .accessibilityLabel(category.name)
                Spacer()
            }
            Divider()
                .frame(minHeight: 2)
                .background(colorScheme.blkOrWhtInverse)
        }
        .padding([.leading, .trailing])
        .background(alignment: .center) {
            GeometryReader { geo in
                if let image = navigationViewModel.categoryImages[category] as? UIImage {
                    Image(uiImage: image)
                        .resizable() // Make the image resizable
                        .aspectRatio(contentMode: .fill) // Fill the available space
                        .ignoresSafeArea(.all)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                }
                Rectangle()
                    .fill(LinearGradient(colors: [.clear, colorScheme.blkOrWht, .clear], startPoint: .leading, endPoint: .trailing))
            }
        }
    }
}

struct CategoryList: View {
    @EnvironmentObject private var navigationViewModel: NavigationViewModel
    @Environment(\.colorScheme) private var colorScheme
    @State private var title = "Categories"
    
    var body: some View {
        GeometryReader { geo in
            NavigationStack {
                ZStack {
                    if let categories = navigationViewModel.categories {
                        // had to use scroll view cuz List wouldn't let me embed a rectangle at the top.
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                Rectangle()
                                    .fill(colorScheme.blkOrWht)
                                    .frame(width: geo.size.width, height: geo.size.height * 0.13)
                                ForEach(categories) { category in
                                    NavigationLink {
                                        MealsList(category: category)
                                            .navigationBarBackButtonHidden(true)
                                    } label: {
                                        CategoryRow(category: category)
                                    }
                                }
                            }
                        }
                    } else {
                        // categories are not ready yet. Do something to indicate this.
                    }
                    NavigationHeader(
                        shouldHaveBack: false,
                        shouldHaveSearch: true,
                        title: $title
                    )
                }
            }
            .onAppear() {
                navigationViewModel.loadCategories()
            }
        }
    }
}


struct CategoryListPreviewWrapper: View {
    var body: some View {
            CategoryList().environmentObject(NavigationViewModel())
    }
}

#Preview {
    CategoryListPreviewWrapper()
}

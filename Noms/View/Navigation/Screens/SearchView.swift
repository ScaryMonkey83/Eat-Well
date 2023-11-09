//
//  SearchView.swift
//  Noms
//
//  Created by Jacob Lehn Detwiler on 11/1/23.
//

import SwiftUI
import Combine

// Debouncer class to delay the execution of a function
final class Debouncer {
    var callback: (() -> Void)?
    var delay: Double
    var timer: Timer?

    init(timeInterval: Double) {
        self.delay = timeInterval
    }

    func debounce(callback: @escaping () -> Void) {
        self.callback = callback
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: delay, target: self,
                                     selector: #selector(fireNow), userInfo: nil, repeats: false)
    }

    @objc func fireNow() {
        self.callback?()
    }
}

struct BubbleSearchBar: View {
    @State private var searchText = ""
    @State private var isEditing = false
    @FocusState private var isFocused: Bool
    
    let textWasSubmitted: (String) -> Void
    
    let debouncer = Debouncer(timeInterval: 0.5)
    
    var body: some View {
        TextField("Search...", text: $searchText)
            .focused($isFocused)
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(200)
            .onChange(of: searchText) {
                debouncer.debounce {
                    textWasSubmitted(searchText)
                }
            }
    }
}

struct SearchRow: View {
    @EnvironmentObject private var searchViewModel: SearchViewModel
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
                if let image = searchViewModel.mealImages[partialMeal.idMeal] as? UIImage {
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


struct SearchListView: View{
    @EnvironmentObject private var searchViewModel: SearchViewModel
    @EnvironmentObject private var navigationViewModel: NavigationViewModel
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        if let meals = searchViewModel.meals {
            // had to use scroll view cuz List wouldn't let me embed a rectangle at the top.
            ScrollView {
                LazyVStack(spacing: 0) {
                    Rectangle()
                        .fill(colorScheme.blkOrWht)
                        .frame(height: 100)
                    ForEach(meals) { meal in
                        NavigationLink {
                            MealDetail(partialMeal: meal.partialMeal, shouldHaveSearch: false)
                                .navigationBarBackButtonHidden(true)
                                .environmentObject(navigationViewModel)
                        } label: {
                            SearchRow(partialMeal: meal.partialMeal)
                        }
                    }
                }
            }
        }
    }
}

struct SearchView: View {
    @Binding var isSearchPresented: Bool
    
    @EnvironmentObject private var searchViewModel: SearchViewModel
    @EnvironmentObject private var navigationViewModel: NavigationViewModel
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var isLoading = false
    @State private var showSearchList = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack(alignment: .top) {
                    if isLoading {
                        ProgressView()
                            .frame(alignment: .center)
                            .position(CGPoint(x: geo.size.width / 2, y: geo.size.height / 2))
                            
                    } else if showSearchList {
                        SearchListView()
                    }
                    HStack {
                        BubbleSearchBar { query in
                            if !query.isEmpty {
                                showSearchList = true
                                self.isLoading = true
                                searchViewModel.search(query) { resp in
                                    if resp == nil {
                                        showSearchList = false
                                    }
                                    self.isLoading = false
                                }
                            } else {
                                showSearchList = false
                            }
                        }
                        Button(){
                            isSearchPresented = false
                        } label: {
                            Image(systemName: "xmark")
                                .tint(colorScheme.blkOrWhtInverse)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct SearchViewPreviewWrapper: View {
    @State private var i = false
    var body: some View {
        SearchView(isSearchPresented: $i)
            .environmentObject(SearchViewModel())
            .environmentObject(NavigationViewModel())
    }
}

#Preview {
    SearchViewPreviewWrapper()
}

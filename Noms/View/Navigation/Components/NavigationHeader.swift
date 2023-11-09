//
//  NavigationHeader.swift
//  Noms
//
//  Created by Jacob Lehn Detwiler on 11/3/23.
//

import SwiftUI

struct NavigationHeader: View {
    let topPercentage = 0.08
    let shouldHaveBack: Bool
    let shouldHaveSearch: Bool
    @Binding var title: String
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.dynamicTypeSize) var dynSize
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var isSearchPresented = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(LinearGradient(colors: [.clear, colorScheme.blkOrWht, colorScheme.blkOrWht, colorScheme.blkOrWht], startPoint: .bottom, endPoint: .top))
                    .ignoresSafeArea(.all)
                    .frame(width: geometry.size.width)
                VStack(spacing: 0) {
                    HStack(alignment: .top, spacing: 0) {
                        if (shouldHaveBack) {
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: geometry.size.height * topPercentage * 0.6, weight: .bold))
                                    .tint(colorScheme.blkOrWhtInverse)
                            }
                            .frame(alignment: .leading)
                            .padding([.leading])
                            
                        }
                        
                        Text(title)
                            .foregroundStyle(colorScheme.blkOrWhtInverse)
                            .font(.system(size: fontSize(dynSize) * 1.5 * geometry.size.height * topPercentage * 0.35, weight: .heavy, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding([.leading, .trailing])
                            .accessibilityLabel(title)
                        if shouldHaveSearch {
                            Button(action: {
                                self.isSearchPresented = true
                            }) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: geometry.size.height * topPercentage * 0.6, weight: .bold))
                                    .tint(colorScheme.blkOrWhtInverse)
                            }
                            .frame(alignment: .trailing)
                            .padding([.trailing])
                            .fullScreenCover(isPresented: $isSearchPresented, content: {
                                SearchView(isSearchPresented: $isSearchPresented)
                                    .dynamicTypeSize(dynSize)
                            })
                        }
                    }
                    Rectangle()
                        .fill(.clear)
                        .frame(width: geometry.size.width, height: geometry.size.height * topPercentage)
                }.layoutPriority(1)
            }/*.frame(width: geometry.size.width, height: geometry.size.height * topPercentage * 2)*/
        }
    }
}

struct PreviewWrapper: View {
    @State private var title = "Title TitleTitle Title Title Title Title Title Title Title Title Title Title Title"
    private var shouldHaveBack = false
    private var shouldHaveSearch = true
    
    var body: some View {
        NavigationHeader(
            shouldHaveBack: shouldHaveBack,
            shouldHaveSearch: shouldHaveSearch,
            title: $title)
        .environmentObject(SearchViewModel())
        .environmentObject(NavigationViewModel())
    }
}

#Preview {
    PreviewWrapper()
}

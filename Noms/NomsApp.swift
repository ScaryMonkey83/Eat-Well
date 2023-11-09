//
//  NomsApp.swift
//  Noms
//
//  Created by Jacob Lehn Detwiler on 11/1/23.
//

import SwiftUI

@main
struct NomsApp: App {
    var navigationViewModel = NavigationViewModel()
    var searchViewModel = SearchViewModel()
    
    var body: some Scene {
        WindowGroup {
            CategoryList()
                .environmentObject(navigationViewModel)
                .environmentObject(searchViewModel)
        }
    }
}

//
//  BaseViewModel.swift
//  Noms
//
//  Created by Jacob Lehn Detwiler on 11/2/23.
//

import Foundation
import Combine
import SwiftUI

/**
 As developers start expanding functionality having boilerplate like this is a necessity.
 */
class BaseViewModel : ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var connected: Bool = true
    
    var client: AsyncClient {
        return AsyncClient.get()
    }
    
    /**
     Convenience function for handling generic responses. Overrides should call super.handleResponse.
     */
    public func handleResponse<T>(result: Result<T, Error>) -> T? {
        switch result {
        case .success(let res):
            DispatchQueue.main.async {
                self.connected = true
            }
            return res
        case .failure(let err):
            DispatchQueue.main.async {
                self.handleConnectionError(error: err)
            }
            return nil
        }
    }
    
    /**
     Should be able to call this on any response to detect problems with connectivity. All this really does is
     set the connected flag but more advanced error handling would go here.
     */
    private func handleConnectionError(error: Error) {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                print("No internet connection. Please check your connection and try again.")
                connected = false
            case .timedOut:
                print("Request timed out. Please try again.")
                connected = false
            default:
                print("A network error occurred. Please try again.")
            }
        } else {
            print(error.localizedDescription)
        }
    }
    
    public func configureCollectionBindings<T: Equatable>(_ binding: Published<T>.Publisher, debounceRate: Int = 300) {
        binding
            .debounce(for: .milliseconds(debounceRate), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { res in }
            .store(in: &cancellables)
    }
}

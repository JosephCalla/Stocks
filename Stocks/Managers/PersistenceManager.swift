//
//  PersistenceManager.swift
//  Stocks
//
//  Created by Joseph Estanislao Calla Moreyra on 3/10/22.
//

import Foundation

final class PersistenceManager {
    static let shared = PersistenceManager()
    
    private let userDefaults: UserDefaults = .standard
    
    private struct Constants {
        
    }
    
    private init () {}
    
    // MARK: - Public
    
    var watchlist: [String] {
        return []
    }
    
    public func addToWatchlist() {
        
    }
    
    public func removeFromWatchlist() {
        
    }
    
    // MARK: - Private
    
    private var hasOnboarded: Bool {
        return false
    }
}

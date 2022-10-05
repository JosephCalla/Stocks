//
//  PersistenceManager.swift
//  Stocks
//
//  Created by Joseph Estanislao Calla Moreyra on 3/10/22.
//

import Foundation

// ["APPL", "MSFT", "SNAP"]
// ['APPL', ]
final class PersistenceManager {
    static let shared = PersistenceManager()
    
    private let userDefaults: UserDefaults = .standard
    
    private struct Constants {
        static let onboardedKey = "hasOnboarded"
        static let watchListKey = "watchlist"
    }
    
    private init () {}
    
    // MARK: - Public
    
    var watchlist: [String] {
        if !hasOnboarded {
            userDefaults.set(true, forKey: "hasOnboarded")
            setupDefaults()
        }
        return userDefaults.stringArray(forKey: Constants.watchListKey) ?? []
    }
    
    public func addToWatchlist() {
        
    }
    
    public func removeFromWatchlist() {
        
    }
    
    // MARK: - Private
    private var hasOnboarded: Bool {
        return userDefaults.bool(forKey: "hasOnboarded")
    }
    
    private func setupDefaults() {
        let map: [String: String] = [
            "APPL": "Apple Inc",
            "MSFT": "Microsoft Corporation",
            "SNAP": "Snap Inc",
            "GOOG": "Alphabet",
            "WORK": "Slack Tecnologies",
            "FB": "Meta",
            "NVDA": "Nvidia Inch",
            "PINS": "Pinterest Inc"
        ]
        
        let symbols = map.keys.map { $0 }
        userDefaults.set(symbols, forKey: "watchlist")
        
        for (symbol, name) in map {
            userDefaults.set(name, forKey: symbol)
        }
    }
}

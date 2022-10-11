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
            userDefaults.set(true, forKey: Constants.onboardedKey)
            setupDefaults()
        }
        return userDefaults.stringArray(forKey: Constants.watchListKey) ?? []
    }
    
    public func watchlistContains(symbol: String) -> Bool {
        return watchlist.contains(symbol)
    }
    
    public func addToWatchlist(symbol: String, companyName: String) {
        var current = watchlist
        current.append(symbol)
        userDefaults.set(current, forKey: Constants.watchListKey)
        userDefaults.set(companyName, forKey: symbol)
        
        NotificationCenter.default.post(name: .didAddToWatchList, object: nil)
        
    }
    
    public func removeFromWatchlist(symbol: String) {
        var newList = [String]()
        
        print("Deleting: \(symbol)")
        
        userDefaults.set(nil, forKey: symbol)
        for item in watchlist where item != symbol {
            print("\n\(item)")
            newList.append(item)
        }
        
        userDefaults.set(newList, forKey: Constants.watchListKey)
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

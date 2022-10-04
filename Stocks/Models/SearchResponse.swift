//
//  SearchResponse.swift
//  Stocks
//
//  Created by Joseph Estanislao Calla Moreyra on 3/10/22.
//

import Foundation

struct SearchResponse: Codable {
    let count: Int
    let result: [SearchResult]
}

struct SearchResult: Codable {
    let description: String
    let displaySymbol: String
    let symbol: String
    let type: String
}

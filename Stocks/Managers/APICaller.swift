//
//  APICaller.swift
//  Stocks
//
//  Created by Joseph Estanislao Calla Moreyra on 3/10/22.
//

import Foundation

/// Object to manage api calls
final class APICaller {
    
    /// Singleton
    public static let shared = APICaller()
    
    /// Constants
    private struct Constants {
        static let apiKey = "cctmi5qad3i78dc6pl00cctmi5qad3i78dc6pl0g"
        static let sandboxApiKey = ""
        static let baseUrl = "https://finnhub.io/api/v1/"
        static let day: TimeInterval = 3600 * 24
    }
    
    /// Private constructor
    private init() {}
    
    // MARK: Public
    
    /// Search for a company
    /// - Parameters:
    ///   - query: Query string (symbol  or name)
    ///   - completion: Callback result
    public func search(query: String,
                       completion: @escaping (Result<SearchResponse, Error>) -> Void) {
        
        guard let safeQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        request(url: url(for: .search,
                         queryParams: ["q": safeQuery]),
                expecting: SearchResponse.self,
                completion: completion)
        
    }
    
    /// Get news for type
    /// - Parameters:
    ///   - type: Company or top stories
    ///   - completion: Result callbacks
    public func news( for type: NewsViewController.TypeNews,
                      completion: @escaping (Result<[NewsStory], Error>) -> Void) {
        
        switch type {
        case .topStories:
        request(url: url(for: .topStories,
                         queryParams: ["category": "general"]),
                expecting: [NewsStory].self,
                completion: completion)
        case .company(let symbol):
            let today = Date()
            let oneMonthBack = today.addingTimeInterval(-(Constants.day * 7))
            
            request(url: url(for: .companyNews,
                             queryParams: [
                                "symbol": symbol,
                                "from": DateFormatter.newsDateFormatter.string(from: oneMonthBack),
                                "to": DateFormatter.newsDateFormatter.string(from: today)
                                
                                          ]),
                    expecting: [NewsStory].self,
                    completion: completion)
        }
    }
    
    /// Get market data
    /// - Parameters:
    ///   - symbol: Given symbol
    ///   - numberOfDays: Number of days back from today
    ///   - completion: Resul callback
    public func marketData(for symbol: String,
                            numberOfDays: TimeInterval = 7,
                            completion: @escaping(Result<MarketDataResponse, Error>) -> Void) {
        let today = Date().addingTimeInterval(-(Constants.day))
        let prior = today.addingTimeInterval(-(Constants.day * numberOfDays))
        let url = url(for: .marketData, queryParams: ["symbol": symbol,
                                                      "resolution": "1",
                                                      "from": "\(Int(prior.timeIntervalSince1970))",
                                                      "to": "\(Int(today.timeIntervalSince1970))",
                                                     ])
        
        request(url: url, expecting: MarketDataResponse.self, completion: completion)
    }
    
    
    /// Get financial metrics
    /// - Parameters:
    ///   - symbol: Symbol of company
    ///   - completion: Result callbacks
    public func financialMetrics(for symbol: String,
                                 completion: @escaping (Result<FinancialMetricsResponse, Error>) -> Void) {
        let url = url(for: .financials, queryParams: ["symbol": symbol, "metric": "all"])
        
        request(url: url,
                expecting: FinancialMetricsResponse.self,
                completion: completion)
        
    }

    
    // MARK: - Private
    
    /// APi Endpoind
    private enum Endpoint: String {
        case search
        case topStories = "news"
        case companyNews = "company-news"
        case marketData = "stock/candle"
        case financials = "stock/metric"
    }
    
    /// API Errors
    private enum APIError: Error {
        case noDataReturn
        case invalidURL
    }
    
    /// Try to create url for endpoint
    /// - Parameters:
    ///   - endpoint: Endpoint to crete for
    ///   - queryParams: Addition query arguments
    /// - Returns: Optional URL
    private func url(for endpoint: Endpoint,
                     queryParams: [String:String] = [:]) -> URL? {
        var urlString = Constants.baseUrl + endpoint.rawValue
        
        var queryItems = [URLQueryItem]()
        // Add any parameters
        for (name, value) in queryParams {
            queryItems.append(.init(name: name, value: value))
        }
        
        // Add token
        queryItems.append(.init(name: "token", value: Constants.apiKey))
        
        // Convert query items to suffix string
        urlString += "?" + queryItems.map { "\($0.name)=\($0.value ?? "")"}.joined(separator: "&")
        
        return URL(string: urlString)
    }

    // MARK: - Generic request
    
    /// Perform api call
    /// - Parameters:
    ///   - url: URL to hit
    ///   - expecting: Type we expect to decode data to
    ///   - completion: Result callback
    private func request<T: Codable> (url: URL?,
                                      expecting: T.Type,
                                      completion: @escaping(Result<T, Error>) -> Void) {
     
        guard let url = url else {
            // Invalid URL
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(APIError.noDataReturn))
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}

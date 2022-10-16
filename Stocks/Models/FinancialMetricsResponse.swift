//
//  FinancialMetricsResponse.swift
//  Stocks
//
//  Created by Joseph Estanislao Calla Moreyra on 11/10/22.
//

import Foundation

/// Metrics response from API
struct FinancialMetricsResponse: Codable {
    let metric: Metrics
}

/// Financial metrics
struct Metrics: Codable {
    let dayAverageTradingVolume: Double
    let AnnualWeekHigh: Double
    let AnnualWeekLow: Double
    let AnnualWeekLowDate: String
    let AnnualWeekPriceReturnDaily: Double
    let beta: Double
    
    enum CodingKeys: String, CodingKey {
       case dayAverageTradingVolume = "10DayAverageTradingVolume"
       case AnnualWeekHigh = "52WeekHigh"
       case AnnualWeekLow = "52WeekLow"
       case AnnualWeekLowDate = "52WeekLowDate"
       case AnnualWeekPriceReturnDaily = "52WeekPriceReturnDaily"
       case beta = "beta"
    }
}

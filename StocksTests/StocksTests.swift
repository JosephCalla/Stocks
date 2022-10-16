//
//  StocksTests.swift
//  StocksTests
//
//  Created by Joseph Estanislao Calla Moreyra on 16/10/22.
//

@testable import Stocks
import XCTest

final class StocksTests: XCTestCase {

    func testSomething () {
        let number = 1
        let string = "1"
        XCTAssertEqual(number, Int(string))
    }

//    func testCandleStickDataConversion() {
//        let doubles: [Double] = Array(repeatElement(12.5, count: 10))
//        var timestamps: [TimeInterval] = []
//
//        for x in 0..<12 {
//            let interval = Date().addingTimeInterval(3600 * TimeInterval(x)).timeIntervalSince1970
//            timestamps.append(interval)
//        }
//
//        timestamps.shuffle()
//
//        let marketData = MarketDataResponse(open: doubles,
//                                            close: doubles,
//                                            high: doubles,
//                                            low: doubles,
//                                            status: "success",
//                                            timestamps: timestamps,
//                                            v: timestamps)
//
//        let candleSticks = marketData.candleSticks
//
//        XCTAssertEqual(candleSticks.count, marketData.open.count)
//        XCTAssertEqual(candleSticks.count, marketData.close.count)
//        XCTAssertEqual(candleSticks.count, marketData.high.count)
//        XCTAssertEqual(candleSticks.count, marketData.low.count)
//
//        // Verify sort
//        let dates = candleSticks.map { $0.date }
//
//        for x in 0..<dates.count-1 {
//            let current = dates[x]
//            let next = dates[x+1]
//            XCTAssertTrue(current < next, "\(current) date should be greater that \(next) date")
//        }
//    }
    
}

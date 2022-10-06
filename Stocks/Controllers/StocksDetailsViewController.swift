//
//  StocksDetailsViewController.swift
//  Stocks
//
//  Created by Joseph Estanislao Calla Moreyra on 3/10/22.
//

import UIKit

class StocksDetailsViewController: UIViewController {
    // MARK: - Properties
    private let symbol: String
    private let companyName: String
    private let candleStickData: [CandleStick]
    
    // MARK: - Init
    // Symbol, Company Name, Any chart data we may have
    init (symbol: String, companyName: String, candleStickData: [CandleStick] = []) {
        self.symbol = symbol
        self.companyName = companyName
        self.candleStickData = candleStickData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }

}

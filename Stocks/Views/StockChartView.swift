//
//  StockChartView.swift
//  Stocks
//
//  Created by Joseph Estanislao Calla Moreyra on 5/10/22.
//

import UIKit

class StockChartView: UIView {

    struct ViewModel {
        let data: [Double]
        let showLegend: Bool
        let showAxisBool: Bool
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // Reset chart view
    func reset() {
        
    }
    
    func configure(with viewMode: ViewModel) {
        
    }
}

//
//  StockChartView.swift
//  Stocks
//
//  Created by Joseph Estanislao Calla Moreyra on 5/10/22.
//

import UIKit
import Charts

class StockChartView: UIView {

    struct ViewModel {
        let data: [Double]
        let showLegend: Bool
        let showAxisBool: Bool
    }

//    private let chartView: LineChartView = {
//        let chartView = LineChartView()
//        chartView.pinchZoomEnabled = false
//        chartView.setScaleEnabled(true)
//        chartView.xAxis.enabled = false
//        chartView.drawGridBackgroundEnabled = false
//        chartView.leftAxis.enabled = false
//        chartView.rightAxis.enabled = false
//        return chartView
//    }()
//
    // MARK: - INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
//        addSubview(chartView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    /// Reset chart view
    func reset() {
//        chartView.data = nil
    }
//
//    func configure(with viewMode: ViewModel) {
//        var entries = [ChartDataEntry]
////        for (index, value) in ViewModel
////        let data = LineChartData(dataSet: dataSet)
////        chartView.data = dat
//    }
}

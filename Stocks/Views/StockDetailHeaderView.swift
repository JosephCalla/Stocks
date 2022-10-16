//
//  StockDetailHeaderView.swift
//  Stocks
//
//  Created by Joseph Estanislao Calla Moreyra on 11/10/22.
//

import UIKit

/// Header for stocks details
final class StockDetailHeaderView: UIView {
    
    /// Metrics viewModels
    private var metricViewModels: [MetricCollectionViewCell.ViewModel] = []
    
    // Subviews
    
    /// ChartView
    private let chartView = StockChartView()
    
    /// CollectionView
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
 
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MetricCollectionViewCell.self,
                                forCellWithReuseIdentifier: MetricCollectionViewCell.identifier)
        collectionView.backgroundColor = .secondarySystemBackground
        return collectionView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubviews(chartView, collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        chartView.frame = CGRect(x: 0, y: 0, width: width, height: height-100)
        collectionView.frame = CGRect(x: 0, y: height-100, width: width, height: 100)
    }
    
    /// Configure View
    /// - Parameters:
    ///   - chartViewModel: Chart view Model
    ///   - metricViewModels: Collection of metric viewModels
    func configure(chartViewModel: StockChartView.ViewModel, metricViewModels: [MetricCollectionViewCell.ViewModel]) {
        chartView.configure(with: chartViewModel)
        self.metricViewModels = metricViewModels
        collectionView.reloadData()
    }
}

// MARK: - CollectionView

extension StockDetailHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return metricViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewModel = metricViewModels[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MetricCollectionViewCell.identifier,
                                                            for: indexPath) as? MetricCollectionViewCell else { fatalError() }
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width/2, height: 100/3)
    }
    
    
    
}

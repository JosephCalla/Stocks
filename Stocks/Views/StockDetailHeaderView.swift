//
//  StockDetailHeaderView.swift
//  Stocks
//
//  Created by Joseph Estanislao Calla Moreyra on 11/10/22.
//

import UIKit

class StockDetailHeaderView: UIView {

    // ChartView
    private let chartView = StockChartView()
    // CollectionView
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .red
        // Register Cells
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubViews(chartView, collectionView)
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
    
    func configure(chartViewModel: StockChartView.ViewModel) {
        
    }
}

// MARK: - CollectionView
extension StockDetailHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: <#T##String#>, for: <#T##IndexPath#>)
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width/2, height: height/3)
    }
    
    
    
}

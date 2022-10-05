//
//  WatchlListTableViewCell.swift
//  Stocks
//
//  Created by Joseph Estanislao Calla Moreyra on 5/10/22.
//

import UIKit

class WatchlListTableViewCell: UITableViewCell {
    static let identifier = "WatchlListTableViewCell"
    static let preferredHeight: CGFloat = 60
    
    struct ViewModel {
        let symbol: String
        let companyName: String
        let price: String // formatted
        let changeColor: UIColor // red or green
        let changePercentage: String // formatted
        // let chartViewModel: StockChartView.ViewModel
    }
    
    // Symbol Label
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    // Company label
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    // Minichart View
    private let miniChartLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    // Price Label
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    // Change in price label
    private let changePriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    private let miniChartView = StockChartView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubViews(symbolLabel,
                    nameLabel,
                    miniChartLabel,
                    priceLabel,
                    changePriceLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        symbolLabel.text = nil
        nameLabel.text = nil
        miniChartLabel.text = nil
        priceLabel.text = nil
        changePriceLabel.text = nil
        miniChartView.reset()
    }
    
    public func configure(with viewModel: ViewModel) {
        symbolLabel.text = viewModel.symbol
        nameLabel.text = viewModel.companyName
        priceLabel.text = viewModel.price
        changePriceLabel.text = viewModel.changePercentage
        changePriceLabel.backgroundColor = viewModel.changeColor
    }
}

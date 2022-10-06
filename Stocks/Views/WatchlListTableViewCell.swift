//
//  WatchlListTableViewCell.swift
//  Stocks
//
//  Created by Joseph Estanislao Calla Moreyra on 5/10/22.
//

import UIKit
protocol WatchlListTableViewCellDelegate: AnyObject {
    func didUpdateMaxWidth()
}

class WatchlListTableViewCell: UITableViewCell {
    static let identifier = "WatchlListTableViewCell"
    static let preferredHeight: CGFloat = 60
    
    weak var delegate: WatchlListTableViewCellDelegate?
    
    struct ViewModel {
        let symbol: String
        let companyName: String
        let price: String // formatted
        let changeColor: UIColor // red or green
        let changePercentage: String // formatted
         let chartViewModel: StockChartView.ViewModel
    }
    
    // Symbol Label
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
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
        label.textAlignment = .right
        label.layer.masksToBounds = true
        return label
    }()

    // Change in price label
    private let changePriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 6
        return label
    }()
    
    private let miniChartView: StockChartView = {
        let chart = StockChartView()
        chart.clipsToBounds = true
        return chart
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        
        addSubViews(symbolLabel,
                    nameLabel,
                    miniChartLabel,
                    priceLabel,
                    changePriceLabel,
                    miniChartView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        symbolLabel.sizeToFit()
        nameLabel.sizeToFit()
        priceLabel.sizeToFit()
        changePriceLabel.sizeToFit()
        
        let yStart: CGFloat = (contentView.height - symbolLabel.height - nameLabel.height) / 2
        
        symbolLabel.frame = CGRect(x: separatorInset.left,
                                   y: yStart,
                                   width: symbolLabel.width,
                                   height: symbolLabel.height)
        
        nameLabel.frame = CGRect(x: separatorInset.left,
                                 y: symbolLabel.bottom,
                                 width: nameLabel.width,
                                 height: nameLabel.height)
        
        let currentWidth = max(max(priceLabel.width, changePriceLabel.width), WatchListViewController.maxChangeWidth)
        
        if currentWidth > WatchListViewController.maxChangeWidth {
            WatchListViewController.maxChangeWidth = currentWidth
            delegate?.didUpdateMaxWidth()
        }
        
        priceLabel.frame = CGRect(x: contentView.width - 10 - currentWidth,
                                  y: 0,
                                  width: currentWidth,
                                  height: priceLabel.height)
        
        changePriceLabel.frame = CGRect(x: contentView.width - 10 - currentWidth,
                                        y: priceLabel.bottom,
                                        width: currentWidth,
                                        height: changePriceLabel.height)
        
        miniChartView.frame = CGRect(x: priceLabel.left - (contentView.width/3) - 5,
                                     y: 6,
                                     width: contentView.width/3,
                                     height: contentView.height-12)
        
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
        
        // Configure chart
    }
}

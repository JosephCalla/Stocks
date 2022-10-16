//
//  WatchlListTableViewCell.swift
//  Stocks
//
//  Created by Joseph Estanislao Calla Moreyra on 5/10/22.
//

import UIKit
/// Delegate to notify of cell events
protocol WatchlListTableViewCellDelegate: AnyObject {
    func didUpdateMaxWidth()
}

/// Table cell for watch list item
final class WatchlListTableViewCell: UITableViewCell {
    /// Cell id
    static let identifier = "WatchlListTableViewCell"
    
    /// Ideal height of cell
    static let preferredHeight: CGFloat = 60
    
    /// Delegate
    weak var delegate: WatchlListTableViewCellDelegate?
    
    /// Watchlist table cell viewModel
    struct ViewModel {
        let symbol: String
        let companyName: String
        let price: String // formatted
        let changeColor: UIColor // red or green
        let changePercentage: String // formatted
         let chartViewModel: StockChartView.ViewModel
    }
    
    /// Symbol Label
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()

    /// Company label
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()

    /// Minichart View
    private let miniChartLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()

    /// Price Label
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .right
        label.layer.masksToBounds = true
        return label
    }()

    /// Change in price label
    private let changePriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 6
        return label
    }()
    
    /// Chart
    private let miniChartView: StockChartView = {
        let chart = StockChartView()
        chart.isUserInteractionEnabled = false
        chart.clipsToBounds = true
        return chart
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        
        addSubviews(symbolLabel,
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
    
    /// Configure view
    /// - Parameter viewModel: View ViewModel
    public func configure(with viewModel: ViewModel) {
        symbolLabel.text = viewModel.symbol
        nameLabel.text = viewModel.companyName
        priceLabel.text = viewModel.price
        changePriceLabel.text = viewModel.changePercentage
        changePriceLabel.backgroundColor = viewModel.changeColor
        miniChartView.configure(with: viewModel.chartViewModel)
    }
}

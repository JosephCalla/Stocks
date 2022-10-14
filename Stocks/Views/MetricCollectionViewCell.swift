//
//  MetricCollectionViewCell.swift
//  Stocks
//
//  Created by Joseph Estanislao Calla Moreyra on 11/10/22.
//

import UIKit

class MetricCollectionViewCell: UICollectionViewCell {
    static let identifier = "MetricCollectionViewCell"
    
    struct ViewModel {
        let name: String
        let value: String
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.addSubViews(nameLabel, valueLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        valueLabel.sizeToFit()
        nameLabel.sizeToFit()
        nameLabel.frame = CGRect(x: 20, y: 0, width: nameLabel.width,
                                 height: contentView.height)
        valueLabel.frame = CGRect(x: nameLabel.width + 15, y: 0, width: valueLabel.width,
                                  height: contentView.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        valueLabel.text = nil
    }
    
    func configure(with viewModel: ViewModel) {
        nameLabel.text = viewModel.name+":"
        valueLabel.text = viewModel.value
    }
}

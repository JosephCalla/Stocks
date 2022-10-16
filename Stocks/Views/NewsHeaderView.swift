//
//  NewsHeaderView.swift
//  Stocks
//
//  Created by Joseph Estanislao Calla Moreyra on 4/10/22.
//

import UIKit


/// Delegate to notify of header events
protocol NewsHeaderViewDelegate: AnyObject {
    /// Notiify user tapped header button
    /// - Parameter headerView: Ref of header view
    func newsHeaderViewDidTapAddButton(_ headerView: NewsHeaderView)
}

/// TableView header for news
final class NewsHeaderView: UITableViewHeaderFooterView {
    /// Header identifier
    static let identifier = "NewsHeaderView"
    
    /// Ideal height of header
    static let preferredHeight: CGFloat = 60
    
    /// Delagete instance for events
    weak var delegate: NewsHeaderViewDelegate?
    
    /// ViewModel for header view
    struct ViewModel {
        let title: String
        let shouldShowAddButton: Bool
    }
    
    // MARK: - Private
    
    private let label: UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 32)
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("+ Watchlist", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    // MARK: - Init
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(label, button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 14, y: 0, width: contentView.width-28, height: contentView.height)
        
        button.sizeToFit()
        button.frame = CGRect(x: contentView.width - button.width - 16,
                              y: (contentView.height - button.height)/2,
                              width: button.width + 8,
                              height: button.height
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    /// Configure view
    /// - Parameter viewModel: View viewModel
    public func configure(with viewModel: ViewModel) {
        label.text = viewModel.title
        button.isHidden = !viewModel.shouldShowAddButton
    }
    
    /// Handle button tap
    @objc private func didTapButton() {
        // Call delegate
        delegate?.newsHeaderViewDidTapAddButton(self)
    }

   

}

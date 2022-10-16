//
//  NewsStoryTableViewCell.swift
//  Stocks
//
//  Created by Joseph Estanislao Calla Moreyra on 4/10/22.
//

import UIKit
import SDWebImage


/// News story tableView Cell
final class NewsStoryTableViewCell: UITableViewCell {
    /// Cell id
    static let identifier = "NewsStoryTableViewCell"
    
    /// Ideal heght of cell
    static let preferredHeight: CGFloat = 140
    
    ///  Cell viewModel
    struct ViewModel {
        let source: String
        let headline: String
        let dateString: String
        let imageUrl: URL?
        
        init(model: NewsStory) {
            self.source = model.source
            self.headline = model.headline
            self.dateString = String.string(from: model.datetime)
            self.imageUrl = URL(string: model.image)
        }
    }

    /// Source
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14,weight: .medium)
        label.numberOfLines = 0
        return label
    }()

    /// Headline
    private let headlineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18,weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    /// Date
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14,weight: .light)
        return label
    }()
    
    /// Image for story
    private let storyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .tertiarySystemBackground
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
        backgroundColor = .secondarySystemBackground
        addSubviews(sourceLabel, headlineLabel, dateLabel, storyImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height/1.4
        storyImageView.frame = CGRect(x: contentView.width-imageSize-10,
                                      y: (contentView.height - imageSize) / 2,
                                      width: imageSize,
                                      height: imageSize)
        
        // Layout labels
        let availableWidth: CGFloat = contentView.width - separatorInset.left - imageSize - 15
        
        sourceLabel.frame = CGRect(x: separatorInset.left,
                                 y: 4,
                                 width: availableWidth,
                                 height: 40)
        sourceLabel.sizeToFit()

        dateLabel.frame = CGRect(x: separatorInset.left,
                                 y: contentView.height - 40,
                                 width: availableWidth,
                                 height: 40)

        headlineLabel.sizeToFit()
        headlineLabel.frame = CGRect(x: separatorInset.left,
                                 y: sourceLabel.bottom,
                                 width: availableWidth,
                                     height: contentView.height - sourceLabel.bottom - dateLabel.height - 10)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sourceLabel.text = nil
        headlineLabel.text = nil
        dateLabel.text = nil
        storyImageView.image = nil
    }
    
    /// Configure
    /// - Parameter viewModel: View ViewModel
    public func configure(with viewModel: ViewModel) {
        headlineLabel.text = viewModel.headline
        sourceLabel.text = viewModel.source
        dateLabel.text = viewModel.dateString
        storyImageView.sd_setImage(with: viewModel.imageUrl, completed: nil)
        // Manually set image
//        storyImageView.setImage(with: viewModel.imageUrl)
    }

}

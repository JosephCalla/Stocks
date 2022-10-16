//
//  SearchResultTableViewCell.swift
//  Stocks
//
//  Created by Joseph Estanislao Calla Moreyra on 3/10/22.
//

import UIKit

/// Tableview cell for search result
final class SearchResultTableViewCell: UITableViewCell {
    
    /// Identifier for cell
    static let identifier = "SearchResultTableViewCell"
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  NewsViewController.swift
//  Stocks
//
//  Created by Joseph Estanislao Calla Moreyra on 4/10/22.
//

import UIKit

class NewsViewController: UIViewController {

    // MARK: Properties
    
    private var stories = [NewsStory]()
    
    private let type: TypeNews
    
    var tableView: UITableView = {
        let table = UITableView()
        // Register cell, header
        table.register(NewsStoryTableViewCell.self, forCellReuseIdentifier: NewsStoryTableViewCell.identifier)
        table.register(NewsHeaderView.self, forHeaderFooterViewReuseIdentifier: NewsHeaderView.identifier)
        table.backgroundColor = .clear
        return table
    }()
    
    enum TypeNews {
        case topStories
        case company(symbol: String)
        
        var title: String {
            switch self {
            case .topStories:
                return "Top Stories"
            case .company(symbol: let symbol):
                return symbol.uppercased()
            }
        }
    }
    
    // MARK: - Initializer
    init(type: TypeNews) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        fetchNews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - Private functions
    private func setupTable() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchNews() {
        APICaller.shared.news(for: type) { result in
            switch result {
            case .success(let stories):
                DispatchQueue.main.async {
                    self.stories = stories
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("❌ \(error)")
            }
        }
    }
    
    private func open(url: URL) {
        
    }

}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsStoryTableViewCell.identifier, for: indexPath) as? NewsStoryTableViewCell else {
            fatalError()
        }
        
        cell.configure(with: .init(model: stories[indexPath.row]))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: NewsHeaderView.identifier
        ) as? NewsHeaderView else {
            return nil
        }
        
        header.configure(with: .init(
            title: self.type.title,
            shouldShowAddButton: false
        ))
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsStoryTableViewCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return NewsHeaderView.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Open news story
    }
}

//
//  NewsViewController.swift
//  Stocks
//
//  Created by Joseph Estanislao Calla Moreyra on 4/10/22.
//

import UIKit
import SafariServices

/// Controller to show news
final class NewsViewController: UIViewController {
    
    /// Type of news
    enum TypeNews {
        case topStories
        case company(symbol: String)
        
        /// Title for given type
        var title: String {
            switch self {
            case .topStories:
                return "Top Stories"
            case .company(symbol: let symbol):
                return symbol.uppercased()
            }
        }
    }
    
    // MARK: - Properties
    
    /// Collection of models
    private var stories = [NewsStory]()
    
    /// Intance of a type
    private let type: TypeNews
    
    /// Primary news view
    var tableView: UITableView = {
        let table = UITableView()
       
        // Register cell, header
        table.register(NewsStoryTableViewCell.self, forCellReuseIdentifier: NewsStoryTableViewCell.identifier)
        table.register(NewsHeaderView.self, forHeaderFooterViewReuseIdentifier: NewsHeaderView.identifier)
        table.backgroundColor = .clear
        return table
    }()
    
    // MARK: - Initializer
   
    /// Crreate VC with type
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
    
    // MARK: - Private
    
    /// Sets up tableView
    private func setupTable() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    /// Fetch news models
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
    
    /// Oopen a story
    /// - Parameter url: URL to open
    private func open(url: URL) {
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }

}

// MARK: - UITableViewDelegate

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
        let story = stories[indexPath.row]
        guard let url = URL(string: story.url) else {
            presentFailedToOpenAlert()
            return
        }
        open(url: url)
    }
    
    /// Present an alert to show an error occurred when opening story
    func presentFailedToOpenAlert() {
        let alert = UIAlertController(title: "Unable to Open", message: "We are unable to open the article", preferredStyle: .alert)
        alert.addAction(.init(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }
}

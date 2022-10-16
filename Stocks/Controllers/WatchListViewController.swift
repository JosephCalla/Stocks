//
//  ViewController.swift
//  Stocks
//
//  Created by Joseph Estanislao Calla Moreyra on 3/10/22.
//

import UIKit
import FloatingPanel

/// VC to render user watch list
final class WatchListViewController: UIViewController {
    /// Timer to optimize searching
    private var searchTimer: Timer?
    
    /// Floating news panel
    private var panel: FloatingPanelController?
    
    /// With to track change label geometry
    static var maxChangeWidth: CGFloat = 0
    
    /// Model
    private var watchlistMap: [String: [CandleStick]] = [:]
    
    // ViewMdels
    private var viewModels: [WatchlListTableViewCell.ViewModel] = []
    
    /// Main view to render watch list
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(WatchlListTableViewCell.self, forCellReuseIdentifier: WatchlListTableViewCell.identifier)
        return table
    }()
    
    /// Observer for watch list updates
    private var observer: NSObjectProtocol?
    
    // MARK: - Lifecycle
    /// Called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        setupSearchController()
        setupTableView()
        fetchWatchlistData()
        setupFloatingPanel()
        setupTitleView()
        setupObserver()
    }
    
    // MARK: - Private
    /// Layout subviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    /// Sets up observer for watch list updates
    private func setupObserver() {
        observer = NotificationCenter.default.addObserver(forName: .didAddToWatchList,
                                                          object: nil,
                                                          queue: .main,
                                                          using: { [weak self]_ in
            self?.viewModels.removeAll()
            self?.fetchWatchlistData()
            
        })
    }
    
    /// Fetch watch list models
    private func fetchWatchlistData() {
        let symbols = PersistenceManager.shared.watchlist
        
        let group = DispatchGroup()
        
        for symbol in symbols where watchlistMap[symbol] == nil {
            group.enter()
            
            APICaller.shared.marketData(for: symbol) { [weak self] result in
                defer {
                    group.leave()
                }
                
                switch result {
                case .success(let data):
                    let candleSticks = data.candleSticks
                    self?.watchlistMap[symbol] = candleSticks
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.createViewModels()
            self?.tableView.reloadData()
        }
    }
    
    /// Creates view models from models
    private func createViewModels() {
        var viewModels = [WatchlListTableViewCell.ViewModel]()
        
        for (symbol, candleSticks) in watchlistMap {
            let changePercentage = getChangePercentage(symbol: symbol,
                                                       data: candleSticks)
            
            viewModels.append(.init(symbol: symbol,
                                    companyName: UserDefaults.standard.string(forKey: symbol) ?? "Company",
                                    price: getLatestClosingPrice(from: candleSticks),
                                    changeColor: changePercentage < 0 ? .systemRed: .systemGreen,
                                    changePercentage: .percentage(from: changePercentage), chartViewModel: .init(
                                        data: candleSticks.reversed().map { $0.close },
                                        showLegend: false,
                                        showAxis: false,
                                        fillColor: changePercentage < 0 ? .systemRed: .systemGreen)))
        }
        self.viewModels = viewModels
    }
    
    /// Get change percentage for symbol data
    /// - Parameters:
    ///   - symbol: Symbol to check for
    ///   - data: Collection of data
    /// - Returns: Double percentage
    private func getChangePercentage(symbol: String, data: [CandleStick]) -> Double {
        let latestDate = data[0].date
        
        guard let latestClose = data.first?.close,
              let priorClose = data.first(where: {
                  !Calendar.current.isDate($0.date, inSameDayAs: latestDate)
              })?.close else {
            return 0
        }
        
        let diff = (1 - (priorClose/latestClose))
        return diff
    }
    
    /// Get latest closing price
    /// - Parameter data: Collection of data
    /// - Returns: String
    private func getLatestClosingPrice(from data: [CandleStick]) -> String {
        guard let closingPrice = data.first?.close else {
            return ""
        }
        return .formatted(number: closingPrice)
    }
    
    /// Sets up tableview
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    /// Sets up floating news panels
    private func setupFloatingPanel() {
        let vc = NewsViewController(type: .topStories)
        let panel = FloatingPanelController(delegate: self)
        panel.surfaceView.backgroundColor = .secondarySystemBackground
        panel.set(contentViewController: vc)
        panel.addPanel(toParent: self)
        panel.track(scrollView: vc.tableView)
    }
    
    /// Sets up custom title view
    private func setupTitleView() {
        let titleView = UIView(frame: CGRect(x: 0,
                                             y: 0,
                                             width: view.width,
                                             height: navigationController?.navigationBar.height ?? 100))
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: titleView.width-20, height: titleView.height))
        label.text = "Stocks"
        label.font = .systemFont(ofSize: 32, weight: .medium)
        titleView.addSubview(label)
        navigationItem.titleView = titleView
    }
    
    /// Sets up search and results controller
    private func setupSearchController() {
        let resultVC = SearchResultsViewController()
        resultVC.delegate = self
        let searchVC = UISearchController(searchResultsController: resultVC)
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
    }
}

// MARK: - UISearchResultsUpdating

extension WatchListViewController: UISearchResultsUpdating {
    /// Update search on key tap
    /// - Parameter searchController: Ref of search controllers
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              let resultsVC = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }
        // Reset timer
        searchTimer?.invalidate()
        
        // Kick off new timer        
        // Optimize to reduce number of searches for when user stopos typing
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { _ in
            // Call API to search
            APICaller.shared.search(query: query) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        resultsVC.update(with: response.result)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        resultsVC.update(with: [])
                    }
                    print(error)
                }
            }
        })
    }
}

// MARK: - SearchResultsViewControllerDelegate

extension WatchListViewController: SearchResultsViewControllerDelegate {
    /// Notify of search result selection
    /// - Parameter searchResult: Seach result that was selected
    func searchResultViewControllerDidSelect(searchResult: SearchResult) {
        navigationItem.searchController?.searchBar.resignFirstResponder()
        
        let vc = StocksDetailsViewController(symbol: searchResult.displaySymbol,
                                             companyName: searchResult.description)
        let navVC = UINavigationController(rootViewController: vc)
        vc.title = searchResult.description
        present(navVC, animated: true)
        
    }
}

// MARK: - FloatingPanelControllerDelegate
extension WatchListViewController: FloatingPanelControllerDelegate {
    /// Get floating panel state change
    /// - Parameter fpc: Ref of controller
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        navigationItem.titleView?.isHidden = fpc.state == .full
    }
}

// MARK: - UITableViewDelegate

extension WatchListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WatchlListTableViewCell.identifier, for: indexPath) as? WatchlListTableViewCell else {
            fatalError()
        }
        cell.delegate = self
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WatchlListTableViewCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            // Update viewModels
            viewModels.remove(at: indexPath.row)
            // Update persistence
            PersistenceManager.shared.removeFromWatchlist(symbol: viewModels[indexPath.row].symbol)
            // Delete Row
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Open Details for selection
        let viewModel = viewModels[indexPath.row]
        let vc = StocksDetailsViewController(symbol: viewModel.symbol,
                                             companyName: viewModel.companyName,
                                             candleStickData: watchlistMap[viewModel.symbol] ?? [])
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    
}

// MARK: - WatchlListTableViewCellDelegate
extension WatchListViewController: WatchlListTableViewCellDelegate {
    /// Notify delegate of change label width
    func didUpdateMaxWidth() {
        // Optimize: Only refresh rows prior to the current row that changes the max width
        tableView.reloadData()
    }
    
    
}

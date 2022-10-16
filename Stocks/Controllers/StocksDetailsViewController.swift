//
//  StocksDetailsViewController.swift
//  Stocks
//
//  Created by Joseph Estanislao Calla Moreyra on 3/10/22.
//

import UIKit
import SafariServices

/// VC to show stock details
class StocksDetailsViewController: UIViewController {
    // MARK: - Properties
    
    /// Stock symbol
    private let symbol: String
    
    /// Company name
    private let companyName: String
    
    /// Collection of data
    private var candleStickData: [CandleStick]
    
    /// Primary view
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsHeaderView.self,
                       forHeaderFooterViewReuseIdentifier: NewsHeaderView.identifier)
        table.register(NewsStoryTableViewCell.self,
                       forCellReuseIdentifier: NewsStoryTableViewCell.identifier)
        return table
    }()
    
    /// Collection of news story
    private var stories = [NewsStory]()
    
    /// Company memtrics
    private var metrics: Metrics?
    
    // MARK: - Init
    // Symbol, Company Name, Any chart data we may have
    init (symbol: String, companyName: String, candleStickData: [CandleStick] = []) {
        self.symbol = symbol
        self.companyName = companyName
        self.candleStickData = candleStickData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = companyName
        setupCloseButton()
        setupTable()
        fetchFinancialData()
        fetchNews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    // MARK: - Private
    
    /// Sets up close button
    private func setupCloseButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapClose))
    }
    
    /// Handle close button
    @objc private func didTapClose() {
        dismiss(animated: true)
    }
    
    /// Sets up table
    private func setupTable() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: (view.width * 0.7) + 100))
    }
    
    /// Fetch financial metrics
    private func fetchFinancialData() {
        let group = DispatchGroup()
        
        // Fetch candle sticks if needed
        if candleStickData.isEmpty {
            group.enter()
            APICaller.shared.marketData(for: symbol) { [weak self] result in
                defer {
                    group.leave()
                }
                
                switch result {
                case .success(let response):
                    self?.candleStickData = response.candleSticks
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        // Fetch financial metrics
        group.enter()
        APICaller.shared.financialMetrics(for: symbol) { [weak self] result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let response):
                let metrics = response.metric
                self?.metrics = metrics
            case .failure(let error):
                print(error)
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.renderChart()
        }
    }

    
    /// Fetch news for given type
    private func fetchNews() {
        APICaller.shared.news(for: .company(symbol: symbol)) { [weak self] result in
            switch result {
            case .success(let stories):
                DispatchQueue.main.async {
                    self?.stories = stories
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// Render chart and metrics
    private func renderChart() {
        let headerView = StockDetailHeaderView(frame: CGRect(x: 0, y: 0, width: view.width, height: (view.width  * 0.7) + 100))
        
        var viewModels = [MetricCollectionViewCell.ViewModel]()
        if let metrics = metrics {
                viewModels.append(.init(name: "52w High", value: "\(metrics.AnnualWeekHigh)"))
                viewModels.append(.init(name: "52L Low", value: "\(metrics.AnnualWeekLow)"))
                viewModels.append(.init(name: "52w Return", value: "\(metrics.AnnualWeekPriceReturnDaily)"))
                viewModels.append(.init(name: "Beta", value: "\(metrics.beta)"))
                viewModels.append(.init(name: "10D Vol.", value: "\(metrics.dayAverageTradingVolume)"))
        }
        // Configure
        let change = getChangePercentage(symbol: symbol, data: candleStickData)
        headerView.configure(chartViewModel: .init(data: candleStickData.reversed().map {$0.close},
                                                   showLegend: false,
                                                   showAxis: false,
                                                   fillColor: change < 0 ? .systemRed : .systemGreen),
                             metricViewModels: viewModels)
        
        DispatchQueue.main.async {
            self.tableView.tableHeaderView = headerView
        }
    }
    
    /// Get change percentage
    /// - Parameters:
    ///   - symbol: Symbol of company
    ///   - data: Collection of data
    /// - Returns: Percent
    private func getChangePercentage(symbol: String, data: [CandleStick]?) -> Double {
        guard let latestDate = data?.first?.date,
              let latestClose = data?.first?.close,
              let priorClose = data?.first(where: {
                  !Calendar.current.isDate($0.date, inSameDayAs: latestDate)
              })?.close else {
            return 0
        }
        
        let diff = (1 - (priorClose/latestClose))
        return diff
    }
}

// MARK: - Tableview

extension StocksDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsStoryTableViewCell.identifier, for: indexPath) as? NewsStoryTableViewCell else { fatalError()}
        cell.configure(with: .init(model: stories[indexPath.row]))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsStoryTableViewCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return NewsHeaderView.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NewsHeaderView.identifier) as? NewsHeaderView else { return nil }
        header.delegate = self
        header.configure(with: .init(title: symbol.uppercased(), shouldShowAddButton: !PersistenceManager.shared.watchlistContains(symbol: symbol)))
        return header
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return NewsHeaderView.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let url = URL(string: stories[indexPath.row].url) else { return }
        
        HapticsManager.shared.vibrateForSelection()

        let vc = SFSafariViewController(url: url)
        
        present(vc, animated: true)
    }
}

// MARK: - NewsHeaderViewDelegate

extension StocksDetailsViewController: NewsHeaderViewDelegate {
    func newsHeaderViewDidTapAddButton(_ headerView: NewsHeaderView) {

        HapticsManager.shared.vibrate(for: .success)

        // Add to watchlist
        headerView.button.isHidden = true
        PersistenceManager.shared.addToWatchlist(symbol: symbol, companyName: companyName)
        
        let alert = UIAlertController(title: "Added to Watchlist",
                                      message: "We've added \(companyName) to your watchlist",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }
    
    
}

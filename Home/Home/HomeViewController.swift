//
//  HomeViewController.swift
//  Home
//
//  Created by Elvin Sestomi on 18/08/24.
//

import UIKit
import Stevia

public class HomeViewController: UIViewController {
    
    var viewModel : HomeViewModel?
    
    
    var stocksTableView : UITableView = {
        var tv = UITableView()
        return tv
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupViewHierarchy()
        setupStyle()
        setupLayout()
        setupTableView()
        viewModel?.mockStock()
    }
    
    func setupData() {
        viewModel = HomeViewModel()
    }
    private func setupTableView() {
        self.stocksTableView.delegate = self
        self.stocksTableView.dataSource = self
        self.stocksTableView.register(StockTableViewCell.self, forCellReuseIdentifier: "customStockCell")
    }
    
    private func setupStyle() {
        
    }
    
    private func setupViewHierarchy() {
        view.subviews{
            stocksTableView
        }
    }
    
    private func setupLayout() {
        title = "Home"
        
        stocksTableView.fillContainer()
    }
}

extension HomeViewController : UITableViewDelegate {}

extension HomeViewController : UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfStocks() ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customStockCell", for: indexPath) as! StockTableViewCell
        
        cell.nameLabel.text = viewModel?.stocks[indexPath.row].name
        cell.stockPriceBoughtAvg.text = String(format: "%.08f", viewModel?.stocks[indexPath.row].priceBoughtAvg ?? -1)
        cell.stockPriceCurrent.text = String(format: "%.08f", viewModel?.stocks[indexPath.row].currentPrice ?? -1)
        cell.stockVolumeBoughtTotal.text = String(viewModel?.stocks[indexPath.row].Volume ?? -1)
        return cell
    }
}

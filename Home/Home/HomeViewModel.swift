//
//  HomeViewModel.swift
//  Home
//
//  Created by Elvin Sestomi on 18/08/24.
//

import Foundation

public class HomeViewModel {
    var stocks : [StockModel] = []
    
    func fetchStock() {
        
    }
    
    internal func numberOfStocks() -> Int {
        return stocks.count
    }
    
    public func mockStock() {
        stocks = [
            StockModel(name: "ABBV", currentPrice: 20, priceBoughtAvg: 10, Volume: 1),
            StockModel(name: "NVDA", currentPrice: 20, priceBoughtAvg: 10, Volume: 1),
            StockModel(name: "JNJ", currentPrice: 20, priceBoughtAvg: 10, Volume: 1),
        ]
    }
}

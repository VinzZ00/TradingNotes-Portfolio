//
//  ContentViewViewModel.swift
//  TradingNotes
//
//  Created by Elvin Sestomi on 01/09/24.
//

import Foundation
import SwiftData

class HomeViewModel : ObservableObject {
    
    @Published var stockBought : [Stock] = []
    @Published var stockWithAvg : [Stock : (Double /*quantity*/, Double /*price*/)] = [:]
    @Published var isSheetShow : Bool = false
    
    @Published var AssetName : String = ""
    @Published var AssetPrice : String = ""
    @Published var boughtQuantity : String = ""
    
    @Published var isInvalidInput : Bool = false
    @Published var error : Bool = false
    
    func saveStockToFireStore() {
        guard
            let price = Double(AssetPrice),
            let boughtQuantity = Double(boughtQuantity)
        else {
            isInvalidInput = true
            return
        }
        
        var stockData : [String : Any] = [:]
        
        stockData["StockName"] = AssetName
        stockData["StockPrice"] = price
        stockData["StockQuantity"] = boughtQuantity
        stockData["dateBought"] = Date()
        stockData["isSold"] = false
        
        FireStoreManager.shared.addData(collection: "Asset", data: stockData) { [weak self] in
            
            self?.stockBought.append(
                Stock(
                    StockName: self?.AssetName ?? "",
                    StockPrice: price,
                    StockQuantity: boughtQuantity,
                    dateBought: Date(),
                    isSold: false
                )
            )
            self?.stockWithAvg = self?.avgStocksPrice() ?? [:]
            
            self?.clearForm()
        }
    }
    
    func clearForm() {
        AssetName = ""
        AssetPrice = ""
        boughtQuantity = ""
    }
    
    func fetchStockFromFireStore() {
        var stocks : [Stock] = []
        FireStoreManager.shared.getSnapShotCollectionOf(collection: "Asset", completion: { [weak self] in
            guard let data = $0 else {
                self?.error = true
                print("Error getting the data")
                return
            }
            stocks.append(contentsOf: data.map{
                var s = Stock.toStock(data: $0.data())
                s.identifier = $0.documentID
                return s
            })
            self?.stockBought = stocks
            self?.stockWithAvg = self?.avgStocksPrice() ?? [:]
        }) 
    }
    
    func filterByAssetName(name : String) -> [Stock] {
        return stockBought.filter { $0.StockName == name}
    }
    
    func avgStocksPrice() -> [Stock : (Double, Double)] {
        return stockBought.reduce(into: [Stock : (Double, Double)]()) { res, s in
            if s.isSold == false {
                if let (quant, price) = res[s] {
                    var price = (price + s.StockPrice) / (quant + s.StockQuantity)
                    var totalQUant = quant + s.StockQuantity
                    res[s] = (totalQUant, price)
                } else {
                    res[s] = (s.StockQuantity, s.StockPrice)
                }
            }
        }
    }

}



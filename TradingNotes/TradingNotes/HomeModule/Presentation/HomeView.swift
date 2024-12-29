//
//  ContentView.swift
//  TradingNotes
//
//  Created by Elvin Sestomi on 01/09/24.
//

import SwiftUI
import CoreData

struct Home: View {
    @StateObject var viewModel = HomeViewModel()
    @Environment(\.colorScheme) var colorScheme
    @Binding var navigationPath : NavigationPath
    
    var body: some View {
        VStack {
            List(viewModel.stockWithAvg.keys.sorted {
                $0.StockName < $1.StockName
            }, id : \.StockName) { stock in
                GeometryReader { geoProx in
                    HStack {
                        Text(stock.StockName)
                            .font(.system(size: 18, weight: .bold))
                            .frame(width: geoProx.size.width * 0.2, alignment: .leading)
                            .lineLimit(9)
                        Spacer()
                        Text(String(format: "%.7f", (viewModel.stockWithAvg[stock] ?? (0,0)).1))
                            .lineLimit(9)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.red)
                            .frame(width: geoProx.size.width * 0.4, alignment: .leading)
                            
                        Spacer()
                        Text(String(format: "%.7f", (viewModel.stockWithAvg[stock] ?? (0,0)).0))
                            .lineLimit(9)
                            .font(.system(size: 16, weight: .regular))
                            .frame(width: geoProx.size.width * 0.4, alignment: .trailing)
                            
                    }.onTapGesture {
                        self.navigationPath.append(stock)
                    }
                }
                .padding()
            }
        }
        .background(.white)
        .navigationDestination(for: Stock.self, destination: { stock in
            DetailAssetViewCoordinator(navigationPath: navigationPath).createModule(
                stocks: viewModel.stockBought.filter { $0.StockName == stock.StockName }
            )
            .navigationTitle("Detail Asset \(stock.StockName)")
            .navigationBarTitleDisplayMode(.inline)
        })
        .padding(.top, 20)
        .navigationTitle("Trading Notes")
        .sheet(isPresented: $viewModel.isSheetShow, content: {
            NavigationStack {
                VStack {
                    TextField("Asset Name", text: $viewModel.AssetName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundStyle(
                            colorScheme == .dark ? Color.white : Color.black
                        )
                        .padding(EdgeInsets(top: 20, leading: 16, bottom: 10, trailing: 16))
                    
                    TextField("Asset Price", text: $viewModel.AssetPrice)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 10, trailing: 16))
                        .foregroundStyle(
                            colorScheme == .dark ? Color.white : Color.black
                        )
                        .keyboardType(.decimalPad)
                        .onChange(of: viewModel.AssetPrice, perform: {
                            viewModel.AssetPrice =  String($0.map {
                                return $0 == "," ? "." : $0
                             })
                        })
                    
                    TextField("Asset Quantity Bought", text : $viewModel.boughtQuantity)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 10, trailing: 16))
                        .foregroundStyle(
                            colorScheme == .dark ? Color.white : Color.black
                        )
                        .keyboardType(.decimalPad)
                        .onChange(of: viewModel.boughtQuantity, perform: {
                            viewModel.boughtQuantity = String($0.map {
                                return $0 == "," ? "." : $0
                            })
                        })
                    Spacer()
                    
                    Button {
                        viewModel.saveStockToFireStore()
                        viewModel.isSheetShow.toggle()
                    } label: {
                        Text("Save")
                            .padding(.horizontal, 32)
                            .padding(.vertical, 16)
                            .foregroundStyle(
                                colorScheme == .dark ? Color.black : Color.white
                            )
                            .background(
                                colorScheme == .dark ? Color.white : Color.black
                            )
                            .clipShape(Capsule(style: .circular))
                    }.padding(EdgeInsets(top: 0, leading: 16, bottom: 30, trailing: 16))
                }
                .navigationTitle("Asset Form")
                .navigationBarTitleDisplayMode(.large)
            }
            .presentationDetents([.fraction(0.75)])
            .presentationDragIndicator(.visible)
        })
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.isSheetShow.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
        })
        .onAppear {
            viewModel.fetchStockFromFireStore()
            viewModel.stockWithAvg = viewModel.avgStocksPrice()
        }
        .refreshable {
            viewModel.fetchStockFromFireStore()
        }
    }
}




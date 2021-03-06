//
//  CurrencyListViewModel.swift
//  converter-money
//
//  Created by Brunno Andrade on 04/10/20.
//

import Foundation

enum OrderByCurrency: Int {
    case code
    case description
}

class CurrencyListViewModel {
    
    let title: String = "Listagem de Moedas"
    private(set) var typeConverter: TypeConverter
    private(set) var currencies: [Currency] = []
    private(set) var currenciesFilter: [Currency] = []
    private(set) var ordenation: OrderByCurrency
    
    init(type: TypeConverter) {
        self.typeConverter = type
        self.ordenation = .code
    }
    
    func filterCurrencies(search: String = "") {
        
        if search.isEmpty {
            self.currenciesFilter = self.currencies
        } else {
            self.currenciesFilter = currencies.filter {
                $0.code.uppercased().contains(search) ||
                $0.description.uppercased().contains(search)
            }
        }
    }
    
    func orderBy(order: OrderByCurrency) {
        switch order {
        case .code:
            self.currencies.sort { $0.code < $1.code }
            self.currenciesFilter.sort { $0.code < $1.code }
        case .description:
            self.currencies.sort { $0.description < $1.description }
            self.currenciesFilter.sort { $0.description < $1.description }
        }
    }
    
    func setCurrenciesArray(currencyList: CurrencyList) {
        
        if let currenciesDictionary = currencyList.currencies {
            
            let currencies = currenciesDictionary.map {
                Currency(code: $0.key, description: $0.value)
            }
            
            self.currencies = currencies
            self.currenciesFilter = currencies
            self.orderBy(order: ordenation)
        }
    }
    
    func fetchCurrencyList(errorCallback: @escaping (ErrorNetwork?) -> Void, successCallback: @escaping () -> Void) {
        
        CurrencyAPI.shared.fetchCurrencyList { [weak self] (result) in
            switch result {
            case .success(let list):
                DispatchQueue.main.async {
                    self?.setCurrenciesArray(currencyList: list)
                    successCallback()
                }
            case .error(let error):
                errorCallback(error)
            }
        }
    }
}

//
//  CurrencyConverterViewModel.swift
//  converter-money
//
//  Created by Brunno Andrade on 03/10/20.
//

import Foundation

class CurrencyConverterViewModel {
    
    let title: String = "Conversor de Moeda"
    private(set) var quotes: [Quote] = []
    
    private(set) var selectedOrigin: Quote?
    private(set) var selectedDestiny: Quote?
    
    func quoteSelect(type: TypeConverter, code: String) {
        
        let quote: Quote = self.searchQuote(with: code) ?? Quote(code: code, value: 1.00)
        
        switch type {
        case .origin:
            self.selectedOrigin = quote
        case .destiny:
            self.selectedDestiny = quote
        }
    }
    
    func shuffleQuote() {
        let originOld: Quote? = self.selectedOrigin
        let destinyOld: Quote? = self.selectedDestiny
        
        if let originNew = originOld, let destinyNew = destinyOld {
            self.selectedOrigin = destinyNew
            self.selectedDestiny = originNew
        }
    }
    
    func searchQuote(with code: String) -> Quote? {
        return self.quotes.first(where: { $0.code == code })
    }
    
    func converterCurrency(_ value: Float) throws -> String {
        if let origin = selectedOrigin, let destiny = selectedDestiny {
            
            if origin.code == destiny.code {
                throw ValidationError.equalsCodes
            }
            
            if origin.code == "USD" {
                return (destiny.value * value).formatCurrency()
            } else {
                return ((value / origin.value) * destiny.value).formatCurrency()
            }
        }
        
        throw ValidationError.converterError
    }
    
    func setQuotesArray(quoteList: QuoteList) {
        if let quotes = quoteList.quotes {
            
            self.quotes = quotes.map {
                Quote(code: $0.key, value: $0.value )
            }
        }
    }
    
    func fetchQuotes(errorCallback: @escaping (ErrorNetwork) -> Void) {
        
        CurrencyAPI.shared.fetchQuotes { [weak self] (result) in
            switch result {
            case .success(let list):
                DispatchQueue.main.async {
                    self?.setQuotesArray(quoteList: list)
                }
            case .error(let error):
                errorCallback(error)
            }
        }
    }
    
    func converterValueToFloatValidation(_ valueToConverter: String) throws -> Float {
        
        guard let selectedOrigin = self.selectedOrigin else { throw ValidationError.emptyQuoteOrigin }
        
        guard let selectedDestiny = self.selectedDestiny else { throw ValidationError.emptyQuoteDestiny }
        
        guard let valueFloat = Float(valueToConverter.replacingOccurrences(of: ",", with: "", options: .literal, range: nil)) else { throw
            ValidationError.invalidValue }
        
        if valueFloat <= 0 {
            throw ValidationError.zeroValue
        }
        
        return valueFloat
    }
}

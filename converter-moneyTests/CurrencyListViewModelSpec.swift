//
//  CurrencyListViewModelSpec.swift
//  converter-moneyTests
//
//  Created by Brunno Andrade on 05/10/20.
//

import XCTest
@testable import converter_money

class CurrencyListViewModelSpec: XCTestCase {
    
    var sut: CurrencyListViewModel!
    var currencyListMock: CurrencyList!

    override func setUpWithError() throws {
        sut = CurrencyListViewModel(type: .origin)
    
        currencyListMock = CurrencyList(success: true, error: nil, currencies: ["AED":"United Arab Emirates Dirham", "AFN": "Afghan Afghani"])
        
        sut.setCurrenciesArray(currencyList: currencyListMock)
        
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    
    func testListCurrencies() {

        XCTAssertEqual(2, sut.currencies.count)
        XCTAssertEqual(2, sut.currenciesFilter.count)
    }
    
    func testTypeConverterChange() {
        let vm = CurrencyListViewModel(type: .destiny)
        
        XCTAssertEqual(vm.typeConverter, .destiny)
    }
    
    func testFilterCurrencies() {
        
        sut.filterCurrencies(search: "AFN")
        
        XCTAssertEqual(2, sut.currencies.count)
        XCTAssertEqual(1, sut.currenciesFilter.count)
    }
    
    func testFilterCurrenciesNotValue() {
        
        sut.filterCurrencies(search: "")
        
        XCTAssertEqual(2, sut.currencies.count)
        XCTAssertEqual(2, sut.currenciesFilter.count)
    }
    
    func testOrderbyCode() {
        
        sut.orderBy(order: .code)
        
        XCTAssertEqual("AED", sut.currencies[0].code)
        XCTAssertEqual("AFN", sut.currenciesFilter[1].code)
    }
    
    func testOrderbyDescription() {
        
        sut.orderBy(order: .description)
        
        XCTAssertEqual("Afghan Afghani", sut.currencies[0].description)
        XCTAssertEqual("United Arab Emirates Dirham", sut.currenciesFilter[1].description)
    }
}

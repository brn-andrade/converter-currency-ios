//
//  CurrencyConverterViewModelSpec.swift
//  converter-moneyTests
//
//  Created by Brunno Andrade on 06/10/20.
//

import XCTest
@testable import converter_money

class CurrencyConverterViewModelSpec: XCTestCase {
    
    var sut: CurrencyConverterViewModel!
    var quoteListMock: QuoteList!
    
    override func setUpWithError() throws {
        sut = CurrencyConverterViewModel()
        
        quoteListMock = QuoteList(success: true, error: nil, source: nil, quotes: ["USDAED": 3.673198, "USDAFN": 76.89408])
        sut.setQuotesArray(quoteList: quoteListMock)
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testArrayQuotes() {
        
        XCTAssertEqual(2, sut.quotes.count)
    }
    
    func testSelectedQuoteOrigin() {
        
        sut.quoteSelect(type: .origin, code: "AED")
        
        XCTAssert((sut.selectedOrigin != nil), "Origin not selected")
        XCTAssertEqual("AED", sut.selectedOrigin?.code)
    }
    
    func testSelectedQuoteDestiny() {
        
        sut.quoteSelect(type: .destiny, code: "AED")
        
        XCTAssert((sut.selectedDestiny != nil), "Destiny not selected")
        XCTAssertEqual("AED", sut.selectedDestiny?.code)
    }
    
    func testSearchQuoteByCode() {
        
        let quote = sut.searchQuote(with: "AFN")
        
        XCTAssertEqual("AFN", quote?.code)
    }
    
    func testConverterCurrencyEquals() {
        
        sut.quoteSelect(type: .origin, code: "AED")
        sut.quoteSelect(type: .destiny, code: "AED")
        
        XCTAssertThrowsError(try sut.converterCurrency(1.00)) { error in
            XCTAssertEqual(error as! ValidationError, ValidationError.equalsCodes)
        }
    }
    
    
    func testConverterCurrencyErrorNotOrigin() {
        
        XCTAssertNil(sut.selectedOrigin)
        
        XCTAssertThrowsError(try sut.converterCurrency(1.00)) { error in
            XCTAssertEqual(error as! ValidationError, ValidationError.converterError)
        }
    }
    
    func testConverterCurrencyErrorNotDestiny() {
        
        sut.quoteSelect(type: .destiny, code: "AED")
        
        XCTAssertEqual("AED", sut.selectedDestiny?.code)
        XCTAssertEqual(3.673198, sut.selectedDestiny?.value)
        XCTAssertNil(sut.selectedOrigin)
        
        XCTAssertThrowsError(try sut.converterCurrency(1.00)) { error in
            XCTAssertEqual(error as! ValidationError, ValidationError.converterError)
        }
    }
    
    func testConverterCurrencySuccess() {
        
        sut.quoteSelect(type: .origin, code: "AED")
        sut.quoteSelect(type: .destiny, code: "AFN")
        
        let value = try! sut.converterCurrency(1.00)
        
        XCTAssertEqual(value, "20.93")
    }
    
    func testConverterCurrencySuccessDollarOrigin() {
        
        let quotesMockDolar: QuoteList = QuoteList(success: true, error: nil, source: nil, quotes: ["USDUSD": 1, "USDBRL": 5.690])
        
        sut.setQuotesArray(quoteList: quotesMockDolar)
        
        sut.quoteSelect(type: .origin, code: "USD")
        sut.quoteSelect(type: .destiny, code: "BRL")
        
        let value = try! sut.converterCurrency(1.00)
        
        XCTAssertEqual(value, "5.69")
    }
    
    func testSuffle() {
        sut.quoteSelect(type: .origin, code: "AED")
        sut.quoteSelect(type: .destiny, code: "AFN")
        sut.shuffleQuote()
        
        XCTAssertEqual(sut.selectedOrigin?.code, "AFN")
        XCTAssertEqual(sut.selectedDestiny?.code, "AED")
    }
    
    
    func testConverterValueToFloatValidationemptyQuoteOrigin() {
        
        XCTAssertNil(sut.selectedOrigin)
        
        XCTAssertThrowsError(try sut.converterValueToFloatValidation("1.00")) { error in
            XCTAssertEqual(error as! ValidationError, ValidationError.emptyQuoteOrigin)
        }
    }
    
    func testConverterValueToFloatValidationemptyQuoteDestiny() {
        
        sut.quoteSelect(type: .origin, code: "AED")
        
        XCTAssertThrowsError(try sut.converterValueToFloatValidation("1.00")) { error in
            XCTAssertEqual(error as! ValidationError, ValidationError.emptyQuoteDestiny)
        }
    }
    
    func testConverterValueToFloatValidationInvalidFloatValue() {
        
        sut.quoteSelect(type: .origin, code: "AED")
        sut.quoteSelect(type: .destiny, code: "AFN")
        
        XCTAssertThrowsError(try sut.converterValueToFloatValidation("testingFloatInvalid")) { error in
            XCTAssertEqual(error as! ValidationError, ValidationError.invalidValue)
        }
    }
    
    func testConverterValueToFloatValidationZeroValue() {
        
        sut.quoteSelect(type: .origin, code: "AED")
        sut.quoteSelect(type: .destiny, code: "AFN")
        
        XCTAssertThrowsError(try sut.converterValueToFloatValidation("0.00")) { error in
            XCTAssertEqual(error as! ValidationError, ValidationError.zeroValue)
        }
    }
    
    func testConverterValueToFloatValidationValueCorrect() {
        
        sut.quoteSelect(type: .origin, code: "AED")
        sut.quoteSelect(type: .destiny, code: "AFN")
        
        let value = try! sut.converterValueToFloatValidation("1.00")
        
        XCTAssertNoThrow(value)
    }
}

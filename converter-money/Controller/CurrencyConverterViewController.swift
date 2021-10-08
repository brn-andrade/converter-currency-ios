//
//  CurrencyConverterViewController.swift
//  converter-money
//
//  Created by Brunno Andrade on 03/10/20.
//

import UIKit

class CurrencyConverterViewController: UIViewController {
    
    @IBOutlet weak var originButton: UIButton!
    @IBOutlet weak var destinyButton: UIButton!
    @IBOutlet weak var currencyTextField: CurrencyField!
    @IBOutlet weak var converterButton: UIButton!
    @IBOutlet weak var convertedLabel: UILabel!
    
    var viewModel: CurrencyConverterViewModel
    weak var coordinator: MainCoordinator?
    
    
    init(viewModel: CurrencyConverterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "CurrencyConverterViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.title
        self.configureView()
        self.fetchQuotes()
        
        currencyTextField.locale = Locale(identifier: "en_US")
        currencyTextField.symbol = false
    }
    
    @IBAction func shuffleAction(_ sender: UIButton) {
        self.viewModel.shuffleQuote()
        
        let origin = originButton.currentTitle
        let destiny = destinyButton.currentTitle
        
        if origin?.count == 3 && destiny?.count == 3 {
            self.originButton.setTitle(destiny, for: .normal)
            self.destinyButton.setTitle(origin, for: .normal)
        }
    }
    
    @IBAction func converterAction(_ sender: UIButton) {
        
        if let value = currencyTextField.text {
            
            do {
                let valueFloat = try
                self.viewModel.converterValueToFloatValidation(value)
                
                if let code = viewModel.selectedDestiny?.code {
                    let locale = NSLocale(localeIdentifier: code)
                    let symbol = locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code)
                    self.convertedLabel.text = "\(symbol ?? "") \(try viewModel.converterCurrency(valueFloat))"
                }
                
            } catch {
                showAlert(title: "Atenção", message: error.localizedDescription)
            }
        }
    }
    
    @IBAction func originAction(_ sender: UIButton) {
        coordinator?.goToList(type: .origin)
    }
    
    @IBAction func destinyAction(_ sender: UIButton) {
        coordinator?.goToList(type: .destiny)
    }
    
    func getSelectCurrency(type: TypeConverter, currency: Currency) {
        
        self.viewModel.quoteSelect(type: type, code: currency.code)
        
        switch type {
        case .origin:
            self.originButton.setTitle(currency.code, for: .normal)
        case .destiny:
            self.destinyButton.setTitle(currency.code, for: .normal)
        }
    }
    
    func fetchQuotes() {
        self.viewModel.fetchQuotes { (error) in
            DispatchQueue.main.async {
                self.showAlert(message: error.rawValue)
            }
        }
    }
    
    func configureView() {
        self.originButton.layer.cornerRadius = 4
        self.destinyButton.layer.cornerRadius = 4
        self.currencyTextField.layer.cornerRadius = 4
        self.converterButton.layer.cornerRadius = 4
    }
}

extension CurrencyConverterViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

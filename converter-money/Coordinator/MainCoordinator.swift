//
//  MainCoordinator.swift
//  converter-money
//
//  Created by Brunno Andrade on 04/10/21.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = CurrencyConverterViewModel()
        let vc = CurrencyConverterViewController(viewModel: viewModel)
        vc.coordinator = self
        
        navigationController.pushViewController(vc, animated: false)
    }
    
    func goToList(type: TypeConverter) {
        let vc = CurrencyListViewController(type: type)
        vc.coordinator = self
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToConverter(type: TypeConverter, currency: Currency) {
    
        if let vc = navigationController.viewControllers.first(where: { $0 is CurrencyConverterViewController }) as? CurrencyConverterViewController {
            vc.getSelectCurrency(type: type, currency: currency)
            
            navigationController.popToViewController(vc, animated: true)
        }
    }
}

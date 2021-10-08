//
//  Coordinator.swift
//  converter-money
//
//  Created by Brunno Andrade on 04/10/21.
//

import Foundation
import UIKit


protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

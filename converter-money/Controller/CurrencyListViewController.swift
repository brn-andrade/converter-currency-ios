//
//  CurrencyListViewController.swift
//  converter-money
//
//  Created by Brunno Andrade on 04/10/20.
//

import UIKit

enum TypeConverter: String {
    case origin
    case destiny
}

class CurrencyListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchCurrencies: UISearchBar!
    
    var viewModel: CurrencyListViewModel
    private let cellIdentifier = "currencyCell"
    weak var coordinator: MainCoordinator?
    
    init(type: TypeConverter) {
        self.viewModel = CurrencyListViewModel(type: type)
        super.init(nibName: "CurrencyListViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupSegmentControl()
        setupTableView()
        setupSearchBar()
        fetchCurrencyList()
    }
    
    func setupNavigationBar() -> Void {
        self.title = viewModel.title
        self.navigationItem.largeTitleDisplayMode = .always
    }
    
    func setupTableView() -> Void {
        tableView.register(CurrencyUiTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setupSearchBar() -> Void {
        self.searchCurrencies.delegate = self
        self.searchCurrencies.becomeFirstResponder()
    }
    
    func setupSegmentControl() {
        
        let items = ["Código", "Descrição"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        navigationItem.titleView = segmentedControl
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        
        switch OrderByCurrency(rawValue: sender.selectedSegmentIndex) {
        case .code:
            viewModel.orderBy(order: .code)
            tableView.reloadData()
        case .description:
            viewModel.orderBy(order: .description)
            tableView.reloadData()
        case .none:
            fatalError("Segment control not selected default")
        }
    }
    
    func fetchCurrencyList() {
        
        viewModel.fetchCurrencyList(errorCallback: { (error) in
            if let err = error {
                self.showAlert(message: err.rawValue)
            }
        }, successCallback: {
            self.tableView.reloadData()
        })
    }
}

// MARK: TablewView

extension CurrencyListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currenciesFilter.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let currentSelect = viewModel.currenciesFilter[indexPath.row]
        
        self.coordinator?.goToConverter(type: viewModel.typeConverter, currency: currentSelect)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CurrencyUiTableViewCell
        else { return CurrencyUiTableViewCell() }
        
        let currentCurrency = viewModel.currenciesFilter[indexPath.row]
        
        cell.setup(currency: currentCurrency)
        
        return cell
    }
}

// MARK: SearchBar
extension CurrencyListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.viewModel.filterCurrencies(search: searchText.uppercased())
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.viewModel.filterCurrencies()
        tableView.reloadData()
    }
}

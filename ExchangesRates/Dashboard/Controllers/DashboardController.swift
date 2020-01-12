//
//  DashboardController.swift
//  ExchangesRates
//
//  Created by Martin Nasierowski on 10/01/2020.
//  Copyright © 2020 Martin Nasierowski. All rights reserved.
//

import UIKit
import Moya

private let reuseIdentifier = "RateCell"

class DashboardController: UIViewController {
    
    // MARK: - Properties

    private var ratesProvider = MoyaProvider<RatesService>()
    private var currentTable: Character = "A"
    private var rates = [Response]()
    private var tableView = UITableView()
    private var safeArea: UILayoutGuide!
    
    private var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.layer.cornerRadius = 5
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "POLISH EXCHANGE RATES"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var reloadDataButton: UIButton = {
        let btn = UIButton(type: .system)
        let image = UIImage(named: "reload")
        btn.setImage(image, for: .normal)
        btn.tintColor = .lightGray
        btn.addTarget(self, action: #selector(reloadTable), for: .touchUpInside)
        return btn
    }()
    
    private lazy var tableA: UIButton = {
        let btn = UIButton(type: .system) as UIButton
        btn.setTitle("A", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemGray4
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(changeTableA), for: .touchUpInside)
        return btn
    }()
    
    private lazy var tableB: UIButton = {
        let btn = UIButton(type: .system) as UIButton
        btn.setTitle("B", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemGray4
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(changeTableB), for: .touchUpInside)
        return btn
    }()
    
    private lazy var tableC: UIButton = {
        let btn = UIButton(type: .system) as UIButton
        btn.setTitle("C", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemGray4
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(changeTableC), for: .touchUpInside)
        return btn
    }()
    
    private lazy var selectTableStack: UIStackView = {
       let stackView = UIStackView()
       stackView.backgroundColor = .systemGray4
       stackView.axis = .horizontal
       stackView.alignment = .fill
       stackView.distribution = .fillEqually
       stackView.spacing = 8.0
       stackView.addArrangedSubview(tableA)
       stackView.addArrangedSubview(tableB)
       stackView.addArrangedSubview(tableC)
       return stackView
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        overrideUserInterfaceStyle = .dark
        view.backgroundColor = .systemGray5
        safeArea = view.layoutMarginsGuide
        createUI()
        loadRates()
        setTableView()
    }
    
    // MARK: - UI
    
    private func createUI() {

        view.addSubview(headerView)
        headerView.anchor(top: safeArea.topAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingBottom: 0, paddingLeft: 10, paddingRight: 10, width: 0, height: 70)
        
        headerView.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor, constant: -20).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
        headerView.addSubview(reloadDataButton)
        reloadDataButton.anchor(top: titleLabel.topAnchor, bottom: titleLabel.bottomAnchor, left: titleLabel.rightAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: 0, width: 0, height: 0)
        
        
        view.addSubview(selectTableStack)
        selectTableStack.anchor(top: headerView.bottomAnchor, bottom: nil , left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingBottom: 10, paddingLeft: 10, paddingRight: 10, width: 0, height: 40)
    }
    
    // MARK: - API
    
    private func loadRates() {
        showProgressHUD()
        ratesProvider.request(.getTable(table: currentTable)) { (result) in
            switch result {
            case .success(let response):
                self.hideProgressHUD()
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.yearMonthDay)
                self.rates = try! decoder.decode([Response].self, from: response.data)
                self.tableView.reloadData()
            case .failure(let error):
                 print(error)
            }
        }
    }
    
    // MARK: - Handlers
    
    @objc private func changeTableA() {
        self.currentTable = "A"
        loadRates()
    }
    @objc private func changeTableB() {
        self.currentTable = "B"
        loadRates()
    }
    @objc private func changeTableC() {
        self.currentTable = "C"
        loadRates()
    }
    
    @objc private func reloadTable() {
        loadRates()
    }
}

    // MARK: - Table View

extension DashboardController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.rates.count > 0 {
            return self.rates[0].rates.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RateCell
        
        if self.rates.count > 0 {
            cell.rate = self.rates[0].rates[indexPath.row]
            cell.effectiveDate = self.rates[0].effectiveDateFormatted
        } else {
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rateController = RateController()
        rateController.currency = self.rates[0].rates[indexPath.row].currency
        rateController.code = self.rates[0].rates[indexPath.row].code
        rateController.table = self.currentTable
        let navController = UINavigationController(rootViewController: rateController)
        present(navController, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RateCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        view.addSubview(tableView)
        tableView.anchor(top: selectTableStack.bottomAnchor, bottom: safeArea.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingBottom: 10, paddingLeft: 10, paddingRight: 10, width: 0, height: 0)
        tableView.register(RateCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = .systemGray5
    }
}


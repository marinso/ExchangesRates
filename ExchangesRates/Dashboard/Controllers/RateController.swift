//
//  RateController.swift
//  ExchangesRates
//
//  Created by Martin Nasierowski on 12/01/2020.
//  Copyright © 2020 Martin Nasierowski. All rights reserved.
//

import UIKit
import DatePickerCell
import Moya

private let reuseIdentifier = "RateDateCell"

class RateController: UIViewController {
    
    // MARK: - Properties
    
    public var currency: String?
    public var table: Character?
    public var code: String?
    private var startDate = Date()
    private var endDate = Date()
    private var safeArea: UILayoutGuide!
    private var tableView = UITableView()
    private let startDatePickerCell = DatePickerCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: nil)
    private let endDatePickerCell = DatePickerCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: nil)
    private var rateDataProvidier = MoyaProvider<RateDataService>()
    private var rateData = [ResponseRatesData]()

    private lazy var reloadButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "reload"), for: .normal)
        btn.tintColor = .gray
        btn.addTarget(self, action: #selector(handleReload), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        view.backgroundColor = .systemGray4
        safeArea = view.layoutMarginsGuide
        
        configureNavigation()
        setTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureNavigationTitle()
    }
    
    private func configureNavigation() {
        configureNavigationTitle()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: reloadButton)
        navigationController?.overrideUserInterfaceStyle = .dark
    }
    
    private func configureNavigationTitle() {
        guard let name = self.currency else { return }
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 15)
        title.text = name.uppercased()
        title.numberOfLines = 0
        title.textAlignment = .center
        title.lineBreakMode = .byWordWrapping
        title.sizeToFit()
        navigationItem.titleView = title
    }
    
    // MARK: - Handlers
    
    @objc private func handleClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleReload() {
        loadRateData()
    }
     
    @objc private func startDatePickerChanged() {
        startDate = startDatePickerCell.datePicker.date
    }
    
    @objc private func endDatePickerChanged() {
        endDate = endDatePickerCell.datePicker.date
    }
    
    // MARK: - API
    
    private func loadRateData() {
        let formatter = DateFormatter.yearMonthDay
        let startDateString = formatter.string(from: startDate)
        let endDateString = formatter.string(from: endDate)
            
        showProgressHUD()
        rateDataProvidier.request(.getRateData(table: table!, code: code!, startDate: startDateString, endDate: endDateString)) { (result) in
            switch result {
            case .success(let response):
                self.hideProgressHUD()
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.yearMonthDay)
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    self.rateData = [try! decoder.decode(ResponseRatesData.self, from: response.data)]
                } catch {
                    self.showError(with: error)
                }
                self.tableView.reloadData()
            case .failure(_):
                self.hideProgressHUD()
                self.showConnectionLost()
            }
        }
    }
}

    // MARK: - TableView

extension RateController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return self.startDatePickerCell.datePickerHeight()
            }
            return self.endDatePickerCell.datePickerHeight()
        }
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 2 } else {
            if rateData.count > 0 {
                return rateData[0].rates.count
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell: DatePickerCell
            if indexPath.row == 0 {
               cell = self.startDatePickerCell
               cell.leftLabel.text = "Start Date"
            } else {
               cell = self.endDatePickerCell
               cell.leftLabel.text = "End Date"
            }
            cell.dateStyle = .medium
            cell.timeStyle = .none
            cell.datePicker.datePickerMode = .date
            cell.rightLabelTextColor = .white
            cell.tintColor = .black
            cell.backgroundColor = .systemGray3
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RateDataCell
            cell.rateData = rateData[0].rates[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let cell: DatePickerCell
            if indexPath.row == 0 {
                cell = self.startDatePickerCell
            } else {
                cell = self.endDatePickerCell
            }
            cell.selectedInTableView(tableView)
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGray5
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
        tableView.anchor(top: safeArea.topAnchor, bottom: safeArea.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingBottom: 10, paddingLeft: 10, paddingRight: 10, width: 0, height: 0)
        
        tableView.register(RateDataCell.self, forCellReuseIdentifier: reuseIdentifier)

        startDatePickerCell.datePicker.addTarget(self, action: #selector(startDatePickerChanged), for: .valueChanged)
        endDatePickerCell.datePicker.addTarget(self, action: #selector(endDatePickerChanged), for: .valueChanged)
    }
}

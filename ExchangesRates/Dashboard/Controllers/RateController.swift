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
    private var rateDateProvidier = MoyaProvider<RateDateService>()
    private var rateData = [Response]()


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
    
    private func configureNavigation() {
        guard let name = self.currency else { return }
        navigationItem.title = name.uppercased()
        navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11)]
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleClose))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: reloadButton)
    }
    
    // MARK: - Handlers
    
    @objc private func handleClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleReload() {
        print("handle refresh")
    }
    
    @objc func startDatePickerChanged() {
        startDate = startDatePickerCell.datePicker.date
        loadRateData()
    }
    
    @objc func endDatePickerChanged() {
        endDate = endDatePickerCell.datePicker.date
        loadRateData()
    }
    
    // MARK: - API
    
    private func loadRateData() {
        let formatter = DateFormatter.yearMonthDay
        let startDateString = formatter.string(from: startDate)
        let endDateString = formatter.string(from: endDate)
        
        print(startDateString)
    
        showProgressHUD()
        rateDateProvidier.request(.getRateDate(table: table!, code: code!, startDate: startDateString, endDate: endDateString)) { (result) in
            switch result {
            case .success(let response):
                self.hideProgressHUD()
                print(response)
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data, options: [])
                    print(json)
                } catch {
                    print(error)
                }

//                let decoder = JSONDecoder()
//                decoder.dateDecodingStrategy = .formatted(DateFormatter.yearMonthDay)
//                self.rateData = try! decoder.decode([Response].self, from: response.data)
//                self.tableView.reloadData()
            case .failure(let error):
                 print(error)
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
        if section == 0 { return 2 } else { return 5 }
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
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
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
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGray5
        tableView.register(RateCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, bottom: safeArea.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingBottom: 10, paddingLeft: 10, paddingRight: 10, width: 0, height: 0)
        tableView.register(RateCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        startDatePickerCell.datePicker.addTarget(self, action: #selector(startDatePickerChanged), for: .valueChanged)
        endDatePickerCell.datePicker.addTarget(self, action: #selector(endDatePickerChanged), for: .valueChanged)
    }
}
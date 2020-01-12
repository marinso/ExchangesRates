//
//  RateCell.swift
//  ExchangesRates
//
//  Created by Martin Nasierowski on 11/01/2020.
//  Copyright © 2020 Martin Nasierowski. All rights reserved.
//

import UIKit

class RateCell: UITableViewCell {
    
    // MARK: - Properties
    
    var rate: Rate? {
        didSet {
            guard let currency = rate?.currency else { return }
            guard let code = rate?.code else { return }
            
            if let mid = rate?.mid {
                midLabel.text = String(describing: mid)
            } else {
                guard let mid = rate?.computedMid else { return }
                midLabel.text = String(describing: mid)
            }
            
            currencyLabel.text = breakLine(name: currency.uppercased())
            codeLabel.text = code.uppercased()
        }
    }
    
    var effectiveDate: String? {
        didSet {
            guard let date = effectiveDate else { return }
            dateLabel.text = date
        }
    }
    
    var currencyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 9)
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    var codeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 255/255, green: 121/255, blue: 121/255, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    var midLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 104/255, green: 109/255, blue: 224/255, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 8)
        return label
    }()
    
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemGray5
        
        addSubview(codeLabel)
        addSubview(currencyLabel)
        addSubview(midLabel)
        addSubview(dateLabel)
        
        codeLabel.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: nil, paddingTop: 5, paddingBottom: 5, paddingLeft: 5, paddingRight: 0, width: 0, height: 0)
        midLabel.anchor(top: nil, bottom: nil, left: nil, right: rightAnchor, paddingTop: 5, paddingBottom: 5, paddingLeft: 0, paddingRight: 5, width: 0, height: 0)
        midLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        currencyLabel.anchor(top: topAnchor, bottom: bottomAnchor, left: codeLabel.rightAnchor, right: midLabel.leftAnchor, paddingTop: 5, paddingBottom: 5, paddingLeft: 10, paddingRight: 10, width: 0, height: 0)
        dateLabel.anchor(top: midLabel.bottomAnchor, bottom: bottomAnchor, left: nil, right: rightAnchor, paddingTop: 5, paddingBottom: 5, paddingLeft: 5, paddingRight: 5, width: 0, height: 0)
    }
    
    private func breakLine(name: String) -> String {
        if let index = name.firstIndex(of: "(") {
            var brokeName = name
            brokeName.insert("\n", at: index)
            return brokeName
        } else {
            return name
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

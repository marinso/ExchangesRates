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
            currencyLabel.text = rate?.currency.uppercased()
            codeLabel.text = rate?.code.uppercased()
            midLabel.text = String(describing: rate!.mid!)
        }
    }
    
    var currencyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 9)
        return label
    }()
    
    var codeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    var midLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    var stackCurrency: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .systemGray4
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 8.0
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemGray5
        
        addSubview(codeLabel)
        addSubview(currencyLabel)
        addSubview(midLabel)
        
        codeLabel.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: nil, paddingTop: 5, paddingBottom: 5, paddingLeft: 5, paddingRight: 0, width: 0, height: 0)
        midLabel.anchor(top: topAnchor, bottom: bottomAnchor, left: nil, right: rightAnchor, paddingTop: 5, paddingBottom: 5, paddingLeft: 0, paddingRight: 5, width: 0, height: 0)
        currencyLabel.anchor(top: topAnchor, bottom: bottomAnchor, left: nil, right: midLabel.leftAnchor, paddingTop: 5, paddingBottom: 5, paddingLeft: 0, paddingRight: 10, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

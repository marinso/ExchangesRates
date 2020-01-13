//
//  RateDataCell.swift
//  ExchangesRates
//
//  Created by Martin Nasierowski on 12/01/2020.
//  Copyright © 2020 Martin Nasierowski. All rights reserved.
//

import UIKit

class RateDataCell: UITableViewCell {
    
    // MARK: - Property
    
    var rateData: RateData? {
        didSet {
            guard let no = rateData?.no else { return }
            guard let date = rateData?.effectiveDateFormatted else { return }

            if let mid = rateData?.mid {
                midLabel.text = String(describing: mid)
            } else {
                guard let mid = rateData?.computedMid else { return }
                midLabel.text = String(format: "%.6f", mid)
            }

            noLabel.text = no
            dateLabel.text = date
        }
    }
    
    var noLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    var midLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 104/255, green: 109/255, blue: 224/255, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()

    var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .systemGray5

        addSubview(midLabel)
        addSubview(noLabel)
        addSubview(dateLabel)

        dateLabel.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: nil, paddingTop: 5, paddingBottom: 5, paddingLeft: 15, paddingRight: 15, width: 0, height: 0)
        noLabel.anchor(top: topAnchor, bottom: bottomAnchor, left: dateLabel.rightAnchor, right: midLabel.leftAnchor, paddingTop: 5, paddingBottom: 5, paddingLeft: 5, paddingRight: 5, width: 0, height: 0)
        midLabel.anchor(top: topAnchor, bottom: bottomAnchor, left: nil, right: rightAnchor, paddingTop: 5, paddingBottom: 5, paddingLeft: 15, paddingRight: 15, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

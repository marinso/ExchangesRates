//
//  DateFormatter+Extensions.swift
//  ExchangesRates
//
//  Created by Martin Nasierowski on 12/01/2020.
//  Copyright © 2020 Martin Nasierowski. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let yearMonthDay: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
}

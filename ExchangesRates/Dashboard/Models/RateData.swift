//
//  RateData.swift
//  ExchangesRates
//
//  Created by Martin Nasierowski on 12/01/2020.
//  Copyright © 2020 Martin Nasierowski. All rights reserved.
//

import Foundation

struct RateData: Decodable {
    let effectiveDate: Date
    let no: String
    let mid: Float?
    let ask: Float?
    let bid: Float?

    enum CodingKeys: String, CodingKey {
        case effectiveDate
        case no
        case mid
        case ask
        case bid
    }

    init(from decoder: Decoder) throws {
        let container      = try decoder.container(keyedBy: CodingKeys.self)
        self.effectiveDate = try container.decode(Date.self, forKey: .effectiveDate)
        self.no            = try container.decode(String.self, forKey: .no)
        self.mid           = try container.decodeIfPresent(Float.self, forKey: .mid)
        self.ask           = try container.decodeIfPresent(Float.self, forKey: .ask)
        self.bid           = try container.decodeIfPresent(Float.self, forKey: .bid)
    }

    var effectiveDateFormatted: String {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .medium
        dateformatter.timeStyle = .none
        return dateformatter.string(from: effectiveDate)
    }
    
    var computedMid: Float? {
        guard let ask = self.ask else { return nil }
        guard let bid = self.bid else { return nil }
        let mid = (ask + bid) / 2
        return mid
    }
}

struct ResponseRatesData: Decodable {
    let rates: [RateData]
    
    enum CodingKeys: String, CodingKey {
        case rates
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rates    = try container.decode([RateData].self, forKey: .rates)
    }
}

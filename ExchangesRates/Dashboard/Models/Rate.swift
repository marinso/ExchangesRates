//
//  Rate.swift
//  ExchangesRates
//
//  Created by Martin Nasierowski on 11/01/2020.
//  Copyright © 2020 Martin Nasierowski. All rights reserved.
//

import Foundation

struct Rate: Decodable {
    let currency: String
    let code:     String
    let mid:      Float?
    let ask:      Float?
    let bid:      Float?
    
    enum CodingKeys: String, CodingKey {
        case currency
        case code
        case mid
        case ask
        case bid
    }
    
    init(from decoder: Decoder) throws {
        let container  = try decoder.container(keyedBy: CodingKeys.self)
        self.currency  = try container.decode(String.self, forKey: .currency)
        self.code      = try container.decode(String.self, forKey: .code)
        self.mid       = try container.decodeIfPresent(Float.self,  forKey: .mid)
        self.ask       = try container.decodeIfPresent(Float.self, forKey: .ask)
        self.bid       = try container.decodeIfPresent(Float.self, forKey: .bid)
    }
    
    var computedMid: Float? {
        guard let ask = self.ask else { return nil }
        guard let bid = self.bid else { return nil }
        let mid = (ask + bid) / 2
        return mid
    }
}

struct Response: Decodable {
    let effectiveDate: Date
    let rates:         [Rate]
    
    enum CodingKeys: String, CodingKey {
        case effectiveDate
        case rates
    }
    
    init(from decoder: Decoder) throws {
        let container      = try decoder.container(keyedBy: CodingKeys.self)
        self.effectiveDate = try container.decode(Date.self, forKey: .effectiveDate)
        self.rates         = try container.decode([Rate].self, forKey: .rates)
    }
    
    var effectiveDateFormatted: String {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .medium
        dateformatter.timeStyle = .none
        return dateformatter.string(from: effectiveDate)
    }
}

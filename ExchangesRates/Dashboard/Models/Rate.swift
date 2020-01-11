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
    
    enum CodingKeys: String, CodingKey {
      case currency
      case code
      case mid
    }
    
    init(from decoder: Decoder) throws {
      let container  = try decoder.container(keyedBy: CodingKeys.self)
      self.currency  = try container.decode(String.self, forKey: .currency)
      self.code      = try container.decode(String.self, forKey: .code)
      self.mid       = try container.decode(Float.self,  forKey: .mid)
    }
}

struct Response: Decodable {
    let effectiveDate: String
    let rates:         [Rate]
    
    enum CodingKeys: String, CodingKey {
        case effectiveDate
        case rates
    }
    
    init(from decoder: Decoder) throws {
        let container      = try decoder.container(keyedBy: CodingKeys.self)
        self.effectiveDate = try container.decode(String.self, forKey: .effectiveDate)
        self.rates         = try container.decode([Rate].self, forKey: .rates)
    }
}

//
//  RatesService.swift
//  ExchangesRates
//
//  Created by Martin Nasierowski on 10/01/2020.
//  Copyright © 2020 Martin Nasierowski. All rights reserved.
//

import Foundation
import Moya

enum RatesService {
    case getTable(table: Character)
}

extension RatesService: TargetType {
    var baseURL: URL {
        return URL(string: "http://api.nbp.pl")!
    }
    
    var path: String {
        switch self {
        case .getTable(let table):
            return "/api/exchangerates/tables/\(table)"
        }
    }
    
    var method: Moya.Method {
        switch self {
         case .getTable(_):
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getTable(_):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}

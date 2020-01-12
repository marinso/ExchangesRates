//
//  RateDateService.swift
//  ExchangesRates
//
//  Created by Martin Nasierowski on 12/01/2020.
//  Copyright © 2020 Martin Nasierowski. All rights reserved.
//

import Foundation
import Moya

enum RateDateService {
    case getRateDate(table: Character, code: String, startDate: String, endDate: String)
}

extension RateDateService: TargetType {
    var baseURL: URL {
        return URL(string: "http://api.nbp.pl")!
    }
    
    var path: String {
        switch self {
        case .getRateDate(let table, let code, let startDate, let endDate):
            return "/exchangerates/rates/\(table)/\(code)/\(startDate)/\(endDate)/"
        }
    }
    
    var method: Moya.Method {
        switch self {
         case .getRateDate(_,_,_,_):
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getRateDate(_,_,_,_):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}


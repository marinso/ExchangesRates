//
//  RateDataService.swift
//  ExchangesRates
//
//  Created by Martin Nasierowski on 12/01/2020.
//  Copyright © 2020 Martin Nasierowski. All rights reserved.
//

import Foundation
import Moya

enum RateDataService {
    case getRateData(table: Character, code: String, startDate: String, endDate: String)
}

extension RateDataService: TargetType {
    var baseURL: URL {
        return URL(string: "http://api.nbp.pl")!
    }
    
    var path: String {
        switch self {
        case .getRateData(let table, let code, let startDate, let endDate):
            return "/api/exchangerates/rates/\(table)/\(code)/\(startDate)/\(endDate)/"
        }
    }
    
    var method: Moya.Method {
        switch self {
         case .getRateData(_,_,_,_):
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getRateData(_,_,_,_):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}


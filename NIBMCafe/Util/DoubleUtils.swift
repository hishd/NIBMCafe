//
//  DoubleUtils.swift
//  NIBMCafe
//
//  Created by Hishara Dilshan on 2021-03-03.
//

import Foundation


extension Double {
    var lkrString: String {
        return String(format: "RS. %.2f", self)
    }
    
    var amountString: String {
        return String(format: "%.2f", self)
    }
    
    static func getLKRString(amount: Double) -> String {
        return String(format: "RS. %.2f", amount)
    }
}

//class Formatter {
//    class func getLKRString(amount: Double) -> String {
//        return String(format: "%.2f", amount)
//    }
//}

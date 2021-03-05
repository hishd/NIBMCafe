//
//  Models.swift
//  NIBMCafe
//
//  Created by Hishara Dilshan on 2021-02-27.
//

import Foundation


struct User: Codable {
    var _id: String?
    var userName: String?
    var email: String?
    var phoneNo: String?
    var password: String?
    
    init(_id: String?, userName: String?, email: String?, phoneNo: String?, password: String?) {
        self._id = _id
        self.userName = userName
        self.email = email
        self.phoneNo = phoneNo
        self.password = password
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decodeIfPresent(String.self, forKey: ._id)
        self.userName = try container.decodeIfPresent(String.self, forKey: .userName)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.phoneNo = try container.decodeIfPresent(String.self, forKey: .phoneNo)
        self.password = try container.decodeIfPresent(String.self, forKey: .password)
    }
}


struct FoodCategory {
    var categoryName: String
    var isSelected: Bool
}

struct FoodItem {
    var foodName: String
    var foodDescription: String
    var foodPrice: Double
    var discount: Int
    var foodImgRes: String
    var foodCategory: String = ""
    var discountedPrice: Double {
        return foodPrice - (foodPrice * (Double(discount)/100))
    }
}

struct CartItem {
    var itemName: String
    var itemImgRes: String
    var discount: Int
    var itemPrice: Double
    var itemCount: Int
    var itemTotal: Double {
        return Double(itemCount) *  discountedPrice
    }
    var discountedPrice: Double {
        return itemPrice - (itemPrice * (Double(discount)/100))
    }
}

struct Order {
    var orderID: String
    var orderStatus: OrderStatus
    var orderStatusString: String
    var orderDate: Date
    var itemCount: Int
    var orderTotal: Double
    var orderItems: [OrderItem] = []
}

struct OrderItem {
    var foodItem: FoodItem
    var qty: Int
}

enum OrderStatus {
    case ORDER_PENDING
    case ORDER_READY
    case ORDER_COMPLETED
}

//
//  Models.swift
//  NIBMCafe
//
//  Created by Hishara Dilshan on 2021-02-27.
//

import Foundation


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

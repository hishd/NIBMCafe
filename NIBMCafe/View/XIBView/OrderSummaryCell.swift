//
//  OrderSummaryCell.swift
//  NIBMCafe
//
//  Created by Hishara Dilshan on 2021-03-03.
//

import UIKit

class OrderSummaryCell: UITableViewCell {
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblItemNames: UILabel!
    @IBOutlet weak var lblItemInfo: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    
    class var reuseIdentifier: String {
        return "orderSummaryReuseIdentifier"
    }
    
    class var nibName: String {
        return "OrderSummaryCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(order: Order) {
        lblItemNames.addInterlineSpacing(spacingValue: 5)
        lblItemInfo.addInterlineSpacing(spacingValue: 5, alignment: .right)
        
        var foodNames: String = ""
        var orderInfo: String = ""
        var totalAmount: Double = 0
                
        for item in order.orderItems {
            foodNames += "\n\(item.foodItem.foodName)"
            orderInfo += "\n\(item.qty) X \(item.foodItem.foodPrice.lkrString)"
            totalAmount += Double(item.qty) * item.foodItem.foodPrice
        }
        
        lblDate.text = DateUtil.getDate(date: order.orderDate)
        lblItemNames.text = foodNames
        lblItemInfo.text = orderInfo
        lblTotalAmount.text = "Total : \(totalAmount.lkrString)"
    }
    
}

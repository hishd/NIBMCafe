//
//  OrderCell.swift
//  NIBMCafe
//
//  Created by Hishara Dilshan on 2021-03-03.
//

import UIKit

class OrderCell: UITableViewCell {

    @IBOutlet weak var lblOrderID: UILabel!
    @IBOutlet weak var lblOrderDate: UILabel!
    @IBOutlet weak var lblOrderItemCount: UILabel!
    @IBOutlet weak var lblOrderStatus: UILabel!
    @IBOutlet weak var lblOrderTotal: UILabel!
    
    class var reuseIdentifier: String {
        return "orderItemReuseIdentifier"
    }
    
    class var nibName: String {
        return "OrderCell"
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
        lblOrderID.text = order.orderID
        lblOrderDate.text = DateUtil.getDate(date: order.orderDate)
        lblOrderItemCount.text = "\(order.itemCount) Items"
        lblOrderStatus.text = order.orderStatusString
        lblOrderTotal.text = order.orderTotal.lkrString
    }
    
}

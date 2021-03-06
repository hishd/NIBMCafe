//
//  CartItemCell.swift
//  NIBMCafe
//
//  Created by Hishara Dilshan on 2021-02-28.
//

import UIKit

class CartItemCell: UITableViewCell {
    
    @IBOutlet weak var imgFoodItem: UIImageView!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblItemPrice: UILabel!
    @IBOutlet weak var lblItemCount: UILabel!
    
    var delegate: CartItemDelegate!
    var indexPath: IndexPath!
    
    class var reuseIdentifier: String {
        return "cartItemReuseIdentifier"
    }
    
    class var nibName: String {
        return "CartItemCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onMinusClicked(_ sender: UIButton) {
        delegate.onCartItemMinusClick(at: indexPath)
    }
    
    @IBAction func onAddClicked(_ sender: UIButton) {
        delegate.onCartItemAddClick(at: indexPath)
    }
    
    func configureCell(cartItem: CartItem) {
        imgFoodItem.kf.setImage(with: URL(string: cartItem.itemImgRes))
//        imgFoodItem.image = UIImage(named: cartItem.itemImgRes)
        lblItemName.text = cartItem.itemName
        lblItemPrice.text = "\(cartItem.itemTotal.lkrString)"
        lblItemCount.text = "\(cartItem.itemCount)"
    }
    
}

protocol CartItemDelegate {
    func onCartItemAddClick(at indexPath: IndexPath)
    func onCartItemMinusClick(at indexPath: IndexPath)
}

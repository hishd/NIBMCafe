//
//  FoodItemCell.swift
//  NIBMCafe
//
//  Created by Hishara Dilshan on 2021-02-27.
//

import UIKit

class FoodItemCell: UITableViewCell {
    
    @IBOutlet weak var imgFood: UIImageView!
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var lblFoodDescription: UILabel!
    @IBOutlet weak var lblFoodPrice: UILabel!
    @IBOutlet weak var viewOfferContainer: UIView!
    @IBOutlet weak var lblDiscount: UILabel!
    
    
    class var reuseIdentifier: String {
        return "foodItemReuseIdentifier"
    }
    
    class var nibName: String {
        return "FoodItemCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(foodItem: FoodItem) {
        if foodItem.discount == 0 {
            viewOfferContainer.isHidden = true
        } else {
            viewOfferContainer.isHidden = false
            lblDiscount.text = "\(foodItem.discount)% OFF"
        }
        
        imgFood.image = UIImage(named: foodItem.foodImgRes)
        lblFoodName.text = foodItem.foodName
        lblFoodDescription.text = foodItem.foodDescription
        lblFoodPrice.text = "\(foodItem.discountedPrice.lkrString)"
    }
    
}

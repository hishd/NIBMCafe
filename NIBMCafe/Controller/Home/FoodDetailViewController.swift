//
//  FoodDetailViewController.swift
//  NIBMCafe
//
//  Created by Hishara Dilshan on 2021-02-28.
//

import UIKit
import Kingfisher

class FoodDetailViewController: UIViewController {

    @IBOutlet weak var imgFood: UIImageView!
    @IBOutlet weak var viewContainerDiscount: UIView!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var lblFoodDescription: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    
    @IBOutlet weak var lblDiscountedText: UILabel!
    @IBOutlet weak var lblDiscountedAmount: UILabel!
    
    var foodItem: FoodItem!
    var selectedQty: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateVIew()
    }
    
    @IBAction func onBackPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onMinusPressed(_ sender: UIButton) {
        if selectedQty <= 1 {
            return
        }
        
        selectedQty -= 1
        refreshView()
    }
    
    @IBAction func onAddPressed(_ sender: UIButton) {
        selectedQty += 1
        refreshView()
    }
    
    @IBAction func onAddToCartPressed(_ sender: UIButton) {
    }
    
    func refreshView() {
        lblQty.text = "\(selectedQty)"
        
        UIView.transition(with: lblTotalAmount, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.lblTotalAmount.text = "\(Double.getLKRString(amount: self.foodItem.foodPrice * Double(self.selectedQty)))"
        }, completion: nil)
        
        if foodItem.discount != 0 {
            UIView.transition(with: lblDiscountedAmount, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.lblDiscountedAmount.text = "\(Double.getLKRString(amount: self.foodItem.discountedPrice * Double(self.selectedQty)))"
            }, completion: nil)
        }
    }
    
    func updateVIew() {
        if foodItem.discount == 0 {
            lblTotalAmount.textColor = UIColor(named: "dark")
            viewContainerDiscount.isHidden = true
            lblDiscountedText.isHidden = true
            lblDiscountedAmount.isHidden = true
        } else {
            lblTotalAmount.textColor = UIColor(named: "dark_gray")
            viewContainerDiscount.isHidden = false
            lblDiscountedText.isHidden = false
            lblDiscountedAmount.isHidden = false
            lblDiscountedAmount.text = "\(foodItem.discountedPrice.lkrString)"
            lblDiscount.text = "\(foodItem.discount)% OFF"
        }
        
        imgFood.kf.setImage(with: URL(string: foodItem.foodImgRes))
//        imgFood.image = UIImage(named: foodItem.foodImgRes)
        lblFoodName.text = foodItem.foodName
        lblFoodDescription.text = foodItem.foodDescription
        lblTotalAmount.text = "\(foodItem.foodPrice.lkrString)"
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  CartItemViewController.swift
//  NIBMCafe
//
//  Created by Hishara Dilshan on 2021-02-28.
//

import UIKit

class CartItemViewController: UIViewController {

    @IBOutlet weak var tblCartItems: UITableView!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblItems: UILabel!
    
    var totalBill: Double = 0;
    
    var cartItems: [CartItem] = [
        CartItem(itemName: "Chicken Burger", itemImgRes: "burger", discount: 30, itemPrice: 1500.00, itemCount: 1),
        CartItem(itemName: "French Fries", itemImgRes: "fries", discount: 0, itemPrice: 750.00, itemCount: 2),
        CartItem(itemName: "Vegan Salad", itemImgRes: "salad", discount: 10, itemPrice: 1150.00, itemCount: 5),
        CartItem(itemName: "Chicken Shawarma", itemImgRes: "shawarma", discount: 12, itemPrice: 1250.00, itemCount: 2),
        CartItem(itemName: "Crispy Chicken", itemImgRes: "chicken", discount: 20, itemPrice: 1000.00, itemCount: 1)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNIB()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshCartInfo()
    }
    
    func registerNIB() {
        tblCartItems.register(UINib(nibName: CartItemCell.nibName, bundle: nil), forCellReuseIdentifier: CartItemCell.reuseIdentifier)
    }
    
    func refreshCartInfo() {
        lblItems.text = "\(cartItems.count) Items"
        totalBill = cartItems.lazy.map {$0.itemTotal}.reduce(0 , +)
        lblTotalAmount.text = "RS. \(totalBill)"
    }
    
    @IBAction func onCheckoutClicked(_ sender: UIButton) {
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

extension CartItemViewController: CartItemDelegate {
    func onCartItemAddClick(at indexPath: IndexPath) {
        self.cartItems[indexPath.row].itemCount += 1
        tblCartItems.reloadRows(at: [indexPath], with: .automatic)
        refreshCartInfo()
    }
    
    func onCartItemMinusClick(at indexPath: IndexPath) {
        if self.cartItems[indexPath.row].itemCount == 1 {
            return
        }
        
        self.cartItems[indexPath.row].itemCount += -1
        tblCartItems.reloadRows(at: [indexPath], with: .automatic)
        refreshCartInfo()
    }
}

extension CartItemViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblCartItems.dequeueReusableCell(withIdentifier: CartItemCell.reuseIdentifier, for: indexPath) as! CartItemCell
        cell.selectionStyle = .none
        cell.indexPath = indexPath
        cell.delegate = self
        cell.configureCell(cartItem: cartItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cartItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            refreshCartInfo()
        }
    }
}

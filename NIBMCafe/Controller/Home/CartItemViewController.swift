//
//  CartItemViewController.swift
//  NIBMCafe
//
//  Created by Hishara Dilshan on 2021-02-28.
//

import UIKit

class CartItemViewController: BaseViewController {
    
    @IBOutlet weak var tblCartItems: UITableView!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblItems: UILabel!
    
    var totalBill: Double = 0;
    
    let realmDB = RealmDB.instance
    
    var cartItems: [CartItem] = []
        
    //    var cartItems: [CartItem] = [
    //        CartItem(itemName: "Chicken Burger", itemImgRes: "burger", discount: 30, itemPrice: 1500.00, itemCount: 1),
    //        CartItem(itemName: "French Fries", itemImgRes: "fries", discount: 0, itemPrice: 750.00, itemCount: 2),
    //        CartItem(itemName: "Vegan Salad", itemImgRes: "salad", discount: 10, itemPrice: 1150.00, itemCount: 5),
    //        CartItem(itemName: "Chicken Shawarma", itemImgRes: "shawarma", discount: 12, itemPrice: 1250.00, itemCount: 2),
    //        CartItem(itemName: "Crispy Chicken", itemImgRes: "chicken", discount: 20, itemPrice: 1000.00, itemCount: 1)
    //    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNIB()
        networkMonitor.delegate = self
        firebaseOP.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshCartInfo()
        networkMonitor.delegate = self
        firebaseOP.delegate = self
    }
    
    func registerNIB() {
        tblCartItems.register(UINib(nibName: CartItemCell.nibName, bundle: nil), forCellReuseIdentifier: CartItemCell.reuseIdentifier)
    }
    
    func refreshCartInfo() {
        cartItems.removeAll()
        cartItems.append(contentsOf: realmDB.getCartItems())
        lblItems.text = "\(cartItems.count) Items"
        totalBill = cartItems.lazy.map {$0.itemTotal}.reduce(0 , +)
        lblTotalAmount.text = "RS. \(totalBill)"
    }
    
    @IBAction func onCheckoutClicked(_ sender: UIButton) {
        if cartItems.count == 0 {
            displayInfoMessage(message: "No items in the cart!")
            return
        }
        displayOrderConfirmAlert()
    }
    
    func displayOrderConfirmAlert() {
        displayActionSheet(title: "Confirm Purchase",
                           message: "You are about to make a purchase or \(totalBill.lkrString), Confirm ?",
                           positiveTitle: "Yes",
                           negativeTitle: "Cancel",
                           positiveHandler: {
                            action in
                            self.confirmAndPurchase()
                           },
                           negativeHandler: {
                            action in
                            self.dismiss(animated: true, completion: nil)
                           })
    }
    
    func confirmAndPurchase() {
        guard let email = SessionManager.getUserSesion()?.email else {
            NSLog("The email is empty")
            displayErrorMessage(message: FieldErrorCaptions.orderPlacingError)
            return
        }
        
        var orderItems: [OrderItem] = []
        for item in cartItems {
            orderItems.append(
                OrderItem(
                    foodItem: FoodItem(foodName: item.itemName,
                                       foodDescription: item.description,
                                       foodPrice: item.discountedPrice,
                                       discount: item.discount,
                                       foodImgRes: item.itemImgRes),
                    qty: item.itemCount)
            )
        }
        
        displayProgress()
        firebaseOP.placeFoodOrder(order: Order(
                                    orderID: "",
                                    orderStatusCode: 0,
                                    orderStatusString: "Pending",
                                    orderDate: Date(),
                                    itemCount: cartItems.count,
                                    orderTotal: totalBill,
                                    orderItems: orderItems),
                                  email: email)
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
        //        self.cartItems[indexPath.row].itemCount += 1
        realmDB.updateItemQTY(cartItem: self.cartItems[indexPath.row], increased: true, callback: {
            result in
            if result {
                refreshCartInfo()
                tblCartItems.reloadRows(at: [indexPath], with: .automatic)
            } else {
                displayErrorMessage(message: "Could not update cart item")
            }
        })
    }
    
    func onCartItemMinusClick(at indexPath: IndexPath) {
        if self.cartItems[indexPath.row].itemCount == 1 {
            return
        }
        
        //        self.cartItems[indexPath.row].itemCount += -1
        realmDB.updateItemQTY(cartItem: self.cartItems[indexPath.row], increased: false, callback: {
            result in
            if result {
                refreshCartInfo()
                tblCartItems.reloadRows(at: [indexPath], with: .automatic)
            } else {
                displayErrorMessage(message: "Could not update cart item")
            }
        })
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
            realmDB.deleteFromCart(cartItem: cartItems[indexPath.row], callback: {
                result in
                if result {
                    //                    tableView.deleteRows(at: [indexPath], with: .fade)
                    refreshCartInfo()
                    tblCartItems.reloadData()
                } else {
                    displayErrorMessage(message: "Could not remove item")
                }
            })
        }
    }
}

extension CartItemViewController : FirebaseActions {
    func onOrderPlaced() {
        dismissProgress()
        displaySuccessMessage(message: "Order placed successfully", completion: {
            self.dismiss(animated: true, completion: nil)
        })
        realmDB.removeAllFromCart(callback: {
            result in
            if result {
                NSLog("Items cleared")
            } else {
                NSLog("Unable to clear items")
            }
        })
        refreshCartInfo()
        tblCartItems.reloadData()
    }
    func onOrderPlaceFailedWithError(error: String) {
        dismissProgress()
        displayErrorMessage(message: error)
    }
}

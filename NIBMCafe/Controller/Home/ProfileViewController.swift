//
//  ProfileViewController.swift
//  NIBMCafe
//
//  Created by Hishara Dilshan on 2021-03-03.
//

import UIKit
import ListPlaceholder

class ProfileViewController: UIViewController {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblPhoneNo: UILabel!
    
    @IBOutlet weak var txtFromDate: UITextField!
    @IBOutlet weak var txtToDate: UITextField!
    @IBOutlet weak var lblTotalAmount: UILabel!
    
    @IBOutlet weak var tblPastOrders: UITableView!
    
    var periodTotal: Double = 0
    
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    
    let foodItems: [FoodItem] = [
        FoodItem(foodName: "Chicken Burger", foodDescription: "Chicken patty hamburger", foodPrice: 1500.00, discount: 30, foodImgRes: "burger"),
        FoodItem(foodName: "French Fries", foodDescription: "Deep fried French fries", foodPrice: 750.00, discount: 0, foodImgRes: "fries"),
        FoodItem(foodName: "Vegan Salad", foodDescription: "Half boiled vegetable salad", foodPrice: 1150.00, discount: 10, foodImgRes: "salad"),
        FoodItem(foodName: "Chicken Shawarma", foodDescription: "Devilled Chicken Shawarma", foodPrice: 1250.00, discount: 12, foodImgRes: "shawarma"),
        FoodItem(foodName: "Crispy Chicken", foodDescription: "Deep fried crispy chicken", foodPrice: 1800.00, discount: 20, foodImgRes: "chicken"),
        FoodItem(foodName: "Coffee", foodDescription: "Hot black Coffee", foodPrice: 150.00, discount: 0, foodImgRes: "coffee")
    ]
    
    var fetchedOrders: [Order] = [
        Order(orderID: "#1290", orderStatus: .ORDER_COMPLETED, orderStatusString: "Completed", orderDate: DateUtil.getDate(date: "03-03-2021 05:35"), itemCount: 2, orderTotal: 1500.00),
        Order(orderID: "#1324", orderStatus: .ORDER_READY, orderStatusString: "Ready to Pick Up", orderDate: DateUtil.getDate(date: "02-03-2021 05:35"), itemCount: 5, orderTotal: 1800.00),
        Order(orderID: "#1567", orderStatus: .ORDER_PENDING, orderStatusString: "10 Minutes Left", orderDate: DateUtil.getDate(date: "01-03-2021 05:35"), itemCount: 3, orderTotal: 1250.00)
    ]
    
    var passedOrders: [Order] = []
    
    let textArray: [String] = ["Text1\nText2\nText3\nText4", "Text1\nText2", "Text1\nText2\nText3\nText4\nText5\nText6\nText7"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNIB()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        imgProfile.generateRoundImage()
        buildDatePicker()
        txtToDate.text = dateFormatter.string(from: Date())
        txtFromDate.text = dateFormatter.string(from: Date())
//        tblPastOrders.reloadData()
//        tblPastOrders.showLoader()
        
        fetchedOrders[0].orderItems.append(OrderItem(foodItem: foodItems[0], qty: 1))
        fetchedOrders[0].orderItems.append(OrderItem(foodItem: foodItems[2], qty: 5))
        fetchedOrders[0].orderItems.append(OrderItem(foodItem: foodItems[4], qty: 2))
        fetchedOrders[0].orderItems.append(OrderItem(foodItem: foodItems[5], qty: 2))
        
        fetchedOrders[1].orderItems.append(OrderItem(foodItem: foodItems[1], qty: 1))
        fetchedOrders[1].orderItems.append(OrderItem(foodItem: foodItems[3], qty: 3))
        fetchedOrders[1].orderItems.append(OrderItem(foodItem: foodItems[4], qty: 2))
        
        fetchedOrders[2].orderItems.append(OrderItem(foodItem: foodItems[0], qty: 5))
        fetchedOrders[2].orderItems.append(OrderItem(foodItem: foodItems[1], qty: 6))
        fetchedOrders[2].orderItems.append(OrderItem(foodItem: foodItems[2], qty: 2))
        fetchedOrders[2].orderItems.append(OrderItem(foodItem: foodItems[3], qty: 1))
        fetchedOrders[2].orderItems.append(OrderItem(foodItem: foodItems[4], qty: 1))
        fetchedOrders[2].orderItems.append(OrderItem(foodItem: foodItems[5], qty: 1))
        
        passedOrders.removeAll()
        passedOrders.append(contentsOf: fetchedOrders)
        
        refreshData()
        
    }
    
    @IBAction func onEditClicked(_ sender: UIButton) {
        
    }
    
    func registerNIB() {
        tblPastOrders.register(UINib(nibName: OrderSummaryCell.nibName, bundle: nil), forCellReuseIdentifier: OrderSummaryCell.reuseIdentifier)
        self.tblPastOrders.estimatedRowHeight = 250
        self.tblPastOrders.rowHeight = UITableView.automaticDimension
    }
    
    func refreshData() {
        periodTotal = passedOrders.lazy.map {$0.orderTotal}.reduce(0 , +)
        lblTotalAmount.text = periodTotal.lkrString
        tblPastOrders.reloadData()
    }
    
    func buildDatePicker() {
        let pickerToolBar = UIToolbar()
        pickerToolBar.sizeToFit()
        
        let doneAction = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(onDatePicked))
        pickerToolBar.setItems([doneAction], animated: true)
        txtToDate.inputAccessoryView = pickerToolBar
        txtFromDate.inputAccessoryView = pickerToolBar
        txtToDate.inputView = datePicker
        txtFromDate.inputView = datePicker
        datePicker.datePickerMode = .date
        dateFormatter.dateStyle = .medium
        
        if #available(iOS 13.4, *) {
           datePicker.preferredDatePickerStyle = .wheels
        }
    }
    
    @objc func onDatePicked() {
        if txtToDate.isFirstResponder {
            txtToDate.text = dateFormatter.string(from: datePicker.date)
        }
        if txtFromDate.isFirstResponder {
            txtFromDate.text = dateFormatter.string(from: datePicker.date)
        }
        self.view.endEditing(true)
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

extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passedOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblPastOrders.dequeueReusableCell(withIdentifier: OrderSummaryCell.reuseIdentifier, for: indexPath) as! OrderSummaryCell
        cell.selectionStyle = .none
        cell.configureCell(order: passedOrders[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width, y: 0)
        UIView.animate(withDuration: 1.0, delay: 0.05 * Double(indexPath.row), usingSpringWithDamping: 0.4, initialSpringVelocity: 0.1,
                       options: .curveEaseIn, animations: {
                        cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width, y: cell.contentView.frame.height)
                       })
    }
}

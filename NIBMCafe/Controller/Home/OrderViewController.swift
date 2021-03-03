//
//  OrderViewController.swift
//  NIBMCafe
//
//  Created by Hishara Dilshan on 2021-03-03.
//

import UIKit

class OrderViewController: UIViewController {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var tblOrders: UITableView!
    
    let calendar = Calendar(identifier: .gregorian)
    
    let fetchedOrders: [Order] = [
        Order(orderID: "#1290", orderStatus: .ORDER_COMPLETED, orderStatusString: "Completed", orderDate: DateUtil.getDate(date: "03-03-2021 05:35"), itemCount: 2, orderTotal: 1500.00),
        Order(orderID: "#1324", orderStatus: .ORDER_READY, orderStatusString: "Ready to Pick Up", orderDate: DateUtil.getDate(date: "03-03-2021 05:35"), itemCount: 5, orderTotal: 1800.00),
        Order(orderID: "#1567", orderStatus: .ORDER_PENDING, orderStatusString: "10 Minutes Left", orderDate: DateUtil.getDate(date: "03-03-2021 05:35"), itemCount: 3, orderTotal: 1250.00)
    ]
    
    var filteredOrders: [Order] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNIB()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        imgProfile.generateRoundImage()
        filteredOrders.removeAll()
        filteredOrders.append(contentsOf: fetchedOrders)
        tblOrders.reloadData()
    }
    
    
    @IBAction func onOrderTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            filteredOrders.removeAll()
            filteredOrders.append(contentsOf: fetchedOrders)
            tblOrders.reloadData()
            return
        case 1:
            filteredOrders.removeAll()
            filteredOrders = fetchedOrders.filter { $0.orderStatus == OrderStatus.ORDER_PENDING || $0.orderStatus == OrderStatus.ORDER_READY }
            tblOrders.reloadData()
            return
        case 2:
            filteredOrders.removeAll()
            filteredOrders = fetchedOrders.filter { $0.orderStatus == OrderStatus.ORDER_COMPLETED }
            tblOrders.reloadData()
            return
        default:
            return
        }
    }
    
    func registerNIB() {
        tblOrders.register(UINib(nibName: OrderCell.nibName, bundle: nil), forCellReuseIdentifier: OrderCell.reuseIdentifier)
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

extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblOrders.dequeueReusableCell(withIdentifier: OrderCell.reuseIdentifier, for: indexPath) as! OrderCell
        cell.selectionStyle = .none
        cell.configureCell(order: filteredOrders[indexPath.row])
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

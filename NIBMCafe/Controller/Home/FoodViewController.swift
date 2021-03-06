//
//  FoodViewController.swift
//  NIBMCafe
//
//  Created by Hishara Dilshan on 2021-02-27.
//

import UIKit

class FoodViewController: BaseViewController {
    
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var collectionViewCategories: UICollectionView!
    @IBOutlet weak var tblViewFood: UITableView!
    
    var selectedCategoryIndex: Int = 0
    var selectedFoodIndex: Int = 0
    
    var categories: [FoodCategory] = []
    var foodItemList: [FoodItem] = []
    
    var filteredFood: [FoodItem] = []
    
//    var categories: [FoodCategory] = [
//        FoodCategory(categoryName: "All", isSelected: true),
//        FoodCategory(categoryName: "Pasta", isSelected: false),
//        FoodCategory(categoryName: "Drinks", isSelected: false),
//        FoodCategory(categoryName: "Beverages", isSelected: false),
//        FoodCategory(categoryName: "Deserts", isSelected: false)
//    ]
//
//    var foodItems: [FoodItem] = [
//        FoodItem(foodName: "Chicken Burger", foodDescription: "Chicken patty hamburger", foodPrice: 1500.00, discount: 30, foodImgRes: "burger"),
//        FoodItem(foodName: "French Fries", foodDescription: "Deep fried French fries", foodPrice: 750.00, discount: 0, foodImgRes: "fries"),
//        FoodItem(foodName: "Vegan Salad", foodDescription: "Half boiled vegetable salad", foodPrice: 1150.00, discount: 10, foodImgRes: "salad"),
//        FoodItem(foodName: "Chicken Shawarma", foodDescription: "Devilled Chicken Shawarma", foodPrice: 1250.00, discount: 12, foodImgRes: "shawarma"),
//        FoodItem(foodName: "Crispy Chicken", foodDescription: "Deep fried crispy chicken", foodPrice: 1800.00, discount: 20, foodImgRes: "chicken"),
//        FoodItem(foodName: "Coffee", foodDescription: "Hot black Coffee", foodPrice: 150.00, discount: 0, foodImgRes: "coffee")
//    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkMonitor.delegate = self
        firebaseOP.delegate = self
        
        btnCart.generateRoundButton()
        registerNIB()

        firebaseOP.fetchAllFoodItems()
        displayProgress()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        firebaseOP.delegate = self
        networkMonitor.delegate = self
        
        if #available(iOS 10.0, *) {
            tblViewFood.refreshControl = refreshControl
        } else {
            tblViewFood.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshFoodData), for: .valueChanged)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryBoardSegues.homeToViewDetails {
            let destVC = segue.destination as! FoodDetailViewController
            destVC.foodItem = filteredFood[selectedFoodIndex]
        }
    }
    
    func registerNIB() {
        let collectionViewNib = UINib(nibName: CategoryCell.nibName, bundle: nil)
        collectionViewCategories.register(collectionViewNib, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        if let flowLayout = self.collectionViewCategories?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 80, height: 30)
        }
        tblViewFood.register(UINib(nibName: FoodItemCell.nibName, bundle: nil), forCellReuseIdentifier: FoodItemCell.reuseIdentifier)
    }
    
    @objc func refreshFoodData() {
        firebaseOP.fetchAllFoodItems()
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

// MARK: - In class methods

extension FoodViewController {
    func filterFood(foodCategory: String) {
        filteredFood.removeAll()
        filteredFood = foodItemList.filter { $0.foodCategory == foodCategory }
        tblViewFood.reloadData()
    }
    
    func displayAllFood() {
        filteredFood.removeAll()
        filteredFood.append(contentsOf: foodItemList)
        tblViewFood.reloadData()
    }
}

// MARK: - UICollectionView protocol Methods

extension FoodViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionViewCategories.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier,
                                                                   for: indexPath) as? CategoryCell {
            cell.configureCell(category: categories[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        categories[selectedCategoryIndex].isSelected = false
        selectedCategoryIndex = indexPath.row
        categories[indexPath.row].isSelected = true
        UIView.transition(with: collectionViewCategories, duration: 0.3, options: .transitionCrossDissolve, animations: {self.collectionViewCategories.reloadData()}, completion: nil)
        
        if indexPath.row == 0 {
            displayAllFood()
            return
        }
        
        filterFood(foodCategory: categories[indexPath.row].categoryName)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell: CategoryCell = Bundle.main.loadNibNamed(CategoryCell.nibName,
                                                                owner: self,
                                                                options: nil)?.first as? CategoryCell else {
            return CGSize.zero
        }
        cell.configureCell(category: categories[indexPath.row])
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: size.width, height: 30)
    }
}

// MARK: - FoodItem TableView protocol Methods

extension FoodViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFood.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblViewFood.dequeueReusableCell(withIdentifier: FoodItemCell.reuseIdentifier, for: indexPath) as! FoodItemCell
        cell.selectionStyle = .none
        cell.configureCell(foodItem: filteredFood[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFoodIndex = indexPath.row
        self.performSegue(withIdentifier: StoryBoardSegues.homeToViewDetails, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width, y: 0)
        UIView.animate(withDuration: 0.5, delay: 0.01 * Double(indexPath.row), usingSpringWithDamping: 0.4, initialSpringVelocity: 0.1,
                       options: .curveEaseIn, animations: {
                        cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width, y: cell.contentView.frame.height)
                       })
    }
}

extension FoodViewController : FirebaseActions {
    func onCategoriesLoaded(categories: [FoodCategory]) {
        refreshControl.endRefreshing()
        dismissProgress()
        self.categories.removeAll()
        self.categories.append(contentsOf: categories)
        self.collectionViewCategories.reloadData()
    }
    func onFoodItemsLoaded(foodItems: [FoodItem]) {
        refreshControl.endRefreshing()
        dismissProgress()
        foodItemList.removeAll()
        filteredFood.removeAll()
        self.foodItemList.append(contentsOf: foodItems)
        self.filteredFood.append(contentsOf: foodItemList)
        self.tblViewFood.reloadData()
    }
    func onFoodItemsLoadFailed(error: String) {
        refreshControl.endRefreshing()
        dismissProgress()
        displayErrorMessage(message: error)
    }
}


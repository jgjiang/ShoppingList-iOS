//
//  HistoryViewController.swift
//  ShoppingList
//
//  Created by Tony on 26/03/2017.
//  Copyright © 2017 Tony. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, PurchaseItemCellDelegate  {
    var currentUser: FIRUser!
    
    var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var totalPriceUILabel: UILabel!
    @IBOutlet weak var payUIButton: UIButton!
    @IBOutlet weak var historyTableView: UITableView!
    
    @IBOutlet weak var totalQuantityUILabel: UILabel!
    @IBOutlet weak var mostExpensiveUILabel: UILabel!
    
    
 
    var purchaseItems = [PurchaseItem]()
    var purchaseItemManagedObject:PurchaseItem! = nil
    
    @IBAction func payAction(_ sender: Any) {
        
        currentUser = FIRAuth.auth()?.currentUser
        if currentUser == nil {
            let alertController = UIAlertController(title: "Error", message: "Please Log in to Make a Payment.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Congrats", message: "You Made a Payment! This is just a Demo.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        

        }
        
    }
   
    
    
    // context, entity, fetchResultController
    let  context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchResultController: NSFetchedResultsController<NSFetchRequestResult>! = nil

    
    func makeRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PurchaseItem")
        let sorter = NSSortDescriptor(key:"name", ascending: true)
        request.sortDescriptors = [sorter]
        return request
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.reloadData()
        
        // Fetch data from data store
        fetchResultController = NSFetchedResultsController(fetchRequest: makeRequest(),managedObjectContext:context, sectionNameKeyPath:nil, cacheName: nil)
        
        fetchResultController.delegate = self
        
        do {try fetchResultController.performFetch()}
        catch{print("CoreData Error")}
        
        if let fetchedObjects = fetchResultController.fetchedObjects {
            purchaseItems = fetchedObjects as! [PurchaseItem]
        }
        
        totalPriceUILabel.text = "$" + calTotalPrice(purchaseItems)
        totalQuantityUILabel.text = "Your Total Item Quantity: " + calTotalQuantity(purchaseItems)
        mostExpensiveUILabel.text = "Most Expensive Unit Price: " + findMostExpensive(purchaseItems)
        
        historyTableView.estimatedRowHeight = 60.0
        historyTableView.rowHeight = UITableViewAutomaticDimension
    }
    

    
    func calTotalPrice(_ items:[PurchaseItem]) -> String {
        var sum:Double = 0.0
        
        for item in items {
            var price:Double!
            price = Double(item.price!)! * Double(Int32(item.quantity))
            sum += price
        }
        
        let totalPrice: String! = String(sum)
        return totalPrice
    }
    
    func calTotalQuantity(_ items:[PurchaseItem]) -> String {
        
        var sumQuantity:Int32 = 0
        for item in items {
            var quantity: Int32!
            quantity = item.quantity
            sumQuantity += quantity
        }
        return String(sumQuantity)
    }
    
    func findMostExpensive(_ items:[PurchaseItem]) -> String {
        
        var mostExpensivePrice: Int32 = 0
        for item in items {
            if Int32(item.price!)! > mostExpensivePrice {
                mostExpensivePrice = Int32(item.price!)!
            }
        }
        
        return String(mostExpensivePrice)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        historyTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        if let fetchedObjects = controller.fetchedObjects {
            purchaseItems = fetchedObjects as! [PurchaseItem]
        }
        
        totalPriceUILabel.text = "$" + calTotalPrice(purchaseItems)
        totalQuantityUILabel.text = "Your Total Item Quantity: " + calTotalQuantity(purchaseItems)
        mostExpensiveUILabel.text = "Most Expensive Unit Price: " + findMostExpensive(purchaseItems)
        historyTableView.reloadData()
        
    }
    
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //return (fetchResultController.sections?.count)!
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // return fetchResultController.sections! [section].numberOfObjects
    
        return purchaseItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PurchaseItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! PurchaseItemTableViewCell
       
        cell.delegate = self
        cell.itemImageView.image = UIImage(data: purchaseItems[indexPath.row].image as! Data)
        cell.nameLabel.text = purchaseItems[indexPath.row].name
        cell.priceLabel.text = "$" + purchaseItems[indexPath.row].price!
        cell.quantityLabel.text = String(purchaseItems[indexPath.row].quantity)
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
            context.delete(purchaseItems[indexPath.row])
            do {try context.save()}
            catch {print("save error")}
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func plusPressed(cell: PurchaseItemTableViewCell) {
        
        let indexPath: IndexPath? = self.historyTableView.indexPath(for: cell)
        if indexPath != nil {
        
           let num = Int32(cell.quantityLabel.text!)! + 1
            if num > 100 {
                cell.quantityLabel.text = String (100)
            } else {
                cell.quantityLabel.text = String (num)
            
            }
            
            let pItem: PurchaseItem = purchaseItems[(indexPath?.row)!]
            pItem.quantity = Int32(cell.quantityLabel.text!)!
            
            do {try context.save()}
            catch{ print("Core data Error: contect does not save")}
            
        }
        
    }
    
    func minusPressed(cell: PurchaseItemTableViewCell) {
        let indexPath: IndexPath? = self.historyTableView.indexPath(for: cell)
        if indexPath != nil {
            // var num = 0
            
            let num = Int32(cell.quantityLabel.text!)! - 1
            if num < 0 {
                cell.quantityLabel.text = String (0)
            } else {
                cell.quantityLabel.text = String (num)
                
            }
        }
        
        let pItem: PurchaseItem = purchaseItems[(indexPath?.row)!]
        pItem.quantity = Int32(cell.quantityLabel.text!)!
        
        do {try context.save()}
        catch{ print("Core data Error: contect does not save")}
        
        
        
    }

}






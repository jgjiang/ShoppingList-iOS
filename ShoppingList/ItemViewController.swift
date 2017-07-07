//
//  ItemViewController.swift
//  ShoppingList
//
//  Created by Tony on 25/03/2017.
//  Copyright © 2017 Tony. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseAuth

class ItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var loginUIBarButtonItem: UIBarButtonItem!

    
    @IBOutlet weak var itemTableView: UITableView!
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
        
    }
    
    
    
    // array for itemManageObjects
    var items:[ShoppingItem] = []
    
    
    // context, entity, fetchResultController
    let  context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchResultController: NSFetchedResultsController<NSFetchRequestResult>! = nil
    
    var itemManagedObject:ShoppingItem! = nil
    var purchaseItemManagedObject:PurchaseItem! = nil
    
    func makeRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ShoppingItem")
        let sorter = NSSortDescriptor(key:"name", ascending: true)
        request.sortDescriptors = [sorter]
        return request
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Shopping List"
        
        itemTableView.delegate = self
        itemTableView.dataSource = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // enable self-sizing cells
        itemTableView.estimatedRowHeight = 80.0
        itemTableView.rowHeight = UITableViewAutomaticDimension
        
        
        // Fetch data from data store
        fetchResultController = NSFetchedResultsController(fetchRequest: makeRequest(),managedObjectContext:context, sectionNameKeyPath:nil, cacheName: nil)
        
        fetchResultController.delegate = self
        
        do {try fetchResultController.performFetch()}
        catch{print("CoreData Error")}
        
        if let fetchedObjects = fetchResultController.fetchedObjects {
            items = fetchedObjects as! [ShoppingItem]
        }
        
       
        
        let user  = FIRAuth.auth()?.currentUser
        
        if ((user) != nil) {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ItemViewController.logoutAction))
        } else {
            
        }
        
    }
    
    
    // refresh views display in this controller
    override func viewWillAppear(_ animated: Bool) {
        
        if loginFlag == 1 {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ItemViewController.logoutAction))
            
        } else {
        
            
        
        }
        
    }
    
    
    
    // logout function for left bar button item
    func logoutAction() {
        
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Login", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ItemViewController.loginAction))
        
                loginFlag = 0
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        
    }
    
    // login function for left bar button item
    
    func loginAction() {
    
        print("log in")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginNC") as! UINavigationController
        present(vc, animated: true, completion: nil)
    
    }
    
    
   
    
    
    /*
    
    @IBAction func showHistoryTab(_ sender: Any) {
        
        
        
        let navContoller = self.tabBarController?.viewControllers?[1] as! UINavigationController
        let historyViewContoller = navContoller.topViewController as! HistoryViewController
        
        if let fetchedObjects = fetchResultController.fetchedObjects {
            items = fetchedObjects as! [ShoppingItem]
        }
    
        historyViewContoller.myItems = items
        self.itemTableView.reloadData()
    
        //items.removeAll()
        //deleteAllData()
        
      
       // print(historyViewContoller.myItems[0].name!)
        //self.tabBarController?.selectedIndex = 1
        

    }
    
 */
    
   /*
    func deleteAllData(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        for item in items {
            context.delete(item)
            do {try context.save()}
            catch{print("error")}
            
        }
    } */
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
        
        itemManagedObject = items[indexPath.row]
            
        // fetchResultController.object(at: indexPath) as! ShoppingItem
        
        // Configure the cell...
        cell.nameLabel.text = itemManagedObject.name
        cell.priceLabel.text = "$"+itemManagedObject.price!
        cell.quantityLabel.text = "Quantity: "+String(itemManagedObject.quantity)
        cell.imageView?.image = UIImage(data: itemManagedObject.image as! Data)
        
        return cell
    }
   
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        if let fetchedObjects = controller.fetchedObjects {
            items = fetchedObjects as! [ShoppingItem]
        }
        
        
        itemTableView.reloadData()
        
    }
    
    
    
   func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    /*
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
            context.delete(itemManagedObject)
            do {try context.save()}
            catch {print("save error")}
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    */
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let addHistoryAction = UITableViewRowAction(style:UITableViewRowActionStyle.default, title: "Buy",handler:{
            (action, indexPath) -> Void in
            
            //let navContoller = self.tabBarController?.viewControllers?[1] as! UINavigationController
            //let historyViewContoller = navContoller.topViewController as! HistoryViewController
            
            self.itemManagedObject =  self.fetchResultController.object(at: indexPath) as! ShoppingItem
            
            let entity = NSEntityDescription.entity(forEntityName: "PurchaseItem", in: self.context)
            self.purchaseItemManagedObject = PurchaseItem(entity:entity!, insertInto: self.context)
            self.purchaseItemManagedObject.name = self.itemManagedObject.name
            self.purchaseItemManagedObject.price = self.itemManagedObject.price
            self.purchaseItemManagedObject.quantity = self.itemManagedObject.quantity
            self.purchaseItemManagedObject.image = self.itemManagedObject.image
            
            do {try self.context.save()}
            catch{ print("Core data Error: contect does not save")}
            
            self.addRedDotAtTabBarItemIndex(index: 1)
            
            
        })
        
        let shareAction = UITableViewRowAction(style:UITableViewRowActionStyle.default, title: "Share",handler:{
            (action, indexPath) -> Void in
            
            self.itemManagedObject =  self.fetchResultController.object(at: indexPath) as! ShoppingItem
            let defaultText = "I really like this: " + self.itemManagedObject.name!
            
            // let imageName = String(describing: self.itemManagedObject.image)
            // let imageToShare = UIImage(named: imageName)
            
            let activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
        
            
        })
        
        shareAction.backgroundColor = UIColor(red: 48.0/255.0, green: 173.0/255.0,
                                              blue: 99.0/255.0, alpha: 1.0)
        return [addHistoryAction, shareAction]
        
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
        if segue.identifier == "updateSegue" {
            
            print("prepare method")
            
            // get indexpath
            let indexPath = itemTableView.indexPath(for: sender as! UITableViewCell)
        
                
            
            // extract from frc the managedObject at indexPath
            itemManagedObject = fetchResultController.object(at: indexPath!) as! ShoppingItem
            
            // get the destination
            
            let navContoller = segue.destination as! UINavigationController
            let destination = navContoller.topViewController as! AddItemTableViewController
            
            // push data
            destination.itemManagedObject = itemManagedObject
            
        }
    }
    
    
    
    // add a red dot in the tab bar item
    func addRedDotAtTabBarItemIndex(index: Int) {
        
        for subview in tabBarController!.tabBar.subviews {
                if subview.tag == 1314 {
                    subview.removeFromSuperview()
                    break
                }
        }
        let RedDotRadius: CGFloat = 5
        let RedDotDiameter = RedDotRadius * 2
        
        let TopMargin:CGFloat = 5
        let TabBarItemCount = CGFloat(self.tabBarController!.tabBar.items!.count)
        let HalfItemWidth = view.bounds.width / (TabBarItemCount * 2)
        let  xOffset = HalfItemWidth * CGFloat(index * 2 + 1)
        let imageHalfWidth: CGFloat = (self.tabBarController!.tabBar.items![index] ).selectedImage!.size.width / 2
        let redDot = UIView(frame: CGRect(x: xOffset + imageHalfWidth, y: TopMargin, width: RedDotDiameter, height: RedDotDiameter))
        
        redDot.tag = 1314
        redDot.backgroundColor = UIColor.red
        redDot.layer.cornerRadius = RedDotRadius
        
        self.tabBarController?.tabBar.addSubview(redDot)
    }
 
 
    

}

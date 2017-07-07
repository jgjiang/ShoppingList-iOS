//
//  AddItemTableViewController.swift
//  ShoppingList
//
//  Created by Tony on 24/03/2017.
//  Copyright © 2017 Tony. All rights reserved.
//

import UIKit
import CoreData

class AddItemTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    
    // core data stuff
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemManagedObject:ShoppingItem! = nil
    
    // save item method
    
    func saveItem()  {
        // have the entity open
        let entity = NSEntityDescription.entity(forEntityName: "ShoppingItem", in: context)
        
        
        // create a shoppingitem obj
        itemManagedObject = ShoppingItem(entity:entity!, insertInto: context)
        
        
        // give the fields for this person
        itemManagedObject.name = nameTextField.text
        itemManagedObject.price = priceTextField.text
        itemManagedObject.quantity = Int32(quantityTextField.text!)!
        
         if let itemPhoto = photoImageView.image {
            if let imageData = UIImagePNGRepresentation(itemPhoto){
                itemManagedObject.image = NSData(data: imageData)
            }
        }
        
        
        // save it
        do {try context.save()}
        catch{ print("Core data Error: contect does not save")}
        
    }
    
    func updateItem()  {
        
        /// give the fields for this person
        itemManagedObject.name = nameTextField.text
        itemManagedObject.price = priceTextField.text
        itemManagedObject.quantity = Int32(quantityTextField.text!)!
        
        if let itemPhoto = photoImageView.image {
            if let imageData = UIImagePNGRepresentation(itemPhoto){
                itemManagedObject.image = NSData(data: imageData)
            }
        }
        
        // save it
        do {try context.save()}
        catch{ print("Core data Error: contect does not save")}
        
    }
    
    
    @IBAction func saveAction(_ sender: Any) {
        
        if nameTextField.text == "" || priceTextField.text == "" || quantityTextField.text == "" {
            let alertController = UIAlertController(title: "Warning!!!", message: "Please Input All the Fields", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }
        
        if nameTextField.text != "" && priceTextField.text != "" && quantityTextField.text != ""{
            
            if itemManagedObject == nil {
                saveItem()
            } else{
                updateItem()
                
            }
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
       
        
        if itemManagedObject != nil{
            
            nameTextField.text = itemManagedObject.name
            priceTextField.text = itemManagedObject.price
            quantityTextField.text = String(itemManagedObject.quantity)
            photoImageView.image = UIImage(data: itemManagedObject.image as! Data)
            
        } else{
            print("itemManagedObject == nil")
        }
        
        
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as?
            UIImage {
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
        }
        
        let leadingConstraint = NSLayoutConstraint(item: photoImageView, attribute:
            NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem:
            photoImageView.superview, attribute: NSLayoutAttribute.leading, multiplier: 1,
                                      constant: 0)
        leadingConstraint.isActive = true
        
        let trailingConstraint = NSLayoutConstraint(item: photoImageView,attribute: NSLayoutAttribute.trailing,
                                                    relatedBy: NSLayoutRelation.equal,
                                                    toItem: photoImageView.superview, attribute: NSLayoutAttribute.trailing,
                                                    multiplier: 1, constant: 0)
        trailingConstraint.isActive = true
        
        let topConstraint = NSLayoutConstraint(item: photoImageView, attribute:
            NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem:
            photoImageView.superview, attribute: NSLayoutAttribute.top, multiplier: 1,
                                      constant: 0)
        topConstraint.isActive = true
        let bottomConstraint = NSLayoutConstraint(item: photoImageView, attribute:
            NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem:
            photoImageView.superview, attribute: NSLayoutAttribute.bottom, multiplier: 1,
                                      constant: 0)
        bottomConstraint.isActive = true
        
        
        
        dismiss(animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

  

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  PurchaseItemTableViewCell.swift
//  ShoppingList
//
//  Created by Tony on 04/04/2017.
//  Copyright © 2017 Tony. All rights reserved.
//

import UIKit


protocol PurchaseItemCellDelegate {
    func plusPressed(cell: PurchaseItemTableViewCell)
    func minusPressed(cell: PurchaseItemTableViewCell)
}


class PurchaseItemTableViewCell: UITableViewCell {
    var delegate: PurchaseItemCellDelegate?
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
     

    
    // var itemManagedObject:PurchaseItem! = nil
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBAction func plusAction(_ sender: UIButton) {
       self.delegate?.plusPressed(cell: self)
        
        
    }
    
    @IBAction func minusAction(_ sender: UIButton) {
        self.delegate?.minusPressed(cell: self)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
   
    
}





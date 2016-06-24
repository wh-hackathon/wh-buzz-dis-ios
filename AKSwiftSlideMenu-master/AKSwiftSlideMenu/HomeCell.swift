//
//  HomeCell.swift
//  AKSwiftSlideMenu
//
//  Created by ArtiC on 6/23/16.
//  Copyright © 2016 Kode. All rights reserved.
//

import Foundation
import UIKit

class HomeCell: UITableViewCell
{
    // MARK: Properties
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var callBtn: UIButton!
   
    @IBAction func callBtnAction(sender: AnyObject)
    {
        
    }
    
    @IBAction func likebtnAction(sender: AnyObject)
    {
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

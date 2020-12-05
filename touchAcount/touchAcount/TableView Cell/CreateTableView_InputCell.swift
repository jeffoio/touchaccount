//
//  CeateTableView+InputCell.swift
//  touchAcount
//
//  Created by TakHyun Jung on 2020/12/05.
//

import UIKit

class CreateTableView_InputCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.contentView.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

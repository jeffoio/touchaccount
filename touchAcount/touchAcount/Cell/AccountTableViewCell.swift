//
//  AccountTableViewCell.swift
//  touchAcount
//
//  Created by TakHyun Jung on 2020/12/03.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var bankImageView: UIImageView!
    @IBOutlet weak var holderLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    private var chevron = UIImage(named: "indicator.png")
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.editingAccessoryType = .disclosureIndicator
        self.editingAccessoryView = UIImageView(image: chevron!)
        
    }
    
    func configure(account: Account) {
        self.roundView.layer.cornerRadius = 10
        bankImageView.image = UIImage(named: account.bank)
        holderLabel.text = account.holder
        numberLabel.text = account.number
        infoLabel.text = account.info
    }
    
}

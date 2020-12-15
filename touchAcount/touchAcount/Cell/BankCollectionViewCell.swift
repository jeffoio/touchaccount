//
//  BankCollectionViewCell.swift
//  touchAcount
//
//  Created by TakHyun Jung on 2020/12/14.
//

import UIKit

class BankCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: BankCollectionViewCell.self)
    @IBOutlet weak var bankTitleLabel: UILabel!
}

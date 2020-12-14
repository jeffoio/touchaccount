//
//  CeateTableView+InputCell.swift
//  touchAcount
//
//  Created by TakHyun Jung on 2020/12/05.
//

import UIKit

@objc protocol CreateTableViewDelegate: NSObjectProtocol {
    func valueChangeInTextField(cell: CreateTableView_InputCell)
}

class CreateTableView_InputCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    var delegate: CreateTableViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.responds(to: #selector(CreateTableViewDelegate.valueChangeInTextField(cell:)))
        delegate?.valueChangeInTextField(cell: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


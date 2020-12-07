//
//  Account.swift
//  touchAcount
//
//  Created by TakHyun Jung on 2020/12/07.
//

import Foundation

class Account {
    var bank: Bank
    var number: String
    var holder: String
    var info: String
    
    init(bank: Bank, number: String, holder: String, info: String) {
        self.bank = bank
        self.number = number
        self.holder = holder
        self.info = info
    }
}

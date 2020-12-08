//
//  Account.swift
//  touchAcount
//
//  Created by TakHyun Jung on 2020/12/07.
//

import RealmSwift

class Account: Object {
    @objc dynamic var bank = ""
    @objc dynamic var number = ""
    @objc dynamic var holder = ""
    @objc dynamic var info = ""
    
}

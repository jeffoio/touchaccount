//
//  ViewController.swift
//  touchAcount
//
//  Created by TakHyun Jung on 2020/12/03.
//

import UIKit

class MainViewController: UIViewController {
    
    var accounts: [Account] = []
    @IBOutlet weak var accountTableView: UITableView!
    @IBOutlet weak var addAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfigure()
        addAccountButton.layer.cornerRadius = 10
        
        for bank in Bank.allCases {
            accounts.append(Account(bank: bank, number: "43180201318825", holder: "정택현", info: "월세"))
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        accountTableView.reloadData()
    }
    
    func tableViewConfigure() {
        accountTableView.delegate = self
        accountTableView.dataSource = self
        let nib = UINib(nibName: "\(AccountTableViewCell.self)", bundle: nil)
        accountTableView.register(nib, forCellReuseIdentifier: "AccountTableViewCell")
        accountTableView.rowHeight = 65
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK:- Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at: indexPath) as! AccountTableViewCell
        
        // 클립보드로 복사
        UIPasteboard.general.string = cell.numberLabel.text!
        
        // Segue
        //self.performSegue(withIdentifier: "BankSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            accounts.remove(at: indexPath.row)
            accountTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//            if editingStyle == .delete {
//                // Delete the row from the data source
//                tableView.deleteRows(at: [indexPath], with: .fade)
//            } else if editingStyle == .insert {
//                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//            }
//        }
//
    
    //MARK:- DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = accountTableView.dequeueReusableCell(withIdentifier: "AccountTableViewCell") as? AccountTableViewCell else { fatalError("Error  AccountTableViewCell Cell Init ")}
        let account = accounts[indexPath.row]
        
        cell.bankImageView.image = UIImage(named: "\(account.bank)")
        cell.holderLabel.text = account.holder
        cell.infoLabel.text = account.info
        
        
        return cell
    }
    
}


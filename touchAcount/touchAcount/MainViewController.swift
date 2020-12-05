//
//  ViewController.swift
//  touchAcount
//
//  Created by TakHyun Jung on 2020/12/03.
//

import UIKit

class MainViewController: UIViewController {
    
    var num = 3
    @IBOutlet weak var accountTableView: UITableView!
    @IBOutlet weak var addAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfigure()
        addAccountButton.layer.cornerRadius = 10
    }
    
    func tableViewConfigure() {
        accountTableView.delegate = self
        accountTableView.dataSource = self
        let nib = UINib(nibName: "\(AccountTableViewCell.self)", bundle: nil)
        accountTableView.register(nib, forCellReuseIdentifier: "AccountTableViewCell")
        accountTableView.rowHeight = 65
    }
    
    @IBAction func editTableView(_ sender: UIBarButtonItem) {
        if accountTableView.isEditing {
            accountTableView.isEditing = false
        } else {
            accountTableView.isEditing = true
        }
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
            num -= 1
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
        return num
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = accountTableView.dequeueReusableCell(withIdentifier: "AccountTableViewCell") as? AccountTableViewCell else { fatalError("Error  AccountTableViewCell Cell Init ")}
        return cell
    }
    
}


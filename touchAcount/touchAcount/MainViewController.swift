//
//  ViewController.swift
//  touchAcount
//
//  Created by TakHyun Jung on 2020/12/03.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    let realm = try! Realm()
    var notificationToken: NotificationToken?
    var accounts: Results<Account> {
        get {
            return realm.objects(Account.self)
        }
    }
    
    @IBOutlet weak var accountTableView: UITableView!
    @IBOutlet weak var addAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfigure()
        registerNotification()
        addAccountButton.layer.cornerRadius = 10
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        notificationToken?.invalidate()
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    func tableViewConfigure() {
        accountTableView.delegate = self
        accountTableView.dataSource = self
        let nib = UINib(nibName: "\(AccountTableViewCell.self)", bundle: nil)
        accountTableView.register(nib, forCellReuseIdentifier: "AccountTableViewCell")
        accountTableView.rowHeight = 65
    }
    
    func registerNotification() {
        notificationToken = accounts.observe { change in
            self.accountTableView.reloadData()
        }
    }
    
    func deleteAccount(index: Int) {
        // do catch 수정
        do {
            try? self.realm.write {
                realm.delete(accounts[index])
            }
        } catch {
            print("Error")
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
            accountTableView.deleteRows(at: [indexPath], with: .fade)
            deleteAccount(index: indexPath.row)
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
        cell.configure(account: account)
        return cell
    }
    
}


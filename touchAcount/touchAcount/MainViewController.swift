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
    var seletedRow: Int?
    var accounts: Results<Account> {
        get {
            return realm.objects(Account.self)
        }
    }
    
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var accountTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfigure()
        registerNotification()
        navigationBarConfigure()
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
    
    func navigationBarConfigure() {
        let navigationnAppearance = UINavigationBarAppearance()
        navigationnAppearance.configureWithTransparentBackground()
        self.navigationController?.navigationBar.standardAppearance = navigationnAppearance
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
    
    
    @IBAction func touchedEditButton(_ sender: UIBarButtonItem) {
        if sender.title == "편집" {
            accountTableView.isEditing = true
            sender.title = "완료"
        } else {
            accountTableView.isEditing = false
            sender.title = "편집"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editAccount" {
            if let destVC = segue.destination as? CreateAccountViewController {
                if accountTableView.isEditing {
                    destVC.editingRow = seletedRow
                }
            }
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK:- Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let cell = tableView.cellForRow(at: indexPath) as? AccountTableViewCell else { fatalError("AccountTableViewCell Error")}
        
        if tableView.isEditing {
            seletedRow = indexPath.row
            performSegue(withIdentifier: "editAccount", sender: self)
        } else {
            // 클립보드로 복사
            UIPasteboard.general.string = cell.numberLabel.text!
            performSegue(withIdentifier: "selectBank", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteAccount(index: indexPath.row)
        }
    }
    
    //MARK:- DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let account = accounts[indexPath.row]
        guard let cell = accountTableView.dequeueReusableCell(withIdentifier: "AccountTableViewCell") as? AccountTableViewCell else { fatalError("Error  AccountTableViewCell Cell Init ")}
        
        cell.configure(account: account)
        
        return cell
    }
    
}

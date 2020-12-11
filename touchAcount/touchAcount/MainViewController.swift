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
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK:- Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let cell = tableView.cellForRow(at: indexPath) as? AccountTableViewCell else { fatalError("AccountTableViewCell Error")}
        
        if tableView.isEditing {
            performSegue(withIdentifier: "editAccount", sender: self)
        } else {
            // 클립보드로 복사
            UIPasteboard.general.string = cell.numberLabel.text!
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

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

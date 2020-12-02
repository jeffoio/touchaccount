//
//  ViewController.swift
//  touchAcount
//
//  Created by TakHyun Jung on 2020/12/03.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var accountTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountTableView.delegate = self
        accountTableView.dataSource = self
        let nib = UINib(nibName: "\(AccountTableViewCell.self)", bundle: nil)
        accountTableView.register(nib, forCellReuseIdentifier: "AccountTableViewCell")
        accountTableView.rowHeight = 65
    }
    
    // This function is called before the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        //let secondViewController = segue.destination as! SecondViewController
        
        // set a variable in the second view controller with the data to pass
        //secondViewController.receivedData = "hello"
    }
    @IBAction func showEditing(_ sender: UIBarButtonItem) {
        if accountTableView.isEditing {
            accountTableView.isEditing = false
            editBarButton.title = "편집"
        } else {
            accountTableView.isEditing = true
            editBarButton.title = "완료"
        }
    }
    
    @IBAction func addAcount(_ sender: UIBarButtonItem) {
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
        self.performSegue(withIdentifier: "BankSegue", sender: self)
    }
    
    //MARK:- DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = accountTableView.dequeueReusableCell(withIdentifier: "AccountTableViewCell") as? AccountTableViewCell else { fatalError("Error  AccountTableViewCell Cell Init ")}
        return cell
    }
}


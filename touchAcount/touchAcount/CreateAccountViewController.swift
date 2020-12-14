//
//  CreateAccountViewController.swift
//  touchAcount
//
//  Created by TakHyun Jung on 2020/12/03.
//

import UIKit
import RealmSwift

class CreateAccountViewController: UIViewController {
    
    let realm = try! Realm()
    var inputCategory: [String] = []
    var newAccount = Account()
    var editingRow: Int?
    var accounts: Results<Account> {
        get {
            return realm.objects(Account.self)
        }
    }
    
    @IBOutlet weak var createTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountConfigure()
        tableViewConfigure()
        registerForKeyboardNotifications()
        saveButton.layer.cornerRadius = 10
    }
    
    // 화면 터치시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func tableViewConfigure() {
        inputCategory = ["은행","계좌번호","예금주","계좌정보"]
        createTableView.delegate = self
        createTableView.dataSource = self
        let inputNib = UINib(nibName: "\(CreateTableView_InputCell.self)", bundle: nil)
        createTableView.register(inputNib, forCellReuseIdentifier: "InputCell")
        createTableView.keyboardDismissMode = .onDrag
        createTableView.rowHeight = 45
    }
    
    func accountConfigure() {
        guard let editingRow = editingRow else { return }
        let editAccount = accounts[editingRow]
        newAccount.bank = editAccount.bank
        newAccount.holder = editAccount.holder
        newAccount.number = editAccount.number
        newAccount.info = editAccount.info
    }
    
    //MARK:- Notification
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // UIKeyboardDidShow 노티피케이션을 받으면 호출된다.
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.height, right: 0.0)
        createTableView.contentInset = contentInsets
        createTableView.scrollIndicatorInsets = contentInsets
    }

    // UIKeyboardWillHide 노티피케이션을 받으면 호출된다.
    @objc func keyboardWillHide(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        createTableView.contentInset = contentInsets
        createTableView.scrollIndicatorInsets = contentInsets
    }
    
    //MARK:- IBAction
    @IBAction func cancelBarButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        if !newAccount.bank.isEmpty , !newAccount.number.isEmpty , !newAccount.holder.isEmpty {
            if editingRow == nil {
                try! realm.write {
                    realm.add(newAccount)
                }
            } else {
                guard let editingRow = editingRow else { return }
                let editAccount = accounts[editingRow]
                let predicateQuery = NSPredicate(format: "number == %@", editAccount.number)
                let account = realm.objects(Account.self).filter(predicateQuery).first
                try! realm.write {
                    account!.bank = newAccount.bank
                    account!.holder = newAccount.holder
                    account!.info = newAccount.info
                    account!.number = newAccount.number
                }
            }
        } else {
            print("save err")
        }

        dismiss(animated: true, completion: nil)
    }
    
}

//MARK:- PickerView
extension CreateAccountViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Bank.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Bank.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        newAccount.bank = Bank.allCases[row].rawValue
        createTableView.reloadData()
        let nextIndexPath = IndexPath(row: 0, section: 1)
        guard let nextCell = createTableView.cellForRow(at: nextIndexPath) as? CreateTableView_InputCell else { return }
        nextCell.textField.becomeFirstResponder()
    }
    
}


//MARK:- TableView
extension CreateAccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return inputCategory[section]
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = createTableView.dequeueReusableCell(withIdentifier: "InputCell") as? CreateTableView_InputCell else { fatalError("Error  InputCell Init ")}
        let pickerView = UIPickerView()
        pickerView.delegate = self
        let barAccessory = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        barAccessory.barStyle = .default
        barAccessory.isTranslucent = true
        
        switch indexPath.section {
        case 0:
            cell.textField.text = newAccount.bank.isEmpty ? "미선택" : newAccount.bank
            cell.textField.tintColor = .clear
            cell.textField.inputView = pickerView
        case 1:
            let nextButton = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(numberDone))
            barAccessory.setItems([space, nextButton], animated: false)
            cell.textField.inputAccessoryView = barAccessory
            cell.textField.keyboardType = .numberPad
            cell.textField.placeholder = "숫자만 입력해주세요"
            cell.textField.text = newAccount.number
        case 2:
            let nextButton = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(nameDone))
            barAccessory.setItems([space, nextButton], animated: false)
            cell.textField.inputAccessoryView = barAccessory
            cell.textField.placeholder = "받으실분 성함을 입력해주세요"
            cell.textField.text = newAccount.holder
        case 3:
            let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(infoDone))
            barAccessory.setItems([space, doneButton], animated: false)
            cell.textField.inputAccessoryView = barAccessory
            cell.textField.placeholder = "예시) 동행복권"
            cell.textField.text = newAccount.info
        default:
            fatalError("Section Error")
        }
        cell.delegate = (self as CreateTableViewDelegate)
        return cell
    
    }

    @objc func numberDone() {
        let nextIndexPath = IndexPath(row: 0, section: 2)
        guard let nextCell = createTableView.cellForRow(at: nextIndexPath) as? CreateTableView_InputCell else { return }
        nextCell.textField.becomeFirstResponder()
    }
    
    @objc func nameDone() {
        let nextIndexPath = IndexPath(row: 0, section: 3)
        guard let nextCell = createTableView.cellForRow(at: nextIndexPath) as? CreateTableView_InputCell else { return }
        nextCell.textField.becomeFirstResponder()
    }
    
    @objc func infoDone() {
        let curIndexPath = IndexPath(row: 0, section: 3)
        guard let curCell = createTableView.cellForRow(at: curIndexPath) as? CreateTableView_InputCell else { return }
        curCell.textField.resignFirstResponder()
    }
}


extension CreateAccountViewController: CreateTableViewDelegate {
    func valueChangeInTextField(cell: CreateTableView_InputCell) {
        guard let input = cell.textField.text else { return }
        if input == "" { return }
        switch createTableView.indexPath(for: cell)?.section {
        case 0:
            return
        case 1:
            self.newAccount.number = input
        case 2:
            self.newAccount.holder = input
        case 3:
            self.newAccount.info = input
        default:
            fatalError("section Error")
        }
    }
}

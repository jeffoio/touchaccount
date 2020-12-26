//
//  BankViewController.swift
//  touchAcount
//
//  Created by TakHyun Jung on 2020/12/03.
//

import UIKit

class BankViewController: UIViewController, UICollectionViewDelegate {
    enum Section {
        case main
    }
    @IBOutlet weak var containerView: UIView!
    var dataSource: UICollectionViewDiffableDataSource<Section, BankApp>!
    var possibleBankApp: [BankApp] = [.kakaobank,.supertoss,.kbBank, .sbankmoasign , .kbbiz, .wooriwonbiz]
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        self.containerView.layer.cornerRadius = 10
        self.containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        collectionView.delegate = self
        collectionView.collectionViewLayout = configureLayout()
        //checkPossibleBankApp()
        configureDataSource()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showToast(message: "계좌가 복사되었습니다")
    }
    
    func showToast(message : String) {
        let sideSpace:CGFloat = 70
        let toastLabel = UILabel(frame: CGRect(x: sideSpace, y: 10, width: view.frame.size.width-2*sideSpace, height: 35))
        
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.containerView.addSubview(toastLabel)
        UIView.animate(withDuration: 1.5, delay: 0.1, options: .curveLinear, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    // 화면 터치
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        dismiss(animated: true, completion: nil)
    }
    
    func checkPossibleBankApp() {
        for bank in BankApp.allCases {
            guard let url = URL(string: "\(bank)://" ) else { return }
            if UIApplication.shared.canOpenURL(url) {
                possibleBankApp.append(bank)
            }
        }
    }
    
    func configureLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.15))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, BankApp>(collectionView: self.collectionView)  { (collectionView, indexPath, number ) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BankCollectionViewCell.reuseIdentifier, for: indexPath) as? BankCollectionViewCell else { fatalError("Error Cell init")}
            cell.bankTitleLabel.text = self.possibleBankApp[indexPath.item].rawValue
            //cell.backgroundColor = .white
            cell.layer.cornerRadius = 5
            return cell
        }
        
        var initialSnapShot = NSDiffableDataSourceSnapshot<Section, BankApp>()
        initialSnapShot.appendSections([.main])
        initialSnapShot.appendItems(possibleBankApp, toSection: .main)
        
        dataSource.apply(initialSnapShot, animatingDifferences: false, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //은행 연결
        let bank = "\(possibleBankApp[indexPath.item])://"
        guard let url = URL(string: bank ) else { return }
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    //MARK:- IBAction
    @IBAction func cancelBarButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}


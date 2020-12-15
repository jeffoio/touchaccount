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
    var dataSource: UICollectionViewDiffableDataSource<Section, BankApp>!
    var possibleBankApp: [BankApp] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.collectionViewLayout = configureLayout()
        checkPossibleBankApp()
        configureDataSource()
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


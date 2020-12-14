//
//  BankViewController.swift
//  touchAcount
//
//  Created by TakHyun Jung on 2020/12/03.
//

import UIKit

class BankViewController: UIViewController {
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Bank>!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = configureLayout()
        configureDataSource()
        
        //은행 연결
        let kakaobank = "smartbank://"
        guard let url = URL(string: kakaobank) else { return }
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
//        if let url = URL(string: "com.wooribank.smart.npib://")
//        {
//                   if #available(iOS 10.0, *) {
//                      UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                   }
//                   else {
//                         if UIApplication.shared.canOpenURL(url as URL) {
//                            UIApplication.shared.openURL(url as URL)
//                        }
//                   }
//        }
    }
    
    func configureLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.13))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }

    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Bank>(collectionView: self.collectionView)  { (collectionView, indexPath, number ) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BankCollectionViewCell.reuseIdentifier, for: indexPath) as? BankCollectionViewCell else { fatalError("Error Cell init")}
            cell.bankImageView.image = UIImage(named: Bank.allCases[indexPath.item].rawValue)
            cell.bankTitleLabel.text = Bank.allCases[indexPath.item].rawValue
            cell.backgroundColor = .white
            cell.layer.cornerRadius = 10
            return cell
        }
        
        var initialSnapShot = NSDiffableDataSourceSnapshot<Section, Bank>()
        initialSnapShot.appendSections([.main])
        initialSnapShot.appendItems(Bank.allCases, toSection: .main)
        
        dataSource.apply(initialSnapShot, animatingDifferences: false, completion: nil)
    }
    
    //MARK:- IBAction
    @IBAction func cancelBarButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

//
//  SelectNumberViewController.swift
//  Math_Tables
//
//  Created by Lê Trần Trọng Tín on 2/22/19.
//  Copyright © 2019 Lê Trần Trọng Tín. All rights reserved.
//

import UIKit

class SelectNumberViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var cvSelect: UICollectionView!
    
    var items = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cvSelect.dataSource = self
        cvSelect.delegate = self
        let nib = UINib(nibName: "ResultCollectionViewCell", bundle: nil)
        cvSelect.register(nib, forCellWithReuseIdentifier: "cvcellId")
        
        items += 1...20
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cvSelect.dequeueReusableCell(withReuseIdentifier: "cvcellId", for: indexPath) as! ResultCollectionViewCell
        cell.lbResult.text = String(items[indexPath.item])
        cell.lbResult.layer.cornerRadius = 5
        cell.lbResult.backgroundColor = #colorLiteral(red: 0, green: 0.6039215686, blue: 0.3490196078, alpha: 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let learnVC = LearnViewController(nibName: "LearnViewController", bundle: nil)
        learnVC.number = indexPath.item + 1
        present(learnVC, animated: true, completion: nil)
    }
    
    let spacing = 10
    let itemPerRow = 5
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = cvSelect.contentInset.left + cvSelect.contentInset.right
        let cgSpacing = CGFloat(spacing)
        let cgItemPerRow = CGFloat(itemPerRow)
        
        let totalCellWidth = cvSelect.bounds.width - padding - cgSpacing * (cgItemPerRow - 1)
        let cellWidth = totalCellWidth / cgItemPerRow
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(spacing)
    }
}

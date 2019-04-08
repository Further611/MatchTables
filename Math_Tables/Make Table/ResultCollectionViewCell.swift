//
//  ResultCollectionViewCell.swift
//  Math_Tables
//
//  Created by Lê Trần Trọng Tín on 2/25/19.
//  Copyright © 2019 Lê Trần Trọng Tín. All rights reserved.
//

import UIKit

class ResultCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lbResult: UILabel!
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lbResult.backgroundColor = UIColor.flatYellowDark
    }

}

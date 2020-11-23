//
//  AutomatonCollectionViewCell.swift
//  Rule30
//
//  Created by Brandon G. Smith on 11/20/20.
//

import UIKit

class AutomatonCollectionViewCell: UICollectionViewCell {
    let livingColor: UIColor = .darkGray
    let deadColor: UIColor = .white
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    func setLiving(_ isLiving: Bool = false) {
        self.backgroundColor = isLiving ? livingColor:deadColor
    }
}

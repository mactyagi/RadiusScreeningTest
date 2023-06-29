//
//  CollectionViewCell.swift
//  RadiusScreeningTest
//
//  Created by Manu on 28/06/23.
//

import UIKit

class FacilityCollectionViewCell: UICollectionViewCell {
    static let identifier = "FacilityCollectionViewCell"
    @IBOutlet weak var pullDownButton: UIButton!
    
    @IBOutlet weak var arrowImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        arrowImageView.layer.cornerRadius = 5
        pullDownButton.superview?.layer.cornerRadius = 10
        pullDownButton.superview?.layer.borderWidth = 2
    }
    
    @IBAction func pulldownButtonPressed(_ sender: UIButton) {
    }
    
}

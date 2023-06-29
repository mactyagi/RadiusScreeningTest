//
//  ViewController.swift
//  RadiusScreeningTest
//
//  Created by Manu on 28/06/23.
//

import UIKit

class FacilityViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK: - variables
    var viewModel: FacilityViewModel!
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FacilityViewModel()
        getFacilityData()
        setupCollectionView()
    }
    
    //MARK: - functions
    func setupCollectionView(){
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: FacilityCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: FacilityCollectionViewCell.identifier)
    }
    
    func getFacilityData(){
        viewModel.getFacilityDataFromAPI {
            self.collectionView.reloadData()
        }
    }
    
}

//MARK: - Collection data source
extension FacilityViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FacilityCollectionViewCell.identifier, for: indexPath) as! FacilityCollectionViewCell
        let facility = viewModel.exclusiveFacilities[indexPath.row]
        
        
        cell.pullDownButton.menu = UIMenu(title: facility.facilityName,  children: getMenuChildrenFromOption(options: facility.options, button: cell.pullDownButton, row: indexPath.row))
        cell.pullDownButton.setTitle(facility.facilityName, for: .normal)
        cell.pullDownButton.configuration?.subtitle = facility.selectedOption?.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.exclusiveFacilities.count
    }
    
    // helper function to produce action on selection of option
    func getMenuChildrenFromOption(options: [Option], button: UIButton, row: Int) -> [UIAction]{
        var actions: [UIAction] = []
        for option in options {
            actions.append(UIAction(title: option.name!, image: UIImage(named: option.icon!)?.withTintColor(Color.appColor), state: .off,handler: { action in
                self.viewModel.exclusiveFacilities[row].selectedOption = option
                self.viewModel.checkForExclusion()
                self.collectionView.reloadData()
            }))
        }
        return actions
    }
}



//
//  ViewModel.swift
//  RadiusScreeningTest
//
//  Created by Manu on 28/06/23.
//

import Foundation

class FacilityViewModel{
    //MARK: - variables
    private var facilities = [Facility]()
    private var arrayOfExclusions = [[Exclusion]]()
    var exclusiveFacilities = [ExclusiveFacility]() //data source of the collectionView
    
}


//MARK: - Functions
extension FacilityViewModel{
    
    // This func is check for exclusion and made changes in the data source
    func checkForExclusion(){
        
        //Refill the option without exclusion
        for (index,facility) in facilities.enumerated(){
            exclusiveFacilities[index].options = facility.options
        }
        
        // find the exclusion for every selected facility and filter the option based on exclusion
        for exclusiveFacility in exclusiveFacilities{
            guard let selectedOption = exclusiveFacility.selectedOption else { continue }
            let exclusion = exclusionFunction(currentFacilityId: exclusiveFacility.facilityId, currentOptionId: selectedOption.id!)
            addExclusiveFacility(with: exclusion)
        }
        
    }
    
    
    // Get the facility from the API
    func getFacilityDataFromAPI(completion: @escaping () -> Void){
        NetworkManager().getFacilityData {  dataModel, error in
            guard error == nil else {
                completion()
                return
            }
            self.facilities = dataModel?.facilities ?? []
            self.arrayOfExclusions = dataModel!.exclusions
            self.addExclusiveFacilityWithoutExclusion()
            completion()
        }
    }
    
    // This func is used to return the exclusion of current selected Facility and option.
    private func exclusionFunction(currentFacilityId: String, currentOptionId: String) -> [Exclusion]{
        var returnExclusion = [Exclusion]()
        for exclusions in arrayOfExclusions{
            var exclusionFlag = false
            var tempExclusion = [Exclusion]()
            for exclusion in exclusions{
                if exclusion.facilityID == currentFacilityId && exclusion.optionsID == currentOptionId{
                    exclusionFlag = true
                    continue
                }
                tempExclusion.append(exclusion)
            }
            if exclusionFlag{
                returnExclusion += tempExclusion
            }
        }
        return returnExclusion
    }
    
//    change the data Source according to the exclusion
    private func addExclusiveFacility(with exclusions: [Exclusion]){
        for (index, facility) in exclusiveFacilities.enumerated() {
            var options = facility.options
            for exclusion in exclusions {
                if facility.facilityId == exclusion.facilityID{
                    options = facility.options.filter { option in
                        option.id != exclusion.optionsID
                    }
                }
            }
            exclusiveFacilities[index].options = options
        }
    }
    
    
//    add data source without any exclusion
    private func addExclusiveFacilityWithoutExclusion(){
        exclusiveFacilities = []
        for facility in facilities {
            exclusiveFacilities.append(ExclusiveFacility(facilityName: facility.name!, facilityId: facility.facilityID!, options: facility.options))
        }
    }
}

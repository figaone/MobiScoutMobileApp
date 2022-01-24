//
//  LibraryTableViewCell.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 10/23/21.
//

import UIKit

class LibraryTableViewCell: UITableViewCell {

//    @IBOutlet weak var nameOfVideoLabel: UILabel!
    
    @IBOutlet weak var dateDataCollected: UILabel!
    @IBOutlet weak var nameOfVideoLabel: UILabel!
    
    @IBOutlet weak var driverMonitorVideoLabel: UILabel!
    
    @IBOutlet weak var driverMOnitorPreButtonOulet: UIButton!
    //    @IBOutlet weak var previewButtonOutlet: UIButton!
    
    @IBOutlet weak var sensorDataLabel: UILabel!
    @IBOutlet weak var sensorDataButOpenLabel: UIButton!
    
    @IBOutlet weak var healthDataLabel: UILabel!
    
    @IBOutlet weak var healthDataButtonLabel: UIButton!
    
    @IBOutlet weak var obdDataLabel: UILabel!
    
    @IBOutlet weak var obdDataOpenButtonLabel: UIButton!
    
    @IBOutlet weak var previewButtonOutlet: UIButton!
    
//    @IBOutlet weak var previewButton: UIButton!
    @IBOutlet weak var previewButton: UIButton!
    
    @IBOutlet weak var creationDateLabel: UILabel!
    
    @IBOutlet weak var sizeOfVideoLabel: UILabel!
    
    @IBOutlet weak var uploadButtonOutlet: UIButton!
    
    @IBOutlet weak var deleteButtonOutlet: UIButton!
    
    @IBOutlet weak var uploadButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

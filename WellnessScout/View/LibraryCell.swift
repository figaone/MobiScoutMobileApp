//
//  LibraryCell.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 3/8/22.
//

import UIKit

class LibraryCell: UITableViewCell {

    @IBOutlet weak var dateDataCollected: UILabel!
    @IBOutlet weak var driverMonitorVideoLabel: UILabel!
    @IBOutlet weak var driverMOnitorPreButtonOulet: UIButton!
    @IBOutlet weak var nameOfVideoLabel: UILabel!
    @IBOutlet weak var previewButton: UIButton!
    @IBOutlet weak var sensorDataLabel: UILabel!
    @IBOutlet weak var sensorDataButOpenLabel: UIButton!
    @IBOutlet weak var healthDataLabel: UILabel!
    @IBOutlet weak var healthDataButtonLabel: UIButton!
    @IBOutlet weak var obdDataLabel: UILabel!
    @IBOutlet weak var obdDataOpenButtonLabel: UIButton!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var uploadButtonOutlet: UIButton!
    @IBOutlet weak var sizeOfVideoLabel: UILabel!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var driverMonitorStackCell: UIStackView!
    @IBOutlet weak var roadViewStackCell: UIStackView!
    @IBOutlet weak var sensorDataStackCell: UIStackView!
    @IBOutlet weak var healthDataStackCell: UIStackView!
    @IBOutlet weak var obdDataStackCell: UIStackView!
    @IBOutlet weak var uploadButtonStackCell: UIStackView!
    @IBOutlet weak var deleteButtonStackCell: UIStackView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  CitiesNameCell.swift
//  WeatherProject
//
//  Created by Elizaveta on 26.11.2020.
//

import UIKit

class CitiesNameCell: UITableViewCell
{

    @IBOutlet weak var cityTemp: UILabel!
    @IBOutlet weak var cityName: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

}

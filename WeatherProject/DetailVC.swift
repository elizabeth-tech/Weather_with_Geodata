//
//  DetailVC.swift
//  WeatherProject
//
//  Created by Elizaveta on 26.11.2020.
//

import UIKit
import Alamofire
import SwiftyJSON

class DetailVC: UIViewController
{
    var cityName = ""
    var lat = 0.0
    var lon = 0.0

    @IBOutlet weak var detailCityName: UILabel!
    @IBOutlet weak var detailCityTemp: UILabel!
    @IBOutlet weak var detailDay: UILabel!
    @IBOutlet weak var detailData: UILabel!
    @IBOutlet weak var detailIcon: UIImageView!
    @IBOutlet weak var detailLat: UILabel!
    @IBOutlet weak var detailLon: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Магия градиента
        let colorTop = UIColor(red: 89/255, green: 156/255, blue: 169/255, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        currentWeather(city: cityName)
    }
    
    func currentWeather(city: String)
    {
        let token = "c1bf2799ffba4b6491c123531201811"
        let url = "https://api.weatherapi.com/v1/current.json?key=\(token)&q=\(city)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                   
        // Метод отправки - get
        AF.request(url!, method: .get).validate().responseJSON
        {
            response in switch response.result
            {
                // Если успешно, то записываем response.result в value
                case .success(let value):
                    let json = JSON(value)
                           
                    //let name = json["location"]["name"].stringValue
                    let temp = json["current"]["temp_c"].doubleValue
                    let iconURL = "https:\(json["current"]["condition"]["icon"].stringValue)" // Иконка
                    let myDateString = json["location"]["localtime"].stringValue // Дата
                    self.lat = json["location"]["lat"].doubleValue // Широта
                    self.lon = json["location"]["lon"].doubleValue // Долгота
         
                    // Получение из строки только даты
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                    let myDate = dateFormatter.date(from: myDateString)
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    let date = dateFormatter.string(from: myDate!)
                    
                    // Получение из строки только дня недели
                    let weekday = dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: myDate!)]

                    self.detailCityName.text = self.cityName
                    self.detailCityTemp.text = String(temp) + " °С"
                    self.detailIcon.image = UIImage(data: try! Data(contentsOf: URL(string: iconURL)!))
                    self.detailData.text = date
                    self.detailDay.text = weekday
                    self.detailLat.text = String(self.lat)
                    self.detailLon.text = String(self.lon)
                    
                // Если ошибка при получении данных
                case .failure(let error):
                    print(error)
            }
        }

    }
    
    // Передаем на экран с картой данные широты и долготы
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? MapVC
        {
            vc.lat = self.lat
            vc.lon = self.lon
        }
    }
    
    @IBAction func showMap(_ sender: Any)
    {
        performSegue(withIdentifier: "goToMap", sender: self)
    }
    

}

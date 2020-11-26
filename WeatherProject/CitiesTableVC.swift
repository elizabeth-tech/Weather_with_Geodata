//
//  CitiesTableVC.swift
//  WeatherProject
//
//  Created by Elizaveta on 26.11.2020.
//

import UIKit
import Alamofire
import SwiftyJSON

class CitiesTableVC: UITableViewController
{
    let token = "c1bf2799ffba4b6491c123531201811"
    @IBOutlet var cityTableView: UITableView!
    
    var cityName = ""
    struct Cities
    {
        var cityName = ""
        var cityTemp = 0.0
    }
    var citiesTempArray: [Cities] = []
    var array = ["Новосибирск", "Москва", "Тула", "Мурманск"]
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        cityTableView.delegate = self
        cityTableView.dataSource = self
        
        // Заполняем дефолтными городами таблицу
        for item in array
        {
            currentWeather(city: item)
        }
    }
    
    func currentWeather(city: String)
    {
        let url = "https://api.weatherapi.com/v1/current.json?key=\(token)&q=\(city)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                   
        // Метод отправки - get
        AF.request(url!, method: .get).validate().responseJSON
        {
            response in switch response.result
            {
                // Если успешно, то записываем response.result в value
                case .success(let value):
                    let json = JSON(value)
                           
                    let name = json["location"]["name"].stringValue
                    let temp = json["current"]["temp_c"].doubleValue
                    
                    self.citiesTempArray.append(Cities(cityName: name, cityTemp: temp))
                    self.cityTableView.reloadData()
    
                // Если ошибка при получении данных
                case .failure(let error):
                    print(error)
            }
        }

    }
    
    @IBAction func addCityAction(_ sender: UIButton)
    {
        let alert = UIAlertController(title: "Добавить", message: "Введите название города", preferredStyle: .alert)
        alert.addTextField
        {
            (textFieldAlert) in textFieldAlert.placeholder = "Тверь"
        }
                
        // Создание кнопок ОК и отмена
        let ok = UIAlertAction(title: "Добавить", style: .default)
        {
            (action) in
            let name = alert.textFields![0].text
            self.currentWeather(city: name!)
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
                
        // Добавляем кнопки на алерт
        alert.addAction(ok)
        alert.addAction(cancel)
                
        // Показываем наш алерт
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return citiesTempArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CitiesNameCell
        
        cell.cityName.text = citiesTempArray[indexPath.row].cityName
        cell.cityTemp.text = String(citiesTempArray[indexPath.row].cityTemp) + " °С"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        cityName = citiesTempArray[indexPath.row].cityName
        performSegue(withIdentifier: "goDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? DetailVC
        {
            vc.cityName = cityName
        }
    }


}

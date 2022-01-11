//
//  CountryPickerViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 07/01/22.
//

import UIKit
import SDWebImage

class CountryPickerViewController: UIViewController {

    //MARK: - Properties -
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    var countryList: [CountryList]?
    var filteredArray: [CountryList]?
    var countries: [(letter: Character, countries: [CountryList])] = []
    var sections : [String] = []
    typealias CB = (_ id: CountryList?) -> ()
    var comp:CB?
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tblView.delegate = self
        tblView.dataSource = self
        searchTextField.delegate = self
        self.getCountryListApi()
    }
    
    //MARK: - Selectors -
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions -
    
    func data(){
        countries = Dictionary(grouping: filteredArray ?? []) { (country) -> Character in
            if let char = country.country?.first {
                return char
            }
            return "".first!
        }
        .map { (key: Character, value: [CountryList]) -> (letter: Character, countries: [CountryList]) in
            sections.removeAll()
            sections.append("\(key)")
            return (letter: key, countries: value)
        }
        .sorted { (left, right) -> Bool in
            left.letter < right.letter
        }
        print(sections)
    }

}

//MARK: - Extensions -

//MARK: Api Call
extension CountryPickerViewController {
    // Get Country List Api
    func getCountryListApi() {
        showLoading()
        APIHelper.getCountryListApi(parameters: [:]) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response.data
                self.countryList = data.arrayValue.map({(CountryList(json: $0))})
                self.filteredArray = self.countryList
                self.data()
                self.tblView.reloadData()
            }
        }
    }
}

//MARK: Table View SetUp
extension CountryPickerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries[section].countries.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let value = "\(countries[section].letter)"
        return value
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryPickerTableViewCell", for: indexPath) as! CountryPickerTableViewCell
        let countryList = countries[indexPath.section].countries[indexPath.row]
        cell.countryNameLbl.text = countryList.country
        cell.countryCodeLbl.text = countryList.countryCode
        cell.flagImgView.sd_setImage(with: URL(string: countryList.countryFlag ?? ""), placeholderImage: UIImage(named: "IN.png"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        let countryList = countries[indexPath.section].countries[indexPath.row]
        guard let cb = comp else { return }
        cb(countryList)
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: TextField Delegate Methods
extension CountryPickerViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        var finalString = ""
        if string.isEmpty {
            finalString = String(finalString.dropLast())
            filteredArray = countryList
        } else {
            finalString = textField.text! + string
            self.filteredArray = self.countryList?.filter({
                ($0.country ?? "").localizedCaseInsensitiveContains(finalString) || ($0.countryCode ?? "").localizedCaseInsensitiveContains(finalString)
            })
        }
        self.data()
        self.tblView.reloadData()
        return true
    }
}

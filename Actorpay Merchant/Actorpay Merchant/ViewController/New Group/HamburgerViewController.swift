//
//  HamburgerViewController.swift
//  HamburgerMenu
//
//  Created by Kashyap on 13/11/20.
//

import UIKit


struct SideMenuModel {
    var icon: UIImage?
    var title: String
}

protocol HamburgerViewControllerDelegate {
    func hideHamburgerMenu()
}
class HamburgerViewController: UIViewController {

    var delegate : HamburgerViewControllerDelegate?
    
    @IBOutlet var sideMenuTableView: UITableView! {
        didSet {
            self.sideMenuTableView.delegate = self
            self.sideMenuTableView.dataSource = self
            self.sideMenuTableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.sideMenuTableView.separatorStyle = .none
        }
    }
    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var mainBackgroundView: UIView!
    
    var menu: [SideMenuModel] = [
        SideMenuModel(icon: UIImage(named: "home"), title: "My Profile"),
        SideMenuModel(icon: UIImage(named: "music.note"), title: "Reports"),
        SideMenuModel(icon: UIImage(named: "film.fill"), title: "Cancel/Raise Dispute"),
        SideMenuModel(icon: UIImage(named: "book.fill"), title: "Merchant & sub Merchant"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
        
    @IBAction func clickedOnButton(_ sender: Any) {
        self.delegate?.hideHamburgerMenu()
    }
}

// MARK: - UITableViewDelegate

extension HamburgerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

// MARK: - UITableViewDataSource

extension HamburgerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as? SideMenuCell else { fatalError("xib doesn't exist") }

        cell.iconImageView.image = self.menu[indexPath.row].icon
        cell.titleLabel.text = self.menu[indexPath.row].title

        // Highlighted color
        let myCustomSelectionColorView = UIView()
        cell.selectedBackgroundView = myCustomSelectionColorView
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.delegate?.selectedCell(indexPath.row)
    }
}

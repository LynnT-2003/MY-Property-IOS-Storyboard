//
//  ProfileViewController.swift
//  FinalPracticeApp-1
//
//  Created by Lynn Thit Nyi Nyi on 1/10/2567 BE.
//

import UIKit


class ProfileViewController: UIViewController {
    
    let profileMenuOptions = ["Account", "Favorites", "Settings", "Logout"]

    @IBOutlet weak var profileTableViewCell: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the appearance and title for the navigation bar
        let appearance = UINavigationBarAppearance()
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Profile"
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell")
        cell?.textLabel?.text = profileMenuOptions[indexPath.row]
//        cell?.textLabel?.text = "Example text in a cell"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch profileMenuOptions[indexPath.row] {
        case "Favorites":
            let favoritesPage = UIStoryboard(name: "Main", bundle: .main)
                .instantiateViewController(withIdentifier: "favoritesPage") as! FavoritesViewController
            navigationController?.pushViewController(favoritesPage, animated: true)
            
//        case "Logout":
//            handleLogout() // Implement your logout functionality here
        default:
            break
        
        }
    }
    
}

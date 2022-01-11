//
//  ProfileViewController.swift
//  MessengerApp
//
//  Created by administrator on 04/01/2022.
//

import UIKit

import FirebaseAuth
class ProfileViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!

    var data = [ProfileViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ProfileTableViewCell.self,
                           forCellReuseIdentifier: ProfileTableViewCell.identifier)

        data.append(ProfileViewModel(viewModelType: .info,
                                     title: "Name: \(UserDefaults.standard.value(forKey:"name") as? String ?? "No Name")",
                                     handler: nil))
        data.append(ProfileViewModel(viewModelType: .info,
                                     title: "Email: \(UserDefaults.standard.value(forKey:"email") as? String ?? "No Email")",
                                     handler: nil))
        data.append(ProfileViewModel(viewModelType: .logout, title: "Log Out", handler: { [weak self] in

            guard let strongSelf = self else {
                return
            }

            let actionSheet = UIAlertController(title: "",
                                          message: "",
                                          preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Log Out",
                                          style: .destructive,
                                          handler: { [weak self] _ in

                                            guard let strongSelf = self else {
                                                return
                                            }

                                            UserDefaults.standard.setValue(nil, forKey: "email")
                                            UserDefaults.standard.setValue(nil, forKey: "name")

                                            // Log Out facebook
                                           // FBSDKLoginKit.LoginManager().logOut()

                                            do {
                                                try FirebaseAuth.Auth.auth().signOut()

                                                let vc = LoginViewController()
                                                let nav = UINavigationController(rootViewController: vc)
                                                nav.modalPresentationStyle = .fullScreen
                                                strongSelf.present(nav, animated: true)
                                            }
                                            catch {
                                                print("Failed to log out")
                                            }

            }))

            actionSheet.addAction(UIAlertAction(title: "Cancel",
                                                style: .cancel,
                                                handler: nil))

            strongSelf.present(actionSheet, animated: true)
        }))

        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = createTableHeader()
    }


    func createTableHeader() -> UIView? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }

        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let filename = safeEmail + "_profile_picture.png"
        let path = "images/"+filename

        let headerView = UIView(frame: CGRect(x: 0,
                                        y: 0,
                                        width: self.view.width,
                                        height: 300))

        headerView.backgroundColor = .link

        let imageView = UIImageView(frame: CGRect(x: (headerView.width-150) / 2,
                                                  y: 75,
                                                  width: 150,
                                                  height: 150))
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.width/2
        headerView.addSubview(imageView)

        StorageManager.shared.downloadURL(for: path, completion: { result in
            switch result {
            case .success(let url):
                imageView.sd_setImage(with: url, completed: nil)
            case .failure(let error):
                print("Failed to get download url: \(error)")
            }
        })

        return headerView
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier,
                                                 for: indexPath) as! ProfileTableViewCell
        cell.setUp(with: viewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.row].handler?()
    }
}

class ProfileTableViewCell: UITableViewCell {

    static let identifier = "ProfileTableViewCell"

    public func setUp(with viewModel: ProfileViewModel) {
        self.textLabel?.text = viewModel.title
        switch viewModel.viewModelType {
        case .info:
            textLabel?.textAlignment = .left
            selectionStyle = .none
        case .logout:
            textLabel?.textColor = .red
            textLabel?.textAlignment = .center
        }
    }

}

//
//    @IBOutlet var tableView: UITableView!
//
//    let data = ["Log Out"]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        tableView.delegate = self
//        tableView.dataSource = self
//
//    }
//}
//extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data.count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = data[indexPath.row]
//        cell.textLabel?.textAlignment = .center
//        cell.textLabel?.textColor = .red
//        return cell
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true) // unhighlight the cell
//        // logout the user
//
//        // show alert
//
//        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
//
//        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { [weak self] _ in
//            // action that is fired once selected
//
//            guard let strongSelf = self else {
//                return
//            }
//
//
//
//            do {
//                try FirebaseAuth.Auth.auth().signOut()
//
//                // present login view controller
//                let vc = LoginViewController()
//                let nav = UINavigationController(rootViewController: vc)
//                nav.modalPresentationStyle = .fullScreen
//                strongSelf.present(nav, animated: true)
//            }
//            catch {
//                print("failed to logout")
//            }
//
//        }))
//
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        present(actionSheet, animated: true)
//    }
//
//}

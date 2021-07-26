//  MIT License

//  Copyright (c) 2017 Haik Aslanyan

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

class AccountVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Properties
    /// Storyboard Replacement Step
    /// - Replace IBOutlets with init methods
    let tableView: UITableView = UITableView(frame: .zero)
    
    // @IBOutlet weak var tableView: UITableView!
    let menuTitles = ["History", "My Videos", "Notifications", "Watch Later"]
    var items = 5
    var user = User.init(name: "Loading", profilePic: UIImage(), backgroundImage: UIImage(), playlists: [Playlist]())
    var lastContentOffset: CGFloat = 0.0

    /// Storyboard Replacement Step
    /// - Add required init methods
    // MARK: - Init - replace storyboard
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        applyAnchors()
        customization()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: -  ViewController Lifecylce
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
    }

    // MARK: - Replace storyboard
    /// Storyboard Replacement Step
    /// Apply constraints programmatically
    private func applyAnchors() {
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor,
                         padding: .init(top: -80, left: 0, bottom: 0, right: 0),
                         size: .zero)
    }
    
    //MARK: Methods
    func customization() {
        /// Storyboard Replacement Step
        /// - Register cell classes
        tableView.register(AccountMenuCell.self, forCellReuseIdentifier: CellIdentifiers.menu)
        tableView.register(AccountHeaderCell.self, forCellReuseIdentifier: CellIdentifiers.header)
        tableView.register(AccountPlaylistCell.self, forCellReuseIdentifier: CellIdentifiers.playlists)

        self.tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 300

        User.fetchData { [weak self] response in
            guard let weakSelf = self else {
                return
            }
            weakSelf.user = response
            weakSelf.items += response.playlists.count
            weakSelf.tableView.reloadData()
        }

        /// Storyboard Replacement Step
        /// - Datasource and delegate previously set on storyboard
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: Delegates
    /// Storyboard Replacement Step
    /// Reconfigured TableView to have three sections
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }

    /// Storyboard Replacement Step
    /// Reconfigured TableView to have three sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 4
        default:
            return self.user.playlists.count
        }
    }

    /// Storyboard Replacement Step
    /// Reconfigured TableView to have three sections
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 120
        case 1:
            return 50
        default:
            return 70
        }
    }

    /// Storyboard Replacement Step
    /// Reconfigured TableView to have three sections
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.header, for: indexPath) as! AccountHeaderCell
            cell.nameLabel.text = self.user.name
            cell.profilePicImageView.image = self.user.profilePic
            cell.backgroundImageView.image = self.user.backgroundImage
            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.menu, for: indexPath) as! AccountMenuCell
            cell.menuTitlesLabel.text = self.menuTitles[indexPath.row]
            cell.menuIconImageView.image = UIImage.init(named: self.menuTitles[indexPath.row])
           return cell

        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.playlists, for: indexPath) as! AccountPlaylistCell
            cell.picImageView.image = self.user.playlists[indexPath.row].pic
            cell.titleLabel.text = self.user.playlists[indexPath.row].title
            cell.numberOfVideosLabel.text = "\(self.user.playlists[indexPath.row].numberOfVideos) videos"
            return cell
        }

//        switch indexPath.row {
//        case 0:
//            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.header, for: indexPath) as! AccountHeaderCell
//            cell.nameLabel.text = self.user.name
//            cell.profilePicImageView.image = self.user.profilePic
//            cell.backgroundImageView.image = self.user.backgroundImage
//            return cell
//        case 1...4:
//            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.menu, for: indexPath) as! AccountMenuCell
//            cell.menuTitlesLabel.text = self.menuTitles[indexPath.row - 1]
//            cell.menuIconImageView.image = UIImage.init(named: self.menuTitles[indexPath.row - 1])
//           return cell
//        case 5...self.items:
//            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.playlists, for: indexPath) as! AccountPlaylistCell
//
//
//            cell.picImageView.image = self.user.playlists[indexPath.row - 5].pic
//            cell.titleLabel.text = self.user.playlists[indexPath.row - 5].title
//            cell.numberOfVideosLabel.text = "\(self.user.playlists[indexPath.row - 5].numberOfVideos) videos"
//            return cell
//        default:
//            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.menu, for: indexPath) as! AccountMenuCell
//            return cell
//        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            NotificationCenter.default.post(name: NSNotification.Name("hide"), object: false)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name("hide"), object: true)
        }
    }
}

class AccountHeaderCell: UITableViewCell {
    /// Storyboard Replacement Step
    /// - Replace IBOutlets with init methods
    let nameLabel: UILabel = UILabel(text: "Name", font: .systemFont(ofSize: 15), textColor: .white, textAlignment: .left)
    let profilePicImageView: UIImageView = UIImageView(frame: .zero)
    let backgroundImageView: UIImageView = UIImageView(frame: .zero)
    
//    @IBOutlet weak var name: UILabel!
//    @IBOutlet weak var profilePic: UIImageView!
//    @IBOutlet weak var backgroundImage: UIImageView!

    /// Storyboard Replacement Step
    /// - Add required init methods
    // MARK: - Init - replace storyboard
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        applyAnchors()
        customization()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyAnchors()
        customization()
    }

    // MARK: - UI - replacing storyboard
    /// Storyboard Replacement Step
    /// Apply constraints programmatically
    private func applyAnchors() {
        addSubviews(backgroundImageView, profilePicImageView, nameLabel)
        backgroundImageView.anchor(top: topAnchor, leading: leadingAnchor,
                                   bottom: nil, trailing: trailingAnchor,
                                   padding: .init(top: 0, left: 0, bottom: 0, right: 0),
                                   size: .init(width: 0, height: 120))

        profilePicImageView.anchor(top: nil, leading: leadingAnchor,
                                   bottom: nil, trailing: nil,
                                   padding: .init(top: 0, left: videoMargin, bottom: 0, right: 0),
                                   size: .init(width: 50, height: 50))
        profilePicImageView.centerYToSuperview()

        nameLabel.anchor(top: profilePicImageView.bottomAnchor, leading: profilePicImageView.leadingAnchor,
                         bottom: nil, trailing: trailingAnchor,
                         padding: .init(top: 5, left: 0, bottom: 0, right: 0),
                         size: .init(width: 0, height: 16))
    }

    // MARK: - Customization
    func customization()  {
        self.profilePicImageView.layer.cornerRadius = 25
        self.profilePicImageView.clipsToBounds = true
    }
}

class AccountMenuCell: UITableViewCell {
    /// Storyboard Replacement Step
    /// - Replace IBOutlets with init methods
    let menuIconImageView: UIImageView = UIImageView(frame: .zero)
    let menuTitlesLabel: UILabel = UILabel(text: "Menu Item", font: .systemFont(ofSize: 17), textColor: .black)

//    @IBOutlet weak var menuIcon: UIImageView!
//    @IBOutlet weak var menuTitles: UILabel!

    /// Storyboard Replacement Step
    /// - Add line separator view programmaticatically
    let lineSeparatorView = UIView()

    /// Storyboard Replacement Step
    /// - Add required init methods
    // MARK: - Init - replace storyboard
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        applyAnchors()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI - replacing storyboard
    /// Storyboard Replacement Step
    /// Apply constraints programmatically
    private func applyAnchors() {
        addSubviews(menuIconImageView, menuTitlesLabel, lineSeparatorView)
        menuIconImageView.anchor(top: topAnchor, leading: leadingAnchor,
                                 bottom: nil, trailing: nil,
                                 padding: .init(top: videoMargin, left: videoMargin, bottom: 0, right: 0),
                                 size: .init(width: 20, height: 20))

        menuTitlesLabel.anchor(top: topAnchor, leading: menuIconImageView.trailingAnchor,
                               bottom: nil, trailing: trailingAnchor,
                               padding: .init(top: videoMargin, left: defaultPadding, bottom: 0, right: 0),
                               size: .init(width: 0, height: 20))

        lineSeparatorView.anchor(top: nil, leading: leadingAnchor,
                                 bottom: bottomAnchor, trailing: trailingAnchor,
                                 padding: .zero, size: .init(width: 0, height: 1))
    }
}

class AccountPlaylistCell: UITableViewCell {
    let picImageView: UIImageView = UIImageView(frame: .zero)
    let titleLabel: UILabel = UILabel(text: "Title", font: .systemFont(ofSize: 16), textColor: .black)
    let numberOfVideosLabel: UILabel = UILabel(text: "Description", font: .systemFont(ofSize: 12), textColor: .darkGray)
    
//    @IBOutlet weak var pic: UIImageView!
//    @IBOutlet weak var title: UILabel!
//    @IBOutlet weak var numberOfVideos: UILabel!
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        applyAnchors()
        customization()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.picImageView.image = UIImage.init(named: "emptyTumbnail")
        self.titleLabel.text = nil
        self.numberOfVideosLabel.text = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        applyAnchors()
        self.customization()
    }

    // MARK: - UI - replacing storyboard
    private func applyAnchors() {
        addSubviews(picImageView, titleLabel, numberOfVideosLabel)

        picImageView.anchor(top: topAnchor, leading: leadingAnchor,
                            bottom: nil, trailing: nil,
                            padding: .init(top: 10, left: 10, bottom: 0, right: 0),
                            size: .init(width: 40, height: 40))

        titleLabel.anchor(top: topAnchor, leading: picImageView.trailingAnchor,
                          bottom: nil, trailing: trailingAnchor,
                          padding: .init(top: 10, left: defaultPadding, bottom: 0, right: defaultPadding),
                          size: .init(width: 0, height: 21))

        numberOfVideosLabel.anchor(top: titleLabel.bottomAnchor, leading: picImageView.trailingAnchor,
                                   bottom: nil, trailing: trailingAnchor,
                                   padding: .init(top: 0, left: defaultPadding, bottom: 0, right: defaultPadding),
                                   size: .init(width: 0, height: 17))
    }

    private func customization()  {
        self.picImageView.layer.cornerRadius = 5
        self.picImageView.clipsToBounds = true
    }
}

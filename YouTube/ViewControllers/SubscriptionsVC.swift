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

class SubscriptionsVC: HomeVC {
    /// Storyboard Replacement Step
    /// Reconfigured TableView to have two sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    /// Storyboard Replacement Step
    /// Reconfigured TableView to have two sections
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return videos.count
        }
    }

    /// Storyboard Replacement Step
    /// Reconfigured TableView to have two sections
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.subscriptions) as! SubscriptionsCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.video) as! VideoCell
            cell.set(video: self.videos[indexPath.row])
            return cell
        }
    }

    /// Storyboard Replacement Step
    /// Reconfigured TableView to have two sections
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 80
        default:
            return 310
        }
    }
}

//TableView Custom Classes
class SubscriptionsCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    /// Storyboard Replacement Step
    /// - Replace IBOutlets with init methods
    var collectionView: UICollectionView!
    // @IBOutlet weak var collectionView: UICollectionView!

    var channels = [Channel]()

    // MARK: - Init - replace storyboard
    /// Storyboard Replacement Step
    /// - Add required init methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        customization()
        applyAnchors()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        applyAnchors()
        self.customization()
    }

    /// Storyboard Replacement Step
    /// Apply constraints programmatically
    private func applyAnchors() {
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, leading: leadingAnchor,
                              bottom: nil, trailing: trailingAnchor,
                              padding: .init(top: 15, left: 0, bottom: 14.5, right: 0),
                              size: .init(width: 0, height: 50))
    }

    func customization() {
        /// Storyboard Replacement Step
        /// - Create UICollectionViewFlowLayout for collection view
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.scrollDirection = .horizontal

        /// Storyboard Replacement Step
        /// - Initialize CollectionView
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)

        /// Storyboard Replacement Step
        /// - Register collection view cell class
        collectionView.register(SubscriptionsCVCell.self, forCellWithReuseIdentifier: CellIdentifiers.subscriptionsCV)

        /// Storyboard Replacement Step
        /// - CollectionView datasource and delegates previously set in storyboard
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        Channel.fetchData { [weak self] channels in
            guard let weakSelf = self else {
                return
            }
            weakSelf.channels = channels
            weakSelf.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.channels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.subscriptionsCV, for: indexPath) as! SubscriptionsCVCell
        cell.channelPicImageView.image = self.channels[indexPath.row].image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 50, height: 50)
    }
}

class SubscriptionsCVCell: UICollectionViewCell {
    /// Storyboard Replacement Step
    /// - Replace IBOutlets with init methods
    // @IBOutlet weak var channelPic: UIImageView!
    let channelPicImageView: UIImageView = UIImageView(frame: .zero)

    /// Storyboard Replacement Step
    /// - Add required init methods
    // MARK: - Init - replace storyboard
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyAnchors()
        customization()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        channelPicImageView.image = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        applyAnchors()
        self.customization()
    }

    /// Storyboard Replacement Step
    /// Apply constraints programmatically
    private func applyAnchors() {
        addSubview(channelPicImageView)
        channelPicImageView.fillSuperview()
    }
    
    func customization() {
        self.channelPicImageView.layer.cornerRadius = 25
        self.channelPicImageView.clipsToBounds = true
    }
}

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

class TabBarView: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //MARK: Properties
    /// Storyboard Replacement Step
    /// - Replace IBOutlets with init methods
    var collectionView: UICollectionView!
    let whiteBar = UIView(frame: .zero)
    // @IBOutlet weak var collectionView: UICollectionView!
    // @IBOutlet weak var whiteBar: UIView!
    var whiteBarLeadingConstraint: NSLayoutConstraint!

    private let tabBarImages = ["home", "trending", "subscriptions", "account"]
    var selectedIndex = 0

    let cellIdentifier = "Cell"

    // MARK: - Init
    /// Storyboard Replacement Step
    /// - Add required init methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: View LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Replace storyboard
    private func configure() {
        backgroundColor = UIColor.rbg(r: 228, g: 34, b: 24)
        whiteBar.backgroundColor = .white

        /// Storyboard Replacement Step
        /// - Create UICollectionViewFlowLayout for collection view
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal

        /// Storyboard Replacement Step
        /// - Initialize CollectionView
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.rbg(r: 228, g: 34, b: 24)

        applyAnchors()
        customization()
    }

    /// Storyboard Replacement Step
    /// Apply constraints programmatically
    private func applyAnchors() {
        addSubviews(collectionView, whiteBar)
        collectionView.fillSuperview()

        let whiteBarWidth: CGFloat = UIScreen.main.bounds.width / 4.0
        whiteBar.anchor(top: nil, leading: nil,
                        bottom: collectionView.bottomAnchor, trailing: nil,
                        padding: .zero, size: .init(width: whiteBarWidth, height: 5))

        whiteBarLeadingConstraint = whiteBar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        whiteBarLeadingConstraint.isActive = true
    }
    
    //MARK: Methods
    func customization() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.collectionView.register(TabBarCellCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        self.backgroundColor = UIColor.rbg(r: 228, g: 34, b: 24)
        NotificationCenter.default.addObserver(self, selector: #selector(self.animateMenu(notification:)), name: Notification.Name.init(rawValue: "scrollMenu"), object: nil)
    }
    
    @objc func animateMenu(notification: Notification) {
        if let info = notification.userInfo {
            let userInfo = info as! [String: CGFloat]
            self.whiteBarLeadingConstraint.constant = self.whiteBar.bounds.width * userInfo["length"]!
            self.selectedIndex = Int(round(userInfo["length"]!))
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut]) { [weak self] in
                guard let self = self else { return }

                self.layoutIfNeeded()
            } completion: { [weak self] succes in
                guard let self = self else { return }

                self.collectionView.reloadData()
            }
        }
    }
    
    //MARK: Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tabBarImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! TabBarCellCollectionViewCell
        var imageName = self.tabBarImages[indexPath.row]
        if self.selectedIndex == indexPath.row {
            imageName += "Selected"
        }

        cell.iconImageView.image = UIImage.init(named: imageName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.bounds.width / 4, height: collectionView.bounds.height - 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.selectedIndex != indexPath.row {
            self.selectedIndex = indexPath.row
            NotificationCenter.default.post(name: Notification.Name.init(rawValue: "didSelectMenu"), object: nil, userInfo: ["index": self.selectedIndex])
        }
    }
}

//TabBarCell Class
class TabBarCellCollectionViewCell: UICollectionViewCell {
    /// Storyboard Replacement Step
    /// - Replace IBOutlets with init methods
    let iconImageView: UIImageView = UIImageView(frame: .zero)
    // @IBOutlet weak var icon: UIImageView!

    // MARK: - Init - replace storyboard
    /// Storyboard Replacement Step
    /// - Add required init methods
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
        iconImageView.image = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        applyAnchors()
        self.customization()
    }

    /// Storyboard Replacement Step
    /// Apply constraints programmatically
    private func applyAnchors() {
        addSubview(iconImageView)
        iconImageView.centerInSuperview(size: .init(width: 50, height: 50))
    }

    func customization() {
        iconImageView.contentMode = .scaleAspectFit
    }
}

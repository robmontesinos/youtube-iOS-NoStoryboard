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

class MainVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: Properties
    /// Storyboard Replacement Step
    /// - Replace IBOutlets with init methods
    let tabBarView: TabBarView = TabBarView(frame: .zero)
    var collectionView: UICollectionView!

    // @IBOutlet var tabBarView: TabBarView!
    // @IBOutlet weak var collectionView: UICollectionView!
    var views = [UIView]()

    // MARK: - Init - replace storyboard
    /// Storyboard Replacement Step
    /// - Add required init methods
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: ViewController lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customization()
        self.collectionView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Methods
    func customization()  {
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
        /// - CollectionView datasource and delegates previously set in storyboard
        self.collectionView.dataSource = self
        self.collectionView.delegate = self

        /// Storyboard Replacement Step
        /// - Register collection view cell class
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CellIdentifiers.cell)
        self.collectionView.clipsToBounds = true

        /// Storyboard Replacement Step
        /// - Changed background color to match original design
        // self.view.backgroundColor = UIColor.rbg(r: 228, g: 34, b: 24)
        self.view.backgroundColor = .black
        //CollectionView Setup
        // self.collectionView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        /// Storyboard Replacement Step
        /// - Add CollectionView to view hierarchy
        self.view.addSubview(collectionView)

//        self.collectionView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: (self.view.bounds.height))

        //TabbarView setup
        self.view.addSubview(self.tabBarView)
        /// Storyboard Replacement Step
        /// - Anchor TabBarView with extension
        tabBarView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor,
                          bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor,
                          padding: .zero, size: .init(width: 0, height: 74))

        /// Storyboard Replacement Step
        /// - anchor CollectionView with extension
        collectionView.anchor(top: tabBarView.bottomAnchor, leading: view.leadingAnchor,
                              bottom: view.bottomAnchor, trailing: view.trailingAnchor,
                              padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .zero)

        /// Storyboard Replacement Step
        /// - Replace programmatic constraints approach with anchor method above
//        self.tabBarView.translatesAutoresizingMaskIntoConstraints = false
//        guard let v = self.view else { return }
//        let _ = NSLayoutConstraint.init(item: v, attribute: .top, relatedBy: .equal, toItem: self.tabBarView, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
//        let _ = NSLayoutConstraint.init(item: v, attribute: .left, relatedBy: .equal, toItem: self.tabBarView, attribute: .left, multiplier: 1.0, constant: 0).isActive = true
//        let _ = NSLayoutConstraint.init(item: v, attribute: .right, relatedBy: .equal, toItem: self.tabBarView, attribute: .right, multiplier: 1.0, constant: 0).isActive = true
//        self.tabBarView.heightAnchor.constraint(equalToConstant: 64).isActive = true

        //ViewController init
//        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
//        let trendingVC = self.storyboard?.instantiateViewController(withIdentifier: "TrendingVC")
//        let subscriptionsVC = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionsVC")
//        let accountVC = self.storyboard?.instantiateViewController(withIdentifier: "AccountVC")

        /// Storyboard Replacement Step
        /// - Initialize View Controllers replacing storyboard instantiations above
        let homeVC = HomeVC(nibName: nil, bundle: nil)
        let trendingVC = TrendingVC(nibName: nil, bundle: nil)
        let subscriptionsVC = SubscriptionsVC(nibName: nil, bundle: nil)
        let accountVC = AccountVC(nibName: nil, bundle: nil)

        let viewControllers = [homeVC, trendingVC, subscriptionsVC, accountVC]
        for vc in viewControllers {
            self.addChild(vc)
            vc.didMove(toParent: self)
            vc.view.frame = CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: (self.view.bounds.height - 44))
            self.views.append(vc.view)
        }

        self.collectionView.reloadData()

        //NotificationCenter setup
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollViews(notification:)), name: Notification.Name.init(rawValue: "didSelectMenu"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideBar(notification:)), name: NSNotification.Name("hide"), object: nil)
    }
    
    @objc func scrollViews(notification: Notification) {
        if let info = notification.userInfo {
            let userInfo = info as! [String: Int]
            self.collectionView.scrollToItem(at: IndexPath.init(row: userInfo["index"]!, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    @objc func hideBar(notification: NSNotification)  {
        let state = notification.object as! Bool
        self.navigationController?.setNavigationBarHidden(state, animated: true)
    }
    
    //MARK: Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.views.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.cell, for: indexPath)
        cell.contentView.addSubview(self.views[indexPath.row])
        return cell
    }

    /// Storyboard Replacement Step
    /// - Added itemSize CollectionView delegate method
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = CGSize(width: collectionView.frame.width, height: collectionView.frame.height - 101)
        return itemSize
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       let scrollIndex = scrollView.contentOffset.x / self.view.bounds.width
        NotificationCenter.default.post(name: Notification.Name.init(rawValue: "scrollMenu"), object: nil, userInfo: ["length": scrollIndex])
    }
}

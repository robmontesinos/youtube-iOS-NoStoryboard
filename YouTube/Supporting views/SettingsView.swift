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

class SettingsView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    /// Storyboard Replacement Step
    /// - Replace IBOutlets with init methods
    let tableView = UITableView(frame: .zero)
    let backgroundView: UIView = UIView(frame: .zero)
    var tableViewBottomConstraint: NSLayoutConstraint!

    // @IBOutlet weak var tableView: UITableView!
    // @IBOutlet weak var backgroundView: UIButton!
    // @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!

    let items = ["Settings", "Terms & privacy policy", "Send Feedback", "Help", "Switch Account", "Cancel"]

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
        self.configure()
    }

    // MARK: - Replacing storyboard
    private func configure() {
        applyAnchors()
        customization()
    }

    /// Storyboard Replacement Step
    /// Apply constraints programmatically
    private func applyAnchors() {
        addSubviews(backgroundView, tableView)
        backgroundView.fillSuperview()

        tableView.anchor(top: nil, leading: leadingAnchor,
                         bottom: safeAreaLayoutGuide.bottomAnchor, trailing: trailingAnchor,
                         padding: .init(top: 0, left: 0, bottom: 0, right: 0),
                         size: .init(width: 0, height: 288))

        tableViewBottomConstraint = tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        tableViewBottomConstraint.isActive = true
    }

    //MARK: Methods
    func customization() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.backgroundView.alpha = 0
        self.tableViewBottomConstraint.constant = -self.tableView.bounds.height
        self.layoutIfNeeded()

        // register class
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifiers.cell)
    }
    
    @IBAction func hideSettingsView(_ sender: Any) {
        self.tableViewBottomConstraint.constant = -self.tableView.bounds.height
        UIView.animate(withDuration: 0.3, animations: { 
            self.backgroundView.alpha = 0
            self.layoutIfNeeded()
        }) { _ in
            self.isHidden = true
        }
    }
    
    //MARK: Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.cell, for: indexPath)
        cell.textLabel?.text = self.items[indexPath.row]
        cell.imageView?.image = UIImage.init(named: self.items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.hideSettingsView(self)
    }
}

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

class SearchView: UIView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //MARK: Properties
    /// Storyboard Replacement Step
    /// - Replace IBOutlets with init methods
    let searchButton = UIButton(frame: .zero)
    let tableView: UITableView = UITableView()
    let inputField = UITextField(frame: .zero)

    // @IBOutlet weak var inputField: UITextField!
    // @IBOutlet weak var tableView: UITableView!

    var suggestions = [String]()

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

    //MARK: View lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    // MARK: - Replace storyboard
    private func configure() {
        customization()

        backgroundColor = .lightGray

        tableView.register(SearchCell.self, forCellReuseIdentifier: CellIdentifiers.searchCell)

        inputField.placeholder = "Search on Youtube"
        searchButton.target(forAction: #selector(hideSearchViewRequested), withSender: nil)
        searchButton.imageView?.image = UIImage(named: Images.cancel)

        applyAnchors()
    }

    /// Storyboard Replacement Step
    /// Apply constraints programmatically
    private func applyAnchors() {
        addSubviews(searchButton, inputField, tableView)
        searchButton.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor,
                            bottom: nil, trailing: nil,
                            padding: .init(top: defaultMargin, left: 0, bottom: 0, right: 0),
                            size: .init(width: 48, height: 48))

        inputField.anchor(top: safeAreaLayoutGuide.topAnchor, leading: searchButton.trailingAnchor,
                          bottom: nil, trailing: trailingAnchor,
                          padding: .init(top: defaultMargin, left: defaultPadding, bottom: 0, right: defaultMargin),
                          size: .init(width: 0, height: 48))

        tableView.anchor(top: inputField.bottomAnchor, leading: leadingAnchor,
                         bottom: nil, trailing: trailingAnchor,
                         padding: .init(top: 0, left: 0, bottom: 0, right: 0),
                         size: .init(width: 0, height: 280))
    }
    
    //MARK: Methods
    func customization() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.inputField.delegate = self
    }

    @objc private func hideSearchViewRequested() {
        hideSearchView(searchButton)
    }
    
    @IBAction func hideSearchView(_ sender: Any) {
        self.inputField.text = ""
        self.suggestions.removeAll()
        self.tableView.isHidden = true
        self.inputField.resignFirstResponder()
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { _ in
            self.isHidden = true
        }
    }
    
    //MARK: Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.searchCell, for: indexPath) as! SearchCell
        cell.resultLabel.text = self.suggestions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.inputField.text = self.suggestions[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hideSearchView(self)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = self.inputField.text else {
            self.suggestions.removeAll()
            self.tableView.isHidden = true
            return true
        }
        let netText = text.addingPercentEncoding(withAllowedCharacters: CharacterSet())!
        let url = URL.init(string: "https://api.bing.com/osjson.aspx?query=\(netText)")!
        let _  = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            guard let weakSelf = self else {
                return
            }
            if error == nil {
                if let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) {
                    let data = json as! [Any]
                    DispatchQueue.main.async {
                        weakSelf.suggestions = data[1] as! [String]
                        if weakSelf.suggestions.count > 0 {
                            weakSelf.tableView.reloadData()
                            weakSelf.tableView.isHidden = false
                        } else {
                            weakSelf.tableView.isHidden = true
                        }
                    }
                }
            }
        }).resume()
        return true
    }
}

class SearchCell: UITableViewCell {
    /// Storyboard Replacement Step
    /// - Replace IBOutlets with init methods

    // @IBOutlet weak var resultLabel: UILabel!

    let resultLabel: UILabel = UILabel(text: "", font: .systemFont(ofSize: 17), textColor: .black)

    // MARK: - Init
    /// Storyboard Replacement Step
    /// - Add required init methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        applyAnchors()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        resultLabel.text = nil
    }

    // MARK: - UI - replacing storyboard
    /// Storyboard Replacement Step
    /// Apply constraints programmatically
    private func applyAnchors() {
        addSubview(resultLabel)
        resultLabel.anchor(top: topAnchor, leading: leadingAnchor,
                           bottom: bottomAnchor, trailing: trailingAnchor,
                           padding: .init(top: 0, left: 48, bottom: 0, right: 0),
                           size: .init(width: 0, height: 20))
    }
}

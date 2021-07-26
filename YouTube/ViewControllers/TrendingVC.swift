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

class TrendingVC: HomeVC {
    /// Storyboard Replacement Step
    /// Reconfigured TableView to have two sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

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
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.trending) as! TrendingCell
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
            return 70
        default:
            return 310
        }
    }
}

/// Storyboard Replacement Step
/// Added TrendingCell class
class TrendingCell: UITableViewCell {
    let musicButton: UIButton = UIButton(frame: .zero)
    let newsButton: UIButton = UIButton(frame: .zero)
    let liveButton: UIButton = UIButton(frame: .zero)
    var stackView: UIStackView!

    // MARK: - Init - replace storyboard
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
        customization()
        applyAnchors()
    }

    /// Storyboard Replacement Step
    /// Apply constraints programmatically
    private func applyAnchors() {
        contentView.addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: leadingAnchor,
                         bottom: bottomAnchor, trailing: trailingAnchor,
                         padding: .init(top: 10, left: videoMargin, bottom: 10, right: videoMargin),
                         size: .zero)

    }

    /// Storyboard Replacement Step
    /// Configure controls programmatically
    func customization() {
        let titles: [String] = ["Music", "News", "Live"]
        let imageNames: [String] = [Images.music, Images.news, Images.live]
        let buttons: [UIButton] = [musicButton, newsButton, liveButton]

        for (index,button) in buttons.enumerated() {
            button.setTitle(titles[index], for: .normal)
            button.setBackgroundImage(UIImage(named: imageNames[index]), for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        }

        let buttonSize: CGSize = CGSize(width: 90, height: 50)

        stackView = UIStackView(arrangedSubviews: [musicButton.withSize(buttonSize),
                                                   newsButton.withSize(buttonSize),
                                                   liveButton.withSize(buttonSize)])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
    }
}

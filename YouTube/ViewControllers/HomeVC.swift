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

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate  {
    
    //MARK: - Properties
    /// Storyboard Replacement Step
    /// - Replace IBOutlets with init methods
    let tableView = UITableView(frame: .zero)
    // @IBOutlet weak var tableView: UITableView!
    var videos = [Video]()
    var lastContentOffset: CGFloat = 0.0

    // MARK: - Init - replace storyboard
    /// Storyboard Replacement Step
    /// - Add required init methods
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// Storyboard Replacement Step
    /// - Added View Life Cycle methods to trigger configuration
    //MARK: -  ViewController Lifecylce
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyAnchors()
        customization()
    }

    /// Storyboard Replacement Step
    /// Apply constraints programmatically
    private func applyAnchors() {
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor,
                         padding: .init(top: 0, left: 0, bottom: 30, right: 0),
                         size: .zero)
    }
    
    //MARK: Methods
    func customization() {
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.estimatedRowHeight = 300
        self.tableView.rowHeight = UITableView.automaticDimension

        tableView.clipsToBounds = true

        /// Storyboard Replacement Step
        /// - Register cell classes
        tableView.register(VideoCell.self, forCellReuseIdentifier: CellIdentifiers.video)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifiers.trending)
        tableView.register(SubscriptionsCell.self, forCellReuseIdentifier: CellIdentifiers.subscriptions)
        tableView.register(TrendingCell.self, forCellReuseIdentifier: CellIdentifiers.trending)

        /// Storyboard Replacement Step
        /// - Datasource and delegate previously set on storyboard
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func fetchData() {
        Video.fetchVideos { [weak self] response in
            guard let weakSelf = self else {
                return
            }
            weakSelf.videos = response
            weakSelf.videos.myShuffle()
            weakSelf.tableView.reloadData()
        }
    }
    
    //MARK: Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.video) as! VideoCell
        cell.set(video: self.videos[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name("open"), object: nil)
    }

    /// Storyboard Replacement Step
    /// - Added heightForRow since soryboard was removed
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 310
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            NotificationCenter.default.post(name: NSNotification.Name("hide"), object: false)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name("hide"), object: true)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.lastContentOffset = scrollView.contentOffset.y;
    }
}

//TableView Custom Classes
class VideoCell: UITableViewCell {
    /// Storyboard Replacement Step
    /// - Replace IBOutlets with init methods
    let videoThumbnailImageView: UIImageView = UIImageView(frame: .zero)
    let durationLabel: UILabel = UILabel(text: "0:00", font: .systemFont(ofSize: 14), textColor: .white, textAlignment: .center)
    let channelPicImageView: UIImageView = UIImageView(frame: .zero)
    let videoTitleLabel: UILabel = UILabel(text: "Video Title", font: .systemFont(ofSize: 17), textColor: .black, numberOfLines: 2)
    let videoDescriptionLabel: UILabel = UILabel(text: "Video Description", font: .systemFont(ofSize: 13), textColor: .darkGray, numberOfLines: 0)

    let lineSeparatorView = UIView()

//    @IBOutlet weak var videoThumbnail: UIImageView!
//    @IBOutlet weak var durationLabel: UILabel!
//    @IBOutlet weak var channelPic: UIImageView!
//    @IBOutlet weak var videoTitle: UILabel!
//    @IBOutlet weak var videoDescription: UILabel!

    /// Storyboard Replacement Step
    /// - Add required init methods
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
        self.videoThumbnailImageView.image = UIImage.init(named: "emptyTumbnail")
        self.durationLabel.text = nil
        self.channelPicImageView.image = nil
        self.videoTitleLabel.text = nil
        self.videoDescriptionLabel.text = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        applyAnchors()
        self.customization()
    }

    // MARK: - UI - replacing storyboard
    /// Storyboard Replacement Step
    /// Apply constraints programmatically
    private func applyAnchors() {
        addSubviews(videoThumbnailImageView, durationLabel, channelPicImageView, videoTitleLabel, videoDescriptionLabel, lineSeparatorView)

        let thumbnailHeight: CGFloat = frame.width * (9 / 16)

        videoThumbnailImageView.anchor(top: topAnchor, leading: safeAreaLayoutGuide.leadingAnchor,
                                       bottom: nil, trailing: safeAreaLayoutGuide.trailingAnchor,
                                       padding: .init(top: videoMargin, left: 0, bottom: 0, right: 0),
                                       size: .init(width: 0, height: thumbnailHeight))

        durationLabel.anchor(top: nil, leading: nil,
                             bottom: videoThumbnailImageView.bottomAnchor, trailing: trailingAnchor,
                             padding: .init(top: 0, left: 0, bottom: 5, right: videoMargin),
                             size: .init(width: 60, height: 20))

        channelPicImageView.anchor(top: videoThumbnailImageView.bottomAnchor, leading: leadingAnchor,
                                   bottom: nil, trailing: nil,
                                   padding: .init(top: videoMargin, left: videoMargin,
                                                  bottom: 0, right: 0),
                                   size: .init(width: 48, height: 48))

        videoTitleLabel.anchor(top: videoThumbnailImageView.bottomAnchor, leading: channelPicImageView.trailingAnchor,
                               bottom: nil, trailing: trailingAnchor,
                               padding: .init(top: videoMargin, left: defaultPadding, bottom: 0, right: defaultPadding),
                               size: .init(width: 0, height: 20))

        videoDescriptionLabel.anchor(top: videoTitleLabel.bottomAnchor, leading: channelPicImageView.trailingAnchor,
                                     bottom: nil, trailing: trailingAnchor,
                                     padding: .init(top: videoMargin, left: defaultPadding, bottom: 0, right: defaultPadding),
                                     size: .init(width: 0, height: 17))
    }

    // MARK: - Customization
    func customization()  {
        self.channelPicImageView.layer.cornerRadius = 24
        self.channelPicImageView.clipsToBounds  = true

        self.durationLabel.backgroundColor = .black
        self.durationLabel.alpha = 0.75
        self.durationLabel.layer.borderWidth = 0.5
        self.durationLabel.layer.borderColor = UIColor.white.cgColor
        self.durationLabel.sizeToFit()

        // storyboard replacement modifications
        /// Storyboard Replacement Step
        /// configure views programmatically
        self.videoThumbnailImageView.image = UIImage.init(named: "emptyTumbnail")
        lineSeparatorView.backgroundColor = .darkGray
    }
    
    func set(video: Video)  {
        self.videoThumbnailImageView.image = video.thumbnail
        self.durationLabel.text = " \(video.duration.secondsToFormattedString()) "
        self.durationLabel.layer.borderColor = UIColor.lightGray.cgColor
        self.durationLabel.layer.borderWidth = 1.0
        self.channelPicImageView.image = video.channel.image
        self.videoTitleLabel.text = video.title
        self.videoDescriptionLabel.text = "\(video.channel.name)  • \(video.views.abbreviated) views"
    }
}

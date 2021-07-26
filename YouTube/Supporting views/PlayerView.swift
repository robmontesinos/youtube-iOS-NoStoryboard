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

protocol PlayerVCDelegate {
    func didMinimize()
    func didmaximize()
    func swipeToMinimize(translation: CGFloat, toState: stateOfVC)
    func didEndedSwipe(toState: stateOfVC)
    func setPreferStatusBarHidden(_ preferHidden: Bool)
}

import UIKit
import AVFoundation
class PlayerView: UIView, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    //MARK: Properties
    /// Storyboard Replacement Step
    /// - Replace IBOutlets with init methods
    let tableView: UITableView = UITableView()
    let minimizeButton: UIButton = UIButton(frame: .zero)
    let player: UIView = UIView(frame: .zero)

//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var minimizeButton: UIButton!
//    @IBOutlet weak var player: UIView!

    var video: Video!
    var delegate: PlayerVCDelegate?
    var state = stateOfVC.hidden
    var direction = Direction.none
    var videoPlayer = AVPlayer()

    /// Storyboard Replacement Step
    /// - Add required init methods
    // MARK: - Init
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

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //MARK: Methods
    private func configure() {
        self.customization()
        Video.fetchVideo { [weak self] downloadedVideo in
            guard let weakSelf = self else {
                return
            }
            weakSelf.video = downloadedVideo
            weakSelf.videoPlayer = AVPlayer.init(url: weakSelf.video.videoLink)
            let playerLayer = AVPlayerLayer.init(player: weakSelf.videoPlayer)
            playerLayer.frame = weakSelf.player.frame
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill

            weakSelf.player.layer.addSublayer(playerLayer)
            if weakSelf.state != .hidden {
                weakSelf.videoPlayer.play()
            }
            weakSelf.tableView.reloadData()
        }
    }

    func customization() {
        self.backgroundColor = UIColor.clear
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 90
        self.player.layer.anchorPoint.applying(CGAffineTransform.init(translationX: -0.5, y: -0.5))
        self.tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        self.player.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.tapPlayView)))
        NotificationCenter.default.addObserver(self, selector: #selector(self.tapPlayView), name: NSNotification.Name("open"), object: nil)

        // NEW METHODS TO REPLACE STORYBOARD
        configureControls()
        applyAnchors()
    }

    // MARK: - Setup UI without Storyboard
    /// Storyboard Replacement Step
    /// Apply constraints programmatically
    private func applyAnchors() {
        addSubviews(player, minimizeButton, tableView)
        player.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor,
                      bottom: nil, trailing: trailingAnchor,
                      padding: .init(top: 0, left: 0, bottom: 0, right: 0),
                      size: .init(width: 0, height: self.frame.width * (9 / 16)))

        minimizeButton.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor,
                              bottom: nil, trailing: nil,
                              padding: .init(top: defaultMargin, left: defaultMargin, bottom: 0, right: 0),
                              size: .init(width: 30, height: 30))

        tableView.anchor(top: player.bottomAnchor, leading: leadingAnchor,
                         bottom: safeAreaLayoutGuide.bottomAnchor, trailing: trailingAnchor,
                         padding: .init(top: 0, left: 0, bottom: 0, right: 0),
                         size: .zero)
    }

    /// Storyboard Replacement Step
    /// Configure controls programmatically
    private func configureControls() {
        player.backgroundColor = .black
        minimizeButton.imageView?.image = UIImage(named: Buttons.minimze)
    }
    
    func animate()  {
        switch self.state {
        case .fullScreen:
            UIView.animate(withDuration: 0.3, animations: {
                self.minimizeButton.alpha = 1
                self.tableView.alpha = 1
                self.player.transform = CGAffineTransform.identity
                self.delegate?.setPreferStatusBarHidden(true)
            })
        case .minimized:
            UIView.animate(withDuration: 0.3, animations: {
                self.delegate?.setPreferStatusBarHidden(false)
                self.minimizeButton.alpha = 0
                self.tableView.alpha = 0
                let scale = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
                let trasform = scale.concatenating(CGAffineTransform.init(translationX: -self.player.bounds.width/4, y: -self.player.bounds.height/4))
                self.player.transform = trasform
            })
        default: break
        }
    }
    
    func changeValues(scaleFactor: CGFloat) {
        self.minimizeButton.alpha = 1 - scaleFactor
        self.tableView.alpha = 1 - scaleFactor
        let scale = CGAffineTransform.init(scaleX: (1 - 0.5 * scaleFactor), y: (1 - 0.5 * scaleFactor))
        let trasform = scale.concatenating(CGAffineTransform.init(translationX: -(self.player.bounds.width / 4 * scaleFactor), y: -(self.player.bounds.height / 4 * scaleFactor)))
        self.player.transform = trasform
    }
    
    @objc func tapPlayView()  {
        self.videoPlayer.play()
        self.state = .fullScreen
        self.delegate?.didmaximize()
        self.animate()
    }
    
    @IBAction func minimize(_ sender: UIButton) {
        self.state = .minimized
        self.delegate?.didMinimize()
        self.animate()
    }
    
    @IBAction func minimizeGesture(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            let velocity = sender.velocity(in: nil)
            if abs(velocity.x) < abs(velocity.y) {
                self.direction = .up
            } else {
                self.direction = .left
            }
        }
        var finalState = stateOfVC.fullScreen
        switch self.state {
        case .fullScreen:
            let factor = (abs(sender.translation(in: nil).y) / UIScreen.main.bounds.height)
            self.changeValues(scaleFactor: factor)
            self.delegate?.swipeToMinimize(translation: factor, toState: .minimized)
            finalState = .minimized
        case .minimized:
            if self.direction == .left {
                finalState = .hidden
                let factor: CGFloat = sender.translation(in: nil).x
                self.delegate?.swipeToMinimize(translation: factor, toState: .hidden)
            } else {
                finalState = .fullScreen
                let factor = 1 - (abs(sender.translation(in: nil).y) / UIScreen.main.bounds.height)
                self.changeValues(scaleFactor: factor)
                self.delegate?.swipeToMinimize(translation: factor, toState: .fullScreen)
            }
        default: break
        }
        if sender.state == .ended {
            self.state = finalState
            self.animate()
            self.delegate?.didEndedSwipe(toState: self.state)
            if self.state == .hidden {
                self.videoPlayer.pause()
            }
        }
    }
    
    //MARK: Delegate & dataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.video?.suggestedVideos.count {
            return count + 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Header") as! headerCell
            cell.titleLabel.text = self.video!.title
            cell.viewCountLabel.text = "\(self.video!.views) views"
            cell.likesLabel.text = String(self.video!.likes)
            cell.disLikesLabel.text = String(self.video!.disLikes)
            cell.channelTitleLabel.text = self.video!.channel.name
            cell.channelImageView.image = self.video!.channel.image
            cell.channelImageView.layer.cornerRadius = 25
            cell.channelImageView.clipsToBounds = true
            cell.channelSubscribersLabel.text = "\(self.video!.channel.subscribers) subscribers"
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! videoCell
            cell.nameLabel.text = self.video.suggestedVideos[indexPath.row - 1].channelName
            cell.titleLabel.text = self.video.suggestedVideos[indexPath.row - 1].title
            cell.thumbnailImageView.image = self.video.suggestedVideos[indexPath.row - 1].thumbnail
            return cell
        }
    }
}

class headerCell: UITableViewCell {
    /// Storyboard Replacement Step
    /// - Replace IBOutlets with init methods
    // @IBOutlet weak var channelPic: UIImageView!
    let titleLabel: UILabel = UILabel(text: "Video Title", font: .systemFont(ofSize: 19), textColor: .black)
    let viewCountLabel: UILabel = UILabel(text: "0 views", font: .systemFont(ofSize: 14), textColor: .gray)
    let likesLabel: UILabel = UILabel(text: "0", font: .systemFont(ofSize: 15), textColor: .black, textAlignment: .center)
    let disLikesLabel: UILabel = UILabel(text: "0", font: .systemFont(ofSize: 15), textColor: .black, textAlignment: .center)
    let channelTitleLabel: UILabel = UILabel(text: "Channel Name", font: .systemFont(ofSize: 17), textColor: .black)
    let channelSubscribersLabel: UILabel = UILabel(text: "number of subscribers", font: .systemFont(ofSize: 14), textColor: .gray)
    let channelImageView: UIImageView = UIImageView(frame: .zero)
    let thumbsUpImageView: UIImageView = UIImageView(image: UIImage(named: Images.thumbsUp))
    let thumbsDownImageView: UIImageView = UIImageView(image: UIImage(named: Images.thumbsDown))
    let lineSeparatorView = UIView()
    
//    @IBOutlet weak var title: UILabel!
//    @IBOutlet weak var viewCount: UILabel!
//    @IBOutlet weak var likes: UILabel!
//    @IBOutlet weak var disLikes: UILabel!
//    @IBOutlet weak var channelTitle: UILabel!
//    @IBOutlet weak var channelPic: UIImageView!
//    @IBOutlet weak var channelSubscribers: UILabel!

    /// Storyboard Replacement Step
    /// - Add required init methods
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureControls()
        applyAnchors()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        channelImageView.image = nil
    }

    // MARK: - UI - replacing storyboard
    /// Storyboard Replacement Step
    /// COnfigure controls programmatically
    private func configureControls() {
        lineSeparatorView.backgroundColor = .darkGray
    }

    /// Storyboard Replacement Step
    /// Apply constraints programmatically
    private func applyAnchors() {
        addSubviews(titleLabel, viewCountLabel, likesLabel, disLikesLabel, channelTitleLabel, channelSubscribersLabel, thumbsUpImageView, thumbsDownImageView, channelImageView, lineSeparatorView)

        titleLabel.anchor(top: topAnchor, leading: leadingAnchor,
                          bottom: nil, trailing: trailingAnchor,
                          padding: .init(top: defaultPadding, left: defaultPadding, bottom: 0, right: defaultPadding),
                          size: .init(width: 0, height: 23))

        thumbsUpImageView.anchor(top: nil, leading: leadingAnchor,
                                 bottom: bottomAnchor, trailing: nil,
                                 padding: .init(top: 0, left: defaultPadding, bottom: 13, right: 0),
                                 size: .init(width: 25, height: 25))

        likesLabel.anchor(top: nil, leading: thumbsUpImageView.trailingAnchor,
                          bottom: bottomAnchor, trailing: nil,
                          padding: .init(top: 0, left: defaultPadding, bottom: 13, right: 0),
                          size: .init(width: 25, height: 25))

        thumbsDownImageView.anchor(top: nil, leading: likesLabel.trailingAnchor,
                                   bottom: bottomAnchor, trailing: nil,
                                   padding: .init(top: 0, left: defaultPadding, bottom: 13, right: 0),
                                   size: .init(width: 25, height: 25))

        disLikesLabel.anchor(top: nil, leading: thumbsDownImageView.trailingAnchor,
                             bottom: bottomAnchor, trailing: nil,
                             padding: .init(top: 0, left: defaultPadding, bottom: 13, right: 0),
                             size: .init(width: 25, height: 25))

        viewCountLabel.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor,
                              bottom: thumbsUpImageView.topAnchor, trailing: trailingAnchor,
                              padding: .init(top: 0, left: defaultPadding, bottom: 0, right: defaultPadding),
                              size: .init(width: 25, height: 25))

        lineSeparatorView.anchor(top: thumbsUpImageView.bottomAnchor, leading: leadingAnchor,
                                 bottom: nil, trailing: trailingAnchor,
                                 padding: .init(top: 13, left: 0, bottom: 0, right: 0),
                                 size: .init(width: 0, height: 1))

        channelImageView.anchor(top: lineSeparatorView.bottomAnchor, leading: leadingAnchor,
                                bottom: nil, trailing: nil,
                                padding: .init(top: defaultPadding, left: defaultPadding, bottom: 0, right: 0), size: .init(width: 50, height: 50))

        channelTitleLabel.anchor(top: lineSeparatorView.bottomAnchor, leading: channelImageView.trailingAnchor,
                                 bottom: nil, trailing: trailingAnchor,
                                 padding: .init(top: defaultPadding, left: defaultPadding, bottom: 0, right: 0), size: .init(width: 0, height: 21))

        channelSubscribersLabel.anchor(top: channelTitleLabel.bottomAnchor, leading: channelImageView.trailingAnchor,
                                       bottom: nil, trailing: trailingAnchor,
                                       padding: .init(top: defaultPadding, left: defaultPadding, bottom: 0, right: 0),
                                       size: .init(width: 0, height: 16))
    }
}

// FIXME: - class names should start with capital letter
class videoCell: UITableViewCell {
    /// Storyboard Replacement Step
    /// - Replace IBOutlets with init methods
    ///
    //    @IBOutlet weak var tumbnail: UIImageView!
    //    @IBOutlet weak var title: UILabel!
    //    @IBOutlet weak var name: UILabel!

    let titleLabel: UILabel = UILabel(text: "Video Name", font: .systemFont(ofSize: 17), textColor: .black)
    let nameLabel: UILabel = UILabel(text: "Channel Name", font: .systemFont(ofSize: 14), textColor: .black)
    let thumbnailImageView: UIImageView = UIImageView(frame: .zero)

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
        thumbnailImageView.image = nil
    }

    // MARK: - UI - replacing storyboard
    /// Storyboard Replacement Step
    /// Apply constraints programmatically
    private func applyAnchors() {
        addSubviews(titleLabel, nameLabel, thumbnailImageView)
        let thumbnailWidth: CGFloat = frame.width / 3.0
        let thumbnailHeight: CGFloat = thumbnailWidth * (9 / 16)

        thumbnailImageView.anchor(top: topAnchor, leading: leadingAnchor,
                                  bottom: nil, trailing: nil,
                                  padding: .init(top: defaultPadding, left: defaultPadding, bottom: 0, right: 0),
                                  size: .init(width: thumbnailWidth, height: thumbnailHeight))

        nameLabel.anchor(top: topAnchor, leading: thumbnailImageView.trailingAnchor,
                         bottom: nil, trailing: trailingAnchor,
                         padding: .init(top: defaultPadding, left: defaultPadding, bottom: 0, right: 0),
                         size: .init(width: 0, height: 20))

        titleLabel.anchor(top: nameLabel.bottomAnchor, leading: thumbnailImageView.trailingAnchor,
                          bottom: nil, trailing: trailingAnchor,
                          padding: .init(top: defaultPadding, left: defaultPadding, bottom: 0, right: 0),
                          size: .init(width: 0, height: 17))
    }
}

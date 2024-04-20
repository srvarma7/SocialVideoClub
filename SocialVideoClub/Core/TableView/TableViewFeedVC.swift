//
//  TableViewFeedVC.swift
//  SocialVideoClub
//
//  Created by Sai Raghu Varma Kallepalli on 17/04/24.
//

import UIKit
import EasyPeasy

class TableViewFeedVC: UIViewController, UIGestureRecognizerDelegate {
    
    var autoPlayTimerOnViewAppear: Timer?
    var posts: [PostModel] = []
    
    private var _isScrollObserverAdded = false
    var shouldAddScrollObserver: Bool {
        return true
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return control
    }()
    
    var tableViewStyle: UITableView.Style {
        return .plain
    }
    
    @objc lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: tableViewStyle)
        tv.delegate = self
        tv.dataSource = self
        tv.refreshControl = refreshControl
        tv.backgroundColor = .clear
        tv.contentInset = .init(top: 0, left: 0, bottom: 100, right: 0)
        tv.separatorStyle = .none
        return tv
    }()
    
    deinit {
        removeScrollObserver()
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        view.addSubview(tableView)
        tableView.easy.layout(Edges())
        
        registerTableViewCells()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func appMovedToBackground() {
        VideoView.triggerPauseMediaPlaybackNotification()
    }
    
    @objc func appCameToForeground() {
        autoPlayVideoInTableView()
    }
    
    var startVideoAutoPlay: Bool = false
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldAddScrollObserver {
            addScrollObserver()
            startVideoAutoPlay = true
            autoPlayTimerOnViewAppear = Timer.scheduledTimer(timeInterval: TimeInterval(0.5),
                                                             target: self,
                                                             selector: #selector(autoPlayVideoInTableView),
                                                             userInfo: nil,
                                                             repeats: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        startVideoAutoPlay = false

        autoPlayTimerOnViewAppear?.invalidate()
        autoPlayTimerOnViewAppear = nil
        
        VideoView.triggerPauseMediaPlaybackNotification()
        removeScrollObserver()
    }
    
    @objc func didPullToRefresh() {
        
    }
    
    func registerTableViewCells() {
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.id)
        tableView.register(LoadingCell.self, forCellReuseIdentifier: LoadingCell.id)
        tableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.id)
    }
    
    func addScrollObserver() {
        if !_isScrollObserverAdded {
            _isScrollObserverAdded = true
            addObserver(self, forKeyPath: #keyPath(tableView.contentOffset), options: [.old, .new], context: nil)
        }
    }
    
    func removeScrollObserver() {
        if _isScrollObserverAdded {
            removeObserver(self, forKeyPath: #keyPath(tableView.contentOffset))
            _isScrollObserverAdded = false
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(tableView.contentOffset) {
            scrollOffsetDidChange(contentOffset: tableView.contentOffset)
        }
    }
    
    func scrollOffsetDidChange(contentOffset: CGPoint) {
        autoPlayVideoInTableView()
    }
    
    @objc func autoPlayVideoInTableView() {
        if startVideoAutoPlay {
            VideoAutoPlayManager.handle(cv: tableView)
        }
    }
    
    func showNoData() {
        tableView.isHidden = true
    }
}

extension TableViewFeedVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.width * 16/10
    }
}

extension TableViewFeedVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assertionFailure("Needs implementation")
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        assertionFailure("Needs implementation")
        return UITableViewCell()
    }
}



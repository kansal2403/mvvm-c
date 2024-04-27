//
//  ViewController.swift
//  MVVM-C
//
//  Created by Rahish Kansal on 26/04/24.
//

import UIKit
import Combine

class PostsListViewController: UIViewController {
    private let viewModel: PostsListViewModel
    private lazy var bag: Set<AnyCancellable> = Set()
    
    @IBOutlet private weak var tableView: UITableView!
    private var posts: [Post] = []
    
    required init?(coder: NSCoder, viewModel: PostsListViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Posts"
        self.viewModel.viewDidLoad()
        self.bind()
    }
    
    private func bind() {
        viewModel.posts.receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("request completed")
                case .failure(let error):
                    print("Error == \(error)")
                }
            } receiveValue: { [unowned self] posts in
                print("Response count == \(posts.count)")
                self.posts = posts
                self.tableView.reloadData()
            }
            .store(in: &bag)
        
        viewModel.postsFailure.receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    break
                }
            } receiveValue: { message in
                let alert = UIAlertController.init(title: "Error!", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .destructive))
                self.present(alert, animated: true)
            }
            .store(in: &bag)
    }
    
}

extension PostsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell
        cell?.configure(post: posts[indexPath.row])
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.tableViewScrolled(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.showDetial(for: posts[indexPath.row])
    }
}

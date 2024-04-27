//
//  PostsListViewModel.swift
//  MVVM-C
//
//  Created by Rahish Kansal on 26/04/24.
//

import Foundation
import Combine

protocol PostsListViewModel {
    var posts: AnyPublisher<[Post], Never> { get }
    var postsFailure: AnyPublisher<String, Never> { get }
    func viewDidLoad()
    func tableViewScrolled(indexPath: IndexPath)
    func showDetial(for post: Post)
}

class PostsListViewModelImpl: PostsListViewModel {
    
    private var postArr: [Post] = []
    private var requestInProgress: Bool = false
    private let pageSize: Int = 20
    private var shouldRequestFurther: Bool = true
    
    private let fetchPostsService: FetchPostsService
    private let actions: PostViewActions
    init(fetchPostsService: FetchPostsService,
         actions: PostViewActions) {
        self.fetchPostsService = fetchPostsService
        self.actions = actions
    }
    
    private var postsSubject: PassthroughSubject<[Post], Never> = PassthroughSubject()
    var posts: AnyPublisher<[Post], Never> {
        postsSubject.eraseToAnyPublisher()
    }
    
    private var postsFailureSubject: PassthroughSubject<String, Never> = PassthroughSubject()
    var postsFailure: AnyPublisher<String, Never> {
        postsFailureSubject.eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        self.fetchPosts(for: PageInfo(start: 0, size: pageSize))
    }
    
    func tableViewScrolled(indexPath: IndexPath) {
        if postArr.count % pageSize == 0
            && requestInProgress == false
            && shouldRequestFurther
            && postArr.count - 1 == indexPath.row {
            self.fetchPosts(for: PageInfo(start: postArr.count, size: pageSize))
        }
    }
    
    private func fetchPosts(for pageInfo: PageInfo) {
        requestInProgress = true
        self.fetchPostsService.fetchPosts(pageInfo: pageInfo) { [unowned self] result in
            requestInProgress = false
            switch result {
            case .success(let success):
                self.shouldRequestFurther = success.count == self.pageSize
                
                self.postArr.append(contentsOf: success)
                self.postsSubject.send(self.postArr)
            case .failure(let failure):
                self.postsFailureSubject.send(failure.localizedDescription)
            }
        }
    }
    
    func showDetial(for post: Post) {
        self.actions.showDetial(post)
    }
}

//
//  SearchViewController.swift
//  UniAppNew
//
//  Created by Kim on 10/1/21.
//

import UIKit
import NVActivityIndicatorView
import EmptyDataSet_Swift


class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchOptionsView: UIView!
    @IBOutlet weak var searchTestField: UITextField!
    @IBOutlet weak var searchButtonOutlet: UIButton!
    
    var searchResults: [Post] = []
    var activityIndicator: NVActivityIndicatorView?
    
    private var postsModel = PostsModel()
    //private var algolia = Algolia()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()

        searchTestField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballPulse, color: #colorLiteral(red: 0.9998469949, green: 0.4941213727, blue: 0.4734867811, alpha: 1), padding: nil)
    }
    
    @IBAction func showSearchBarButton(_ sender: Any) {
        
        dismissKeyboard()
        showSearchField()
        
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        
        if searchTestField.text != "" {
            
            searchInFirebase(forName: searchTestField.text!)
            emptyTextField()
            animateSearchOptions()
            dismissKeyboard()
        }
        
    }
    
    private func searchInFirebase(forName: String) {
        showLoadingIndicator()
        
        Algolia.searchAlgolia(searchString: forName) { (itemIds) in
            Algolia.downloadPosts(itemIds) { (allItems) in
                self.searchResults = allItems
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.hideLoadingIndicator()
                }
            }
        }
        
        
    }
    
    private func emptyTextField() {
        searchTestField.text = ""
    }
    
    private func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        searchButtonOutlet.isEnabled = textField.text != ""
        
        //print("typing")
        if searchButtonOutlet.isEnabled {
            searchButtonOutlet.backgroundColor = #colorLiteral(red: 1, green: 0.4428375363, blue: 0.2739500701, alpha: 1)
        } else {
            disableSearchButton()
            //searchButtonOutlet.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
    }
    
    private func disableSearchButton() {
        searchButtonOutlet.isEnabled = false
        searchButtonOutlet.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    private func showSearchField() {
        disableSearchButton()
        emptyTextField()
        animateSearchOptions()
    }
    
    private func animateSearchOptions() {
        UIView.animate(withDuration: 0.5) {
            self.searchOptionsView.isHidden = !self.searchOptionsView.isHidden
        }
    }
    
    // Activiy indicator
    private func showLoadingIndicator() {
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }

    private func hideLoadingIndicator() {
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }
    
    private func showItemView(withItem: Post) {
        let postVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "postDetailsVC") as! PostDetailsViewController
        postVC.post = withItem
        postVC.postsModel = self.postsModel

        self.navigationController?.pushViewController(postVC, animated: true)
        //self.view.window?.makeKeyAndVisible()
    }
    
    private func transferComments(withId: Post) {
        
//        let task = Algolia.downloadComments(withId.postId) { (comments) in
//            self.searchComments = comments
//        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)

        let titleLabel = cell.viewWithTag(1) as? UILabel
        titleLabel?.text = searchResults[indexPath.row].title
        
        let imageView = cell.viewWithTag(2) as? UIImageView
        
        if searchResults[indexPath.row].imageLinks != nil && searchResults[indexPath.row].imageLinks.count > 0 {
            
            PhotoModel.downloadImages(imageUrls: [searchResults[indexPath.row].imageLinks.first!]) { (image) in
                imageView?.image = image[0]
            }
        }

        return cell
    }

    // Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        showItemView(withItem: searchResults[indexPath.row])
        

    }


}

extension SearchViewController: EmptyDataSetSource, EmptyDataSetDelegate {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {

        return NSAttributedString(string: "No search results!")
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "emptyData")
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "Start searching...")
    }

    func buttonImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
        return UIImage(named: "search")
    }

    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {

        showSearchField()
    }
}

//
//  ViewController.swift
//  Assignment4CollectionView
//
//  Created by Mac on 04/01/24.
//
import UIKit
class ViewController: UIViewController {
    var post : [Post] = []
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initisiatewithCollectionView()
        registerXibWithCollectionView()
        dataFetch()
    }
    func initisiatewithCollectionView()
    {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    func registerXibWithCollectionView()
    {
            let uiNib = UINib(nibName: "CustomCollectionViewCell", bundle: nil)
        collectionView.register(uiNib, forCellWithReuseIdentifier: "CustomCollectionViewCell")
    }
    func dataFetch()
    {
        let postUrl = URL(string: "https://jsonplaceholder.typicode.com/comments")
        var postUrlReequest = URLRequest(url: postUrl!)
        postUrlReequest.httpMethod = "Get"
        var postUrlSesson = URLSession(configuration: .default)
        var dataTask = postUrlSesson.dataTask(with: postUrlReequest) { postData, postResponse, postError in
            let postUrlresponse = try! JSONSerialization.jsonObject(with: postData!)
            for eachResponse in postUrlresponse as! [[String : Any]]
            {
                let postDictonary = eachResponse as! [String : Any]
                let postIdLabel = postDictonary["postId"] as! Int
                let idLabel = postDictonary["id"] as! Int
                let nameLabel = postDictonary["name"] as! String
                let emailLabel = postDictonary["email"] as! String
                let bodylabel = postDictonary["body"] as! String
                let Object = Post(postId: postIdLabel, id: idLabel, name: nameLabel, email: emailLabel, body: bodylabel)
                self.post.append(Object)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        dataTask.resume()
    }
}
extension ViewController : UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
}
extension ViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        post.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCollectionViewCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        customCollectionViewCell.postIdLabel.text = String(post[indexPath.item].postId)
        customCollectionViewCell.idLabel.text = String(post[indexPath.item].id)
        customCollectionViewCell.nameLabel.text = (post[indexPath.item].name)
        customCollectionViewCell.emailLabel.text = (post[indexPath.item].email)
        customCollectionViewCell.bodyLabel.text = (post[indexPath.item].body)
        return customCollectionViewCell
    }
}
extension ViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let spaceBetweetheCell : CGFloat = (flowLayout.minimumInteritemSpacing ?? 0.0) + (flowLayout.sectionInset.left ?? 0.0) + (flowLayout.sectionInset.right ?? 0.0)
        let size = (self.collectionView.frame.width - spaceBetweetheCell) / 2
        return CGSize(width: size, height: size)
    }
}

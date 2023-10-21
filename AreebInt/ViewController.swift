//
//  ViewController.swift
//  AreebInt
//
//  Created by Apple on 19/10/2023.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet weak var repoCollectionView: UICollectionView!
    var repsArray:[Repository]?
    var urlsArray:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        repoCollectionView.dataSource = self
        repoCollectionView.delegate = self
        getRepo(completion: { result in
            switch result {
            case .success(let repos):
                self.repsArray = repos
                DispatchQueue.main.async {     // When the data comes change collection
                    self.repoCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }, endPoint: "https://api.github.com/repositories")
    }
}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return repsArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "repoCell", for: indexPath) as! RepooCell
        let imageUrl = URL(string: (repsArray![indexPath.row].owner?.avatar_url)!)
//        let urls = URL(string: "\(repsArray![indexPath.row].url ?? "")")
   
        cell.repoName.text = "Name : \(repsArray![indexPath.row].name ?? "Non")"
        cell.ownerName.text = "Owner Name : \(repsArray![indexPath.row].owner?.login ?? "Non")"
        cell.createdAt.text = "Created At : \(repsArray![indexPath.row].created_at ?? "Non")"
        cell.repoImage.sd_setImage(with: imageUrl)
       
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsVc") as! DetailsVc
        vc.repo = repsArray![indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func getRepo(completion:@escaping(Result<[Repository],Error>)->Void,endPoint:String){ // Save the result of response
            guard let url = URL(string: endPoint) else{        // If url not valid return
                return
            }
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else {         // Check data if true decode data false return
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let repos = try decoder.decode([Repository].self, from: data)
                    completion(.success(repos))   // Put the data into the completion
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
}


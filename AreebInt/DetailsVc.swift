//
//  DetailsVc.swift
//  AreebInt
//
//  Created by Apple on 20/10/2023.
//

import UIKit

class DetailsVc: UIViewController {

    @IBOutlet weak var repoImage: UIImageView!
    @IBOutlet weak var repoId: UILabel!
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var repoDescription: UILabel!
    
    var repo:Repository?
    var date: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUi()
        getRepoDetails(completion: { result in
            switch result {
            case .success(let repos):
                self.date = repos.created_at
                DispatchQueue.main.async {     // When the data comes change collection
                    self.createdAt.text = self.convertDate(dateString: repos.created_at ?? "")
                }
            case .failure(let error):
                print(error)
            }
        }, endPoint: "\(repo?.url ?? "")")
    }
    func configureUi() {
        let imageUrl = URL(string: (repo?.owner?.avatar_url)!)
        repoName.text = " Repo Name: \(repo?.name ?? "")"
        ownerName.text = " Owner Name: \(repo?.owner?.login ?? "")"
        repoDescription.text = " Description: \(repo?.description ?? "")"
        repoId.text = " Repo ID: \(repo?.id ?? 0)"
        repoImage.sd_setImage(with: imageUrl)
    }
}
extension DetailsVc {
    func getRepoDetails(completion:@escaping(Result<Repository,Error>)->Void,endPoint:String){ // Save the result of response
            guard let url = URL(string: endPoint) else{        // If url not valid return
                return
            }
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else {         // Check data if true decode data false return
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let repos = try decoder.decode(Repository.self, from: data)
                    completion(.success(repos))   // Put the data into the completion
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }

func convertDate(dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dateString) {
            let currentDate = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.month, .year], from: date, to: currentDate)
            
            if let year = components.year, year > 0 {
                let formattedDate = DateFormatter()
                formattedDate.dateFormat = "EEEE, MMM d, yyyy"
                return formattedDate.string(from: date)
            } else if let month = components.month, month >= 6 {
                let formattedDate = DateFormatter()
                formattedDate.dateFormat = "EEEE, MMM d, yyyy"
                return formattedDate.string(from: date)
            } else {
                return (components.month ?? 0 > 1) ? "\(components.month!) months ago" : "4 months ago"
            }
        } else {
            return "Invalid date format"
        }
    }
}

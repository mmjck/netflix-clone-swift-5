//
//  DonwloadsViewController.swift
//  Netflix Clone
//
//  Created by Jackson Matheus on 18/03/23.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    
    private var titles: [Title] = [Title]()
    
    private let upcoming: UITableView =  {
       let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        
        
        
        self.view.addSubview(upcoming)
        upcoming.delegate = self
        upcoming.dataSource = self
        
        
        fetchUpcoming()
    }
    
    override func viewDidLayoutSubviews() {
        upcoming.frame = self.view.bounds
    }
    
    
    private func fetchUpcoming(){
        APICaller.shared.getUpcomingMovies{ result in
            switch result {
            case .success(let _titles):
                self.titles = _titles
                DispatchQueue.main.async {
                    self.upcoming.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
}
extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: title.original_name ??  title.original_title ?? "Unknow", posterURL: title.poster_path ?? ""))
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

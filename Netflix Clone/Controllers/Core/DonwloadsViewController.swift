//
//  DonwloadsViewController.swift
//  Netflix Clone
//
//  Created by Jackson Matheus on 18/03/23.
//

import UIKit

class DonwloadsViewController: UIViewController {
    
    
    private var titles: [TitleItem] = [TitleItem]()
    
    private let downloadTable: UITableView =  {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        title = "Download"
        self.view.addSubview(downloadTable)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        
        
        self.view.addSubview(downloadTable)
        downloadTable.delegate = self
        downloadTable.dataSource = self
        
        
        fetchLocalStorageForDownload()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownload()
        }
        
    }
    
    
    private func fetchLocalStorageForDownload(){
        DataPersistenceManager.shared.fetchingTitlesFromDataBase{
            [weak self] result in
            switch result {
            case.success(let titles):
                
                DispatchQueue.main.async {
                    self?.titles = titles
                    self?.downloadTable.reloadData()
                }
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTable.frame = self.view.bounds
    }
}


extension DonwloadsViewController:  UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            
            DataPersistenceManager.shared.deleteTitleWith(model: titles[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    print("Deleted fromt the database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_name ?? title.original_title else {
            return
        }
        
        APICaller.shared.getMovie(with: titleName){ [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
            
        }
    }
    
}

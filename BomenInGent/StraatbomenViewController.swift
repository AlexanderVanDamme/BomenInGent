import UIKit

class StraatbomenViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
   
    
    fileprivate var straatBomen: [Straatboom] = []
    fileprivate var boomDictionary : Dictionary<String, Array<String>> = [:]
    private var currentTask: URLSessionTask?
    
    func vulDictionaryIn() {
        for straatboom in straatBomen{
            if var oldArray = boomDictionary[straatboom.boomsoorten] {
                oldArray.append(straatboom.Straatnamenlijst)
                boomDictionary[straatboom.boomsoorten] = oldArray
            } else {
                self.boomDictionary[straatboom.boomsoorten] = [straatboom.Straatnamenlijst]
            }
        }
        
        }
    
    func maakBoomVoorkomenArray(){
        for (key,value) in boomDictionary {
            boomVoorkomenArray.append(BoomVoorkomen(boomNaam : key, straatNamen : value))
        }
    
    }
    
    struct BoomVoorkomen {
        var boomNaam : String!
        var straatNamen : [String]!
    }
    
    var boomVoorkomenArray = [BoomVoorkomen]()
 

    
    override func viewDidLoad() {
 
        currentTask = Service.shared.loadDataTask {
            result in
            switch result {
            case .success(let straatBomen):
                
                self.straatBomen = straatBomen.sorted { $0.Straatnamenlijst < $1.Straatnamenlijst }
                print("laden succesvol")
               
            case .failure(let error):
                print("laden niet succesvol")
                print(error)
                
            }
           
        }
        currentTask!.resume()
        refreshTableView()
        vulDictionaryIn()
        maakBoomVoorkomenArray()
        
    
    }
    
    func refreshTableView() {
        currentTask?.cancel()
        currentTask = Service.shared.loadDataTask {
            result in
            switch result {
            case .success(let straatBomen):
                print("refreshen succesvol")
                self.straatBomen = straatBomen.sorted { $0.boomsoorten < $1.boomsoorten }
                print(straatBomen)
                self.tableView.reloadData()
                
               
            case .failure(let error):
                print("refreshen niet succesvol")
                print(error)
             
                self.tableView.reloadData() // to hide separators
            }
      
        }
        currentTask!.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let straatboomViewController = navigationController.topViewController as! StraatboomViewController
        let selectedIndex = tableView.indexPathForSelectedRow!.row
        straatboomViewController.boomVoorkomen = boomVoorkomenArray[selectedIndex]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    }

extension StraatbomenViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boomVoorkomenArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        print("tableview maken")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        
        
        let boomVoorkomen = boomVoorkomenArray[indexPath.row]
        
        cell.boomNaam.text = geefNederlandseNaam(latijnseNaam: boomVoorkomen.boomNaam)
        
        let defaulturl = NSURL(string: "http://publicdomainvectors.org/photos/PeterM_Tree.png")
        
        let url = maakUrl(boomNaam: boomVoorkomen.boomNaam)
        
        let nsUrl = NSURL(fileURLWithPath: url)
        
        if let imageData: NSData = NSData(contentsOf: nsUrl as URL){
            cell.foto.image = UIImage(data: imageData as Data)
        } else {
            let imageData =  NSData(contentsOf: defaulturl as! URL)
            cell.foto.image = UIImage(data: imageData as! Data)
        }
        
        cell.latijnNaam.text = boomVoorkomen.boomNaam
   
        
        return cell
    }
    
    func maakUrl(boomNaam : String) -> String {
        return "http://www.google.be/search?q=" + boomNaam
    
    
    }
    
    func geefNederlandseNaam(latijnseNaam: String) -> String {
        return latijnseNaam
    }
}

extension StraatbomenViewController: UITableViewDelegate {
    
}

extension StraatbomenViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}








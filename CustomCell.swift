import UIKit

class CustomCell: UITableViewCell {
    
    
    @IBOutlet weak var foto: UIImageView!
    
    @IBOutlet weak var boomNaam: UILabel!
    
    @IBOutlet weak var latijnNaam: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //configure the view for the selected state
    }
    
    
    
}

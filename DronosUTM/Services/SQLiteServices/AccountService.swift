//import SQLite
//
//class AccountService {
//    private var db: Connection?
//    private let accountsTable = Table("accounts")
//    private let id = Expression<Int64>("id")
//    private let username = Expression<String>("username")
//    private let password = Expression<String>("password")
//    
//    init() {
//        do {
//            let path = NSSearchPathForDirectoriesInDomains(
//                .documentDirectory, .userDomainMask, true
//            ).first!
//            
//            db = try Connection("\(path)/accounts.sqlite3")
//            createTable()
//        } catch {
//            print("Error opening database: \(error)")
//        }
//    }
//    
//    private func createTable() {
//        guard let db = db else { return }
//        
//        do {
//            try db.run(accountsTable.create(ifNotExists: true) { table in
//                table.column(id, primaryKey: .autoincrement)
//                table.column(username, unique: true)
//                table.column(password)
//            })
//        } catch {
//            print("Error creating table: \(error)")
//        }
//    }
//    
//    func createAccount(username: String, password: String) {
//        guard let db = db else { return }
//        
//        let insert = accountsTable.insert(self.username <- username, self.password <- password)
//        
//        do {
//            let rowId = try db.run(insert)
//            print("Account created with ID: \(rowId)")
//        } catch {
//            print("Error creating account: \(error)")
//        }
//    }
//    
//    func getAccounts() -> [Account] {
//        guard let db = db else { return [] }
//        
//        var accounts: [Account] = []
//        
//        do {
//            for account in try db.prepare(accountsTable) {
//                let id = account[self.id]
//                let username = account[self.username]
//                let password = account[self.password]
//                
//                accounts.append(Account(id: id, username: username, password: password))
//            }
//        } catch {
//            print("Error retrieving accounts: \(error)")
//        }
//        
//        return accounts
//    }
//    
//    func updateAccount(id: Int64, username: String, password: String) {
//        guard let db = db else { return }
//        
//        let account = accountsTable.filter(self.id == id)
//        let update = account.update(self.username <- username, self.password <- password)
//        
//        do {
//            if try db.run(update) > 0 {
//                print("Account updated with ID: \(id)")
//            } else {
//                print("Account not found")
//            }
//        } catch {
//            print("Error updating account: \(error)")
//        }
//    }
//    
//    func deleteAccount(id: Int64) {
//        guard let db = db else { return }
//        
//        let account = accountsTable.filter(self.id == id)
//        let delete = account.delete()
//        
//        do {
//            if try db.run(delete) > 0 {
//                print("Account deleted with ID: \(id)")
//            } else {
//                print("Account not found")
//            }
//        } catch {
//            print("Error deleting account: \(error)")
//        }
//    }
//}
//
//struct Account {
//    let id: Int64
//    let username: String
//    let password: String
//}

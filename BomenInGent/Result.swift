enum Result<T> {
    
    case success(T)
    case failure(Service.Error)
}

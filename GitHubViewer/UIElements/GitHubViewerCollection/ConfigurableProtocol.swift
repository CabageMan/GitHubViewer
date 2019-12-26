protocol ConfigurableCell {
    
    associatedtype CellData
    
    func configure(with data: CellData)
    
}

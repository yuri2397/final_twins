class ConsumableStore {
  String _name;
  int _price;
  int _quantity;

  ConsumableStore(this._name, this._price, this._quantity);

  String get name => _name;

  int get price => _price;

  int get quantity => _quantity;

  set name(String newName) => _name = newName;

  set price(int newPrice) => _price = newPrice;

  set quantity(int newQuantity) => _quantity = newQuantity;

  void buy() {
    _quantity--;
  }
}
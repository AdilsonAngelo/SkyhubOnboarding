class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  validates_presence_of :sku, :price, :name, :description, :amount
  validates_uniqueness_of :sku

  field :sku, type: String
  field :price, type: Float
  field :name, type: String
  field :description, type: String
  field :amount, type: Integer

  def to_api
    {
      id: id.to_s,
      sku: sku,
      price: price,
      name: name,
      description: description,
      amount: amount
    }
  end
end

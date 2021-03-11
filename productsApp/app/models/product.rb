class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  validates :sku, :price, :name, :description, :amount, :presence => true
  validates :sku, :uniqueness => true

  field :sku, type: String
  field :price, type: Float
  field :name, type: String
  field :description, type: String
  field :amount, type: Integer
end

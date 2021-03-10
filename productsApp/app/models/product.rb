class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  field :sku, type: String
  field :price, type: Float
  field :name, type: String
  field :description, type: String
  field :amount, type: Integer
end

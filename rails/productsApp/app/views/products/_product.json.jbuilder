json.extract! product, :id, :sku, :price, :name, :description, :amount, :created_at, :updated_at
json.url product_url(product, format: :json)

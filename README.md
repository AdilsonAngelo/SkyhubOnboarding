# B2W - Skyhub onboarding

## Ruby on Rails app

### Usage

```sh
$ docker-compose build
$ docker-compose up -d
```

### Requests

#### CREATE
```sh
curl --request POST \
  --url http://localhost:3000/products.json \
  --header 'Content-Type: application/json' \
  --data '{
	"sku": "A4F65B",
	"price": 99.9,
	"name": "foo",
	"description": "bar",
	"amount": 90
}'

# {
#   "id": {
#     "$oid": "60498e0991b9300001000001"
#   },
#   "sku": "A4F65B",
#   "price": 99.9,
#   "name": "foo",
#   "description": "bar",
#   "amount": 90,
#   "created_at": "2021-03-11T03:27:05.786Z",
#   "updated_at": "2021-03-11T03:27:05.786Z",
#   "url": "http://localhost:3000/products/60498e0991b9300001000001.json"
# }
```

#### READ
```sh
curl --request GET \
  --url http://localhost:3000/products/60498e0991b9300001000001.json \
  --header 'Content-Type: application/json'

# {
#   "id": {
#     "$oid": "60498e0991b9300001000001"
#   },
#   "sku": "A4F65B",
#   "price": 99.9,
#   "name": "foo",
#   "description": "bar",
#   "amount": 90,
#   "created_at": "2021-03-11T03:27:05.786Z",
#   "updated_at": "2021-03-11T03:27:05.786Z",
#   "url": "http://localhost:3000/products/60498e0991b9300001000001.json"
# }
```

#### UPDATE
```sh
curl --request PATCH \
  --url http://localhost:3000/products/60498d8d91b9300001000000.json \
  --header 'Content-Type: application/json' \
  --data '{
	"name": "Adilson"
}'

# {
#   "id": {
#     "$oid": "60498d8d91b9300001000000"
#   },
#   "sku": "A4F65B",
#   "price": 99.9,
#   "name": "Adilson",
#   "description": "bar",
#   "amount": 90,
#   "created_at": "2021-03-11T03:25:01.589Z",
#   "updated_at": "2021-03-11T03:26:33.403Z",
#   "url": "http://localhost:3000/products/60498d8d91b9300001000000.json"
# }
```

#### DELETE
```sh
curl --request DELETE \
  --url http://localhost:3000/products/60498d8d91b9300001000000.json \
  --header 'Content-Type: application/json' \

# HTTP: 204
```
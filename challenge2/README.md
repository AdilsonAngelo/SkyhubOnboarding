# B2W - Skyhub onboarding

## Phoenix app

### Usage

```sh
$ docker-compose build
$ docker-compose up -d
```

### Requests

#### LIST
```sh
$ curl --request GET \
  --url http://localhost:4000/api/products/

# [
#   {
#     "id": "604f68c40dc0e80001109714",
#     "sku": "A1B2C3"
#     "price": 42.5,
#     "name": "foo",
#     "description": "bar",
#     "amount": 4,
#   },
#   {
#     "id": "604f68c40dc0e80001109715",
#     "sku": "D4E5F6"
#     "price": 42,
#     "name": "Adilson",
#     "description": "Angelo",
#     "amount": 99,
#   }
# ]

```

#### CREATE
```sh
$ curl --request POST \
  --url http://localhost:4000/api/products \
  --header 'Content-Type: application/json' \
  --data '{
		"sku": "A1B2C3",
		"price": 42.5,
		"name": "foo",
		"description": "bar",
		"amount": 4
}'

# {
#   "id": "604f7405ac8c9800014c5eed",
#   "sku": "A4F65B",
#   "price": 99.9,
#   "name": "foo",
#   "description": "bar",
#   "amount": 90
# }
```

#### READ
```sh
$ curl --request GET \
  --url http://localhost:4000/api/products/604f7405ac8c9800014c5eed

# {
#   "id": "604f7405ac8c9800014c5eed",
#   "sku": "A4F65B",
#   "price": 99.9,
#   "name": "foo",
#   "description": "bar",
#   "amount": 90
# }
```

#### UPDATE
```sh
curl --request PATCH \
  --url http://localhost:4000/api/products/604f7405ac8c9800014c5eed \
  --header 'Content-Type: application/json' \
  --data '{
    "id": "604f7405ac8c9800014c5eed",
    "product": {
	    "name": "Adilson"
    }
}'
# {
#   "id": "604f7405ac8c9800014c5eed",
#   "sku": "A4F65B",
#   "price": 99.9,
#   "name": "Adilson",
#   "description": "bar",
#   "amount": 90
# }
```

#### DELETE
```sh
$ curl --request DELETE \
  --url http://localhost:4000/api/products/604f7405ac8c9800014c5eed

# HTTP: 204
```

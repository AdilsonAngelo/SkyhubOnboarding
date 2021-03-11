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
$ curl --request POST \
  --url http://localhost:3000/api/products \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data '{
	"sku": "A4F65B",
	"price": 99.9,
	"name": "foo",
	"description": "bar",
	"amount": 90
}'

# {
#   "id": "60498e0991b9300001000001",
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
  --url http://localhost:3000/api/products/60498e0991b9300001000001 \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json'

# {
#   "id": "60498e0991b9300001000001",
#   "sku": "A4F65B",
#   "price": 99.9,
#   "name": "foo",
#   "description": "bar",
#   "amount": 90
# }
```

#### UPDATE
```sh
$ curl --request PATCH \
  --url http://localhost:3000/api/products/60498e0991b9300001000001 \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data '{
	"name": "Adilson"
}'

# {
#   "id": "60498e0991b9300001000001",
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
  --url http://localhost:3000/api/products/60498e0991b9300001000001 \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json'

# HTTP: 204
```

#### Also in XML

```sh
$ curl --request GET \
  --url http://localhost:3000/api/products \
  --header 'Accept: application/xml' \
  --header 'Content-Type: application/json'
```
```xml
<?xml version="1.0" encoding="UTF-8"?>
<objects type="array">
  <object>
    <id>604a6ef2e47b210001000000</id>
    <sku>A4F65EAAA</sku>
    <price type="float">99.9</price>
    <name>foo</name>
    <description>bar</description>
    <amount type="integer">90</amount>
  </object>
  <object>
    <id>604a6e8cf38dac0001000000</id>
    <sku>A4F65EA</sku>
    <price type="float">99.9</price>
    <name>Adilson</name>
    <description>Angelo</description>
    <amount type="integer">90</amount>
  </object>
</objects>
```
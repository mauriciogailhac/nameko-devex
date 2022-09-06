#!/bin/bash

# DIR="${BASH_SOURCE%/*}"
# if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
# . "$DIR/nex-include.sh"

# to ensure if 1 command fails.. build fail
set -e

# ensure prefix is pass in
if [ $# -lt 1 ] ; then
	echo "NEX smoketest needs prefix"
	echo "nex-smoketest.sh acceptance"
	exit
fi

PREFIX=$1

# check if doing local smoke test
if [ "${PREFIX}" != "local" ]; then
    echo "Remote Smoke Test in CF"
    STD_APP_URL=${PREFIX}
else
    echo "Local Smoke Test"
    STD_APP_URL=http://localhost:8000
fi

echo STD_APP_URL=${STD_APP_URL}

create_order()
{

  curl -s -XPOST "${STD_APP_URL}/orders" \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d "$1"
}

create_product()
{

  curl -s -XPOST  "${STD_APP_URL}/products" \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d "$1"
}

get_product()
{
  curl -s "${STD_APP_URL}/products/$1" | jq .
}

get_order()
{
  curl -s "${STD_APP_URL}/orders/$1" | jq .
}

delete_product()
{
  curl -s -X "DELETE" "${STD_APP_URL}/products/$1" | jq .
}

list_orders()
{
  curl -s "${STD_APP_URL}/orders?page=1" | jq .
}


# Test: Create Products
echo "=== Creating a product id: the_odyssey ==="
create_product '{"id": "the_odyssey", "title": "The Odyssey", "passenger_capacity": 101, "maximum_speed": 5, "in_stock": 10}'
echo
# Test: Get Product
echo "=== Getting product id: the_odyssey ==="
get_product 'the_odyssey'
# Test: Delete Product
echo "=== Deleting product: the_odyssey ==="
delete_product 'the_odyssey'
# Test: Create Products
echo "=== Creating a product id: the_odyssey ==="
create_product '{"id": "the_odyssey", "title": "The Odyssey", "passenger_capacity": 101, "maximum_speed": 5, "in_stock": 10}'
echo
echo "=== Creating a product id: the_end ==="
create_product '{"id": "the_end", "title": "The End", "passenger_capacity": 101, "maximum_speed": 5, "in_stock": 10}'
echo
# Test: Create Order
echo "=== Creating Orders ==="
ORDER_ID=$(
    create_order '{"order_details": [{"product_id": "the_odyssey", "price": "100000.99", "quantity": 1}]}'
)
create_order '{"order_details": [{"product_id": "the_end", "price": "100000.99", "quantity": 1}]}'

echo ${ORDER_ID}
ID=$(echo ${ORDER_ID} | jq '.id')

# Test: Get Order back
echo "=== Getting Order ==="
get_order $ID

# Test: List Orders
echo "=== List Orders ==="
list_orders

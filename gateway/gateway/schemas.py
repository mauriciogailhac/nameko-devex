from marshmallow import Schema, fields


class CreateOrderDetailSchema(Schema):
    product_id = fields.Str(required=True)
    price = fields.Decimal(as_string=True, required=True)
    quantity = fields.Int(required=True)


class CreateOrderSchema(Schema):
    order_details = fields.Nested(
        CreateOrderDetailSchema, many=True, required=True
    )


class ProductSchema(Schema):
    id = fields.Str(required=True)
    title = fields.Str(required=True)
    maximum_speed = fields.Int(required=True)
    in_stock = fields.Int(required=True)
    passenger_capacity = fields.Int(required=True)


class GetOrderSchema(Schema):

    class OrderDetail(Schema):
        id = fields.Int()
        quantity = fields.Int()
        product_id = fields.Str()
        image = fields.Str()
        price = fields.Decimal(as_string=True)
        product = fields.Nested(ProductSchema, many=False)

    id = fields.Int()
    order_details = fields.Nested(OrderDetail, many=True)


class OrderSchemaPaginated(Schema):
    items = fields.Nested(GetOrderSchema, many=True)
    item_count = fields.Int(required=True)
    page = fields.Int(required=True)
    items_per_page = fields.Int(required=True)
    first_page = fields.Int(required=True)
    last_page = fields.Int(required=True)
    previous_page = fields.Int(required=True)
    next_page = fields.Int(required=True)
    page_count = fields.Int(required=True)
    first_item = fields.Int(required=True)
    last_item = fields.Int(required=True)


class Status(Schema):
    success = fields.Bool(required=True)

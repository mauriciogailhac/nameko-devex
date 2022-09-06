from marshmallow import Schema, fields


class OrderDetailSchema(Schema):
    id = fields.Int(required=True)
    product_id = fields.Str(required=True)
    price = fields.Decimal(as_string=True)
    quantity = fields.Int()


class OrderSchema(Schema):
    id = fields.Int(required=True)
    order_details = fields.Nested(OrderDetailSchema, many=True)


class OrderSchemaPaginated(Schema):
    items = fields.Nested(OrderSchema, many=True)
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

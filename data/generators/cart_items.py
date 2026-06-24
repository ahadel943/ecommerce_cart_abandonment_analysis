import random
import pandas as pd

from utils import generate_uuid


def generate_cart_items(carts_df, products_df):

    rows = []

    product_ids = products_df["product_id"].tolist()

    for _, cart in carts_df.iterrows():

        num_items = random.randint(1, 5)

        for _ in range(num_items):

            product = random.choice(product_ids)

            rows.append({
                "cart_item_id": generate_uuid(),
                "cart_id": cart["cart_id"],
                "product_id": product,
                "quantity": random.randint(1, 3),
                "unit_price": random.uniform(10, 1000)
            })

    return pd.DataFrame(rows)
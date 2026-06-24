
import random
import pandas as pd

from utils import generate_uuid


def generate_orders(checkout_df, carts_df):

    rows = []

    for _, row in checkout_df.iterrows():

        if row["completed"]:

            rows.append({
                "order_id": generate_uuid(),
                "cart_id": row["cart_id"],
                "total_amount": round(random.uniform(20, 2000), 2),
                "payment_method": row["payment_method"]
            })

    return pd.DataFrame(rows)
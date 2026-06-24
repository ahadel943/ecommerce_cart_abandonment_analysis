import random
import pandas as pd

from utils import generate_uuid, random_datetime


def generate_checkout_attempts(carts_df):

    rows = []

    for _, cart in carts_df.iterrows():

        if random.random() < 0.6:

            rows.append({
                "checkout_id": generate_uuid(),
                "cart_id": cart["cart_id"],
                "started_at": random_datetime(),
                "payment_method": random.choice([
                    "Card", "Cash", "Wallet"
                ]),
                "shipping_cost": round(random.uniform(2, 25), 2),
                "completed": random.random() < 0.3
            })

    return pd.DataFrame(rows)
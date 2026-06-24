import random
import pandas as pd

from utils import generate_uuid, random_datetime


EVENTS = [
    "cart_created",
    "add_item",
    "remove_item",
    "checkout_started",
    "payment_failed",
    "purchase_completed",
    "cart_abandoned"
]


def generate_cart_events(users_df, carts_df, checkout_df, orders_df):

    rows = []

    for _, cart in carts_df.iterrows():

        num_events = random.randint(3, 15)

        for _ in range(num_events):

            rows.append({
                "event_id": generate_uuid(),
                "cart_id": cart["cart_id"],
                "user_id": cart["user_id"],
                "event_name": random.choice(EVENTS),
                "event_time": random_datetime()
            })

    return pd.DataFrame(rows)
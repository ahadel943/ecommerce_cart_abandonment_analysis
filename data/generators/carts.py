import random
import pandas as pd

from utils import generate_uuid, random_datetime


def generate_carts(users_df):

    rows = []

    for _, user in users_df.iterrows():

        num_carts = max(1, int(random.gauss(4, 2)))

        for _ in range(num_carts):

            created = random_datetime()

            rows.append({
                "cart_id": generate_uuid(),
                "user_id": user["user_id"],
                "created_at": created,
                "status": "Active"
            })

    return pd.DataFrame(rows)
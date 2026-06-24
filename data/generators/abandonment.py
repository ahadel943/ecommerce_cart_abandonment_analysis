import random
import pandas as pd


REASONS = [
    "High Shipping Cost",
    "Just Browsing",
    "Price Too High",
    "Payment Issues",
    "Coupon Failed"
]


def generate_abandonment_reasons(carts_df, checkout_df):

    rows = []

    checkout_carts = set(checkout_df["cart_id"].tolist()) if len(checkout_df) > 0 else set()

    for _, cart in carts_df.iterrows():

        if cart["cart_id"] not in checkout_carts:

            rows.append({
                "cart_id": cart["cart_id"],
                "reason": random.choice(REASONS),
                "confidence": round(random.uniform(0.5, 0.95), 2)
            })

    return pd.DataFrame(rows)
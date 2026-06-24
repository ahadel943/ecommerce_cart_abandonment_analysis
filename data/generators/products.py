import random
import pandas as pd

from config import NUM_PRODUCTS
from utils import generate_uuid


CATEGORIES = ["Electronics", "Fashion", "Home", "Beauty", "Sports"]

BRANDS = ["BrandA", "BrandB", "BrandC", "BrandD"]

def generate_products():

    rows = []

    for _ in range(NUM_PRODUCTS):

        category = random.choice(CATEGORIES)

        base_price = random.uniform(5, 1000)

        # luxury skew
        if category == "Electronics":
            base_price *= random.uniform(1.5, 3)

        row = {
            "product_id": generate_uuid(),
            "product_name": f"Product_{random.randint(1000,9999)}",
            "category": category,
            "brand": random.choice(BRANDS),
            "price": round(base_price, 2),
            "cost": round(base_price * random.uniform(0.5, 0.8), 2),
            "rating": round(random.uniform(2.5, 5), 1),
            "stock": random.randint(0, 500),
            "is_active": random.random() > 0.05
        }

        rows.append(row)

    return pd.DataFrame(rows)
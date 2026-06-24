import random
import pandas as pd
from faker import Faker

from config import NUM_USERS, PREMIUM_USER_RATE, RETURNING_USER_RATE, OUTPUT_DIR
from utils import generate_uuid, random_datetime, weighted_choice, save_csv

fake = Faker()

COUNTRIES = ["Egypt", "Saudi Arabia", "UAE", "Jordan", "Kuwait"]

CITIES = {
    "Egypt": ["Cairo", "Alexandria", "Giza"],
    "Saudi Arabia": ["Riyadh", "Jeddah"],
    "UAE": ["Dubai", "Abu Dhabi"],
    "Jordan": ["Amman"],
    "Kuwait": ["Kuwait City"]
}

DEVICES = ["Mobile", "Desktop", "Tablet"]
DEVICE_W = [0.65, 0.30, 0.05]

CHANNELS = [
    "Organic Search", "Paid Search", "Direct",
    "Email", "Social Media", "Referral"
]

CHANNEL_W = [0.25, 0.15, 0.20, 0.10, 0.20, 0.10]


def generate_users():

    rows = []

    for _ in range(NUM_USERS):

        country = random.choice(COUNTRIES)
        city = random.choice(CITIES[country])

        if random.random() < 0.05:
            city = None

        channel = weighted_choice(CHANNELS, CHANNEL_W)

        if random.random() < 0.03:
            channel = "Unknown"

        row = {
            "user_id": generate_uuid(),
            "signup_date": random_datetime(),
            "country": country,
            "city": city,
            "device": weighted_choice(DEVICES, DEVICE_W),
            "acquisition_channel": channel,
            "customer_type": weighted_choice(
                ["New", "Returning"],
                [1 - RETURNING_USER_RATE, RETURNING_USER_RATE]
            ),
            "age": int(max(18, min(70, random.gauss(33, 11)))),
            "is_premium": random.random() < PREMIUM_USER_RATE
        }

        rows.append(row)

    df = pd.DataFrame(rows)

    return df
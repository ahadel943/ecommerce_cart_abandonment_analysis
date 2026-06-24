import uuid
import random
from datetime import datetime, timedelta

import pandas as pd

from config import START_DATE, END_DATE


def generate_uuid():
    return str(uuid.uuid4())


def random_datetime():
    start = datetime.strptime(START_DATE, "%Y-%m-%d")
    end = datetime.strptime(END_DATE, "%Y-%m-%d")
    delta = end - start

    return start + timedelta(
        seconds=random.randint(0, int(delta.total_seconds()))
    )


def weighted_choice(values, weights):
    return random.choices(values, weights=weights, k=1)[0]


def save_csv(df, path):
    df.to_csv(path, index=False)
from config import OUTPUT_DIR

from generators.users import generate_users
from generators.products import generate_products
from generators.carts import generate_carts
from generators.cart_items import generate_cart_items
from generators.checkout import generate_checkout_attempts
from generators.orders import generate_orders
from generators.events import generate_cart_events
from generators.abandonment import generate_abandonment_reasons


def main():

    print("Generating users...")
    users_df = generate_users()

    print("Generating products...")
    products_df = generate_products()

    print("Generating carts...")
    carts_df = generate_carts(users_df)

    print("Generating cart items...")
    cart_items_df = generate_cart_items(carts_df, products_df)

    print("Generating checkout...")
    checkout_df = generate_checkout_attempts(carts_df)

    print("Generating orders...")
    orders_df = generate_orders(checkout_df, carts_df)

    print("Generating events...")
    events_df = generate_cart_events(users_df, carts_df, checkout_df, orders_df)

    print("Generating abandonment...")
    abandonment_df = generate_abandonment_reasons(carts_df, checkout_df)

    print("Saving files...")

    users_df.to_csv(OUTPUT_DIR / "users.csv", index=False)
    products_df.to_csv(OUTPUT_DIR / "products.csv", index=False)
    carts_df.to_csv(OUTPUT_DIR / "carts.csv", index=False)
    cart_items_df.to_csv(OUTPUT_DIR / "cart_items.csv", index=False)
    checkout_df.to_csv(OUTPUT_DIR / "checkout_attempts.csv", index=False)
    orders_df.to_csv(OUTPUT_DIR / "orders.csv", index=False)
    events_df.to_csv(OUTPUT_DIR / "cart_events.csv", index=False)
    abandonment_df.to_csv(OUTPUT_DIR / "abandonment_reasons.csv", index=False)

    print("DONE 🚀")


if __name__ == "__main__":
    main()
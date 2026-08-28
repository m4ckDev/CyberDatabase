import os
import getpass
import psycopg2
from argon2 import PasswordHasher

username = input("CyberDeck admin username: ").strip()
password = getpass.getpass("CyberDeck admin password: ")
confirm = getpass.getpass("Confirm password: ")

if not username:
    raise SystemExit("Username cannot be empty.")

if len(password) < 12:
    raise SystemExit("Password must be at least 12 characters.")

if password != confirm:
    raise SystemExit("Passwords do not match.")

password_hash = PasswordHasher().hash(password)

with psycopg2.connect(os.environ["DATABASE_URL"]) as conn:
    with conn.cursor() as cur:
        cur.execute("""
            INSERT INTO users
                (username, password_hash, is_admin, is_active)
            VALUES
                (%s, %s, TRUE, TRUE)
            ON CONFLICT (username)
            DO UPDATE SET
                password_hash = EXCLUDED.password_hash,
                is_admin = TRUE,
                is_active = TRUE
            RETURNING id, username, is_admin, is_active;
        """, (username, password_hash))

        print(cur.fetchone())

print("CyberDeck administrator created successfully.")

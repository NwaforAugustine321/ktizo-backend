import logging
import time
from sys import stdout

from sqlalchemy import create_engine
from sqlalchemy.exc import OperationalError
from sqlalchemy.orm import sessionmaker


def wait_for_db(db_url):
    """checks if database connection is established"""

    _local_engine = create_engine(db_url, echo=True)
    _LocalSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=_local_engine)

    up = False
    while not up:
        try:
            # Try to create session to check if DB is awake

            print('Waiting for database...')

            db_session = _LocalSessionLocal()
            db_session.execute("SELECT 1")
            db_session.commit()

            print('DB Engine connected')

        except OperationalError as err:
            print(err)
            logging.error(f"Connection error: connection to server at {db_url} failed: Connection refused")
            logging.error('Waiting for reconnect...')
            up = False
        except Exception as err:
            logging.error(f"Connection error: {err}")
            up = False
        else:
            up = True
            db_session.close()

        time.sleep(5)

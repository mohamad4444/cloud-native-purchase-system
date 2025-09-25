import time
import logging
import random

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

messages = [
    "Starting process...",
    "Processing data...",
    "Still working...",
    "Task completed successfully!",
    "Something unexpected happened...",
]

while True:
    msg = random.choice(messages)
    logging.info(msg)
    time.sleep(2)  # wait 2 seconds before next log

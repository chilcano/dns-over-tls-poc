import logging

logging.basicConfig(filename="/var/log/dot/app.log", format='%(asctime)s %(message)s', filemode='w')
logger=logging.getLogger()
logger.setLevel(logging.INFO)

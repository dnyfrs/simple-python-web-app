#!/usr/bin/env python3

from flask import Flask, jsonify
import socket, time, random
from datetime import datetime
from werkzeug.middleware.dispatcher import DispatcherMiddleware
from prometheus_client import make_wsgi_app, Summary, Counter

app = Flask(__name__)

# Do not sort JSON keys since the required
# response has an ordered list of a, b, c...
app.config['JSON_SORT_KEYS'] = False

view = Counter('view', 'View count')
duration = Summary('duration_compute_seconds', 'Time spent in functions')
exception = Counter('compute_exception', 'Exception thrown in functions')
request_processing = Summary('request_processing_seconds', 'Time spent processing request')


@exception.count_exceptions()
@duration.time()
def gethostname():
    """ Return the hostname
    :return: string type socket.gethostname()
    """
    return socket.gethostname()


@exception.count_exceptions()
@duration.time()
def gettimestamp():
    """ Return the current date and time in ISO 8601
    :return: string type datetime.utcnow().isoformat()
    """
    return datetime.utcnow().isoformat()


@request_processing.time()
@app.route("/")
def hello():
    hostname = gethostname()
    timestamp = gettimestamp()
    response = jsonify(
        Timestamp=timestamp,
        hostname=hostname
    )
    view.inc()
    return response


# Add prometheus wsgi middleware to route /metrics requests
app.wsgi_app = DispatcherMiddleware(app.wsgi_app, {
    '/metrics': make_wsgi_app()
})

if __name__ == "__main__":
    app.run()

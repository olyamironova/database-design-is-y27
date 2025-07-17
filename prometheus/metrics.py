from prometheus_client import Summary, Counter, Histogram

QUERY_TIME = Summary(
    'custom_query_duration_seconds',
    'Time spent executing custom queries',
    ['query_name', 'optimized']
)

QUERY_COUNTER = Counter(
    'custom_query_calls_total',
    'Total number of query executions',
    ['query_name', 'optimized']
)

QUERY_DURATION_HISTOGRAM = Histogram(
    'custom_query_duration_histogram_seconds',
    'Histogram of query durations',
    ['query_name', 'optimized'],
    buckets=[0.1, 0.5, 1, 2, 5, 10]
)

QUERY_ERRORS = Counter(
    'custom_query_errors_total',
    'Total number of query errors',
    ['query_name', 'optimized']
)

import asyncio
import httpx
import time

BASE_URL = "http://localhost:8000"

ENDPOINTS = [
    "/report/weather-analysis-by-region",
    "/report/user-activity",
    "/report/sensor-performance",
    "/report/health-recommendations",
    "/report/station-maintenance"
]

REQUESTS_PER_ENDPOINT = 5000
CONCURRENT_WORKERS = 10

async def fetch(client: httpx.AsyncClient, endpoint: str):
    try:
        resp = await client.get(BASE_URL + endpoint)
        resp.raise_for_status()
        return resp.status_code
    except Exception as e:
        print(f"Error fetching {endpoint}: {e}")
        return None

async def worker(semaphore: asyncio.Semaphore, client: httpx.AsyncClient, endpoint: str, results: list):
    async with semaphore:
        status = await fetch(client, endpoint)
        results.append(status)

async def run_load_test():
    semaphore = asyncio.Semaphore(CONCURRENT_WORKERS)
    results = []

    async with httpx.AsyncClient(timeout=30) as client:
        tasks = []
        for endpoint in ENDPOINTS:
            for _ in range(REQUESTS_PER_ENDPOINT):
                tasks.append(worker(semaphore, client, endpoint, results))
        start = time.perf_counter()
        await asyncio.gather(*tasks)
        end = time.perf_counter()

    success_count = sum(1 for r in results if r == 200)
    failed_count = len(results) - success_count
    print(f"Total requests: {len(results)}")
    print(f"Successful responses: {success_count}")
    print(f"Failed responses: {failed_count}")
    print(f"Total time: {end - start:.2f} seconds")
    print(f"Requests per second: {len(results) / (end - start):.2f}")

if __name__ == "__main__":
    asyncio.run(run_load_test())

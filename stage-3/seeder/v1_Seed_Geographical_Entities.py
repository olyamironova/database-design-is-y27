from base import *

def seed_v1(seeder):
    print(">> Running V1 seed...")
    list(seeder.seed_countries())
    list(seeder.seed_regions())
    list(seeder.seed_cities())
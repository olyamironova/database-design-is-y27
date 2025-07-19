from v1_Seed_Geographical_Entities import seed_v1
from v2_Seed_Weather_Entities import seed_v2
from v3_Seed_User_Entities import seed_v3
from v4_Seed_Notification_Entities import seed_v4
from v5_Seed_External_Data_Entities import seed_v5
from v6_Seed_Maintenance_Entities import seed_v6
from v7_Seed_Survey_Entities import seed_v7
VERSIONS = {
    "1": seed_v1,
    "2": seed_v2,
    "3": seed_v3,
    "4": seed_v4,
    "5": seed_v5,
    "6": seed_v6,
    "7": seed_v7,
    "latest": seed_v7
}

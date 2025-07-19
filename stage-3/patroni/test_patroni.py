import time
import requests
import subprocess

NODES = [
    {"name": "patroni1", "url": "http://localhost:8008"},
    {"name": "patroni2", "url": "http://localhost:8009"}
    {"name": "patroni3", "url": "http://localhost:8010"},
]

def get_roles():
    roles = {}
    for node in NODES:
        try:
            r = requests.get(f"{node['url']}/patroni")
            r.raise_for_status()
            data = r.json()
            roles[node['name']] = data.get('role')
        except Exception as e:
            roles[node['name']] = f"error: {e}"
    return roles

def find_master(roles):
    for node, role in roles.items():
        if role == "master":
            return node
    return None

def stop_master_container(master_node_name):
    print(f"Останавливаем мастер-контейнер: {master_node_name}")
    subprocess.run(["docker", "stop", master_node_name], check=True)

def start_master_container(master_node_name):
    print(f"Запускаем мастер-контейнер: {master_node_name}")
    subprocess.run(["docker", "start", master_node_name], check=True)

def wait_for_new_master(old_master, timeout=60):
    print("Ждём автоматическое переключение мастера...")
    start = time.time()
    while time.time() - start < timeout:
        roles = get_roles()
        master = find_master(roles)
        if master and master != old_master:
            print(f"Новый мастер: {master}")
            return master
        time.sleep(3)
    print("Не удалось обнаружить нового мастера в отведённое время")
    return None

if __name__ == "__main__":
    print("Текущий статус ролей:")
    roles = get_roles()
    for node, role in roles.items():
        print(f"{node}: {role}")

    master = find_master(roles)
    if not master:
        print("Мастер не найден, проверьте конфигурацию.")
        exit(1)

    print(f"Текущий мастер: {master}")

    stop_master_container(master)

    new_master = wait_for_new_master(master)
    if new_master:
        print("Failover успешно прошёл!")
    else:
        print("Failover не произошёл.")

    start_master_container(master)

    print("Проверка завершена.")

import requests
import random
import string
from datetime import datetime

class CustomLibraries():
    def get_random_customers(self, start=1, count=5):
        response = requests.get("https://jsonplaceholder.typicode.com/users", verify=True)
        users = response.json()

        for i in users:
            i["birthday"] = self.get_random_birthday()
            i["password"] = self.generate_password()
            i["stateAbbr"] = str(i["address"]["street"][0]) + str(i["address"]["suite"][0]) + str(i["address"]["city"][0])

        start_index = max(0, start - 1)
        end_index = start_index + count
        end_index = min(end_index, len(users))

        sliced = users[start_index:end_index]
        print(sliced)
        return sliced

    def get_random_birthday(self):
        return str(random.randint(1, 12)).zfill(2) + str(random.randint(1, 28)).zfill(2) + str(random.randint(1999, 2006))

    def generate_password(self, length=8):
        chars = string.ascii_letters + string.digits + "!@#$%"
        return ''.join(random.choice(chars) for _ in range(length))

    def format_birthday(self, birthday_str):
        birthday_str = str(birthday_str).strip()
        if "-" in birthday_str:
            dt = datetime.strptime(birthday_str, "%Y-%m-%d")
            return dt.strftime("%m%d%Y")
        elif len(birthday_str) == 8 and birthday_str.isdigit():
            return birthday_str
        else:
            raise ValueError(f"Unsupported birthday format: {birthday_str}")
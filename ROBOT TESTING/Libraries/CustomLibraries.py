import requests
import random
import string
from datetime import datetime

class CustomLibraries():
    def get_random_customers(self):
        response = requests.get("https://jsonplaceholder.typicode.com/users", verify=True)
        users = response.json()
        first_five_customers = users[:5]
        for i in first_five_customers:
            i["birthday"] = self.get_random_birthday()
            i["password"] = self.generate_password()
            i["stateAbbr"] = str(i["address"]["street"][0]) + str(i["address"]["suite"][0]) + str(i["address"]["city"][0])
        print(first_five_customers)
        return first_five_customers

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
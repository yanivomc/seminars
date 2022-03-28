import time
from locust import HttpUser, task, between

class QuickstartUser(HttpUser):
    
    @task
    def login(self):
        self.client.get("/")

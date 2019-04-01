from django.db import models

# Create your models here.

class Estado(models.Model):
	funcion = models.CharField(max_length=100)
	name = models.CharField(max_length=100)

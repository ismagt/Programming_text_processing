from django.shortcuts import render
from django.urls import path
from django.http import HttpResponse, HttpResponseRedirect
from .models import Url
from django.views.decorators.csrf import csrf_exempt
import socket
from django.core.exceptions import ObjectDoesNotExist

# Create your views here.

formulario1 = """

<form action = "" method ="POST">
	Escriba la URL:<br>
	<input type="text" name="key"><br><br>
	<input type="submit" value="Enviar">
	</form>
"""

@csrf_exempt
def formulario(request):
	if request.method == "GET":
		todos = Url.objects.all()
		url_original = ""
		url_acortada = ""
		total = ""
		for elements in todos:
			url_original = "La URL original es : " + elements.direccion 
			url_acortada = "La URL acortada es : " + request.build_absolute_uri() + str(elements.id) 
			total += url_original + "---->" + url_acortada + "<br>"
		response = formulario1 + "Actualmente en la base de datos " + "<br>" + total
	elif request.method == "POST":
		protocolo = request.POST['key'].split("://")[0]
		if protocolo == "https" or protocolo == "http":
			url = Url(direccion = request.POST['key'])
		else:
			contenido = "http://" + request.POST['key']
			url = Url(direccion = contenido)
		try:
			url = Url.objects.get(direccion = url.direccion)
			response = "La URL original es : " + str(url.direccion) + "<br>" + "La URL acortada es : " +  request.build_absolute_uri() + str(url.id)
		except Url.DoesNotExist:					
			url.save()
			num = str(url.id)
			response = "La URL original es : " + str(url.direccion) + "<br>" + "La URL acortada es : " +  request.build_absolute_uri() + num			
	return HttpResponse(response)

def redirreccion (request, acortada):
	url = Url.objects.get(id = acortada)
	direc = url.direccion
	return  HttpResponseRedirect(direc)
	

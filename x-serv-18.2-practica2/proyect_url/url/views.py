from django.shortcuts import render
from django.urls import path
from django.http import HttpResponse, HttpResponseRedirect
from .models import Url
from django.views.decorators.csrf import csrf_exempt
import socket

# Create your views here.

formulario1 = """

<form action = "" method ="POST">
	Escriba la URL:<br>
	<input type="text" name="key"><br><br>
	<input type="submit" value="Enviar">
	</form>
"""

#~ pagina = """
#~ <p>
	#~ La URL original es : <a href= {urloriginal}> {urloriginal} </a>
	#~ La URL acortada es : <a href= {urloriginal}> {urlacortada} </a>
#~ </p>
#~ """

@csrf_exempt
def formulario(request):
	if request.method == "GET":
		todos = Url.objects.all()
		total = ""
		for elements in todos:
			total += elements.direccion + "<br>"
		response = formulario1 + "Actualmente en la base de datos " + "<br>"+ total 
	elif request.method == "POST":
		url = Url(direccion=request.POST['key'])
		url.save()
		num = str(Url.objects.get(direccion=request.POST['key']))
		print(num)
		response = "La URL original es : " + str(request.POST['key']) + "<br>" + "La URL acortada es : " +  request.build_absolute_uri()  + num
	return HttpResponse(response)

def redirreccion (request, acortada):
	url = Url.objects.get(id=acortada)
	direc = url.direccion
	return  HttpResponseRedirect(direc)
	

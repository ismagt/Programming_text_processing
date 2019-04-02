from django.shortcuts import render
from django.urls import path
from django.http import HttpResponse, HttpResponseRedirect
from .models import Url
from django.views.decorators.csrf import csrf_exempt
import socket
from django.core.exceptions import ObjectDoesNotExist

# Create your views here.

formulario1 = """

<head>
  <title>acortador de URL's</title>
</head>
<font color="red" size=6>Bienvenido al acortador de URL's</font>
<form action = "" method ="POST">
<br>
	Escriba la URL:<br>
	<input type="text" name="key"><br><br>
	<input type="submit" value="Enviar">
	</form>
<font color="red" size=4>Actualmente en la base de datos existen:</font> <br> <br>	
"""

page_template = """
<p><a href="/"> Volver a la pagina de inicio</a></p> <br> <br>
<head>
  <title>URL acortada</title>
</head>
<font color="blue" size=5>Enorabuena se ha acortado su URL correctamente</font> <br> <br>
 La URL original es : <a href="{url_original}"> {url_original} </a> <br> <br>
 La URL acortada es : <a href="{url_original}"> {url_acortada} </a> 

"""

page_template_database = """
 La URL original es : <a href="{url_original}"> {url_original} </a>  >>>
 La URL acortada es : <a href="{url_original}"> {url_acortada} </a> <br>  <br>

"""

@csrf_exempt
def formulario(request):
	if request.method == "GET":
		todos = Url.objects.all()
		url_original = ""
		url_acortada = ""
		total = ""
		for elements in todos:
			url_original = elements.direccion 
			url_acortada = request.build_absolute_uri() + str(elements.id) 
			total += page_template_database.format(url_original=url_original, url_acortada=url_acortada)	 
		response = formulario1 + total
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
			url_original = str(url.direccion)
			url_acortada = request.build_absolute_uri() + num
			response = page_template.format(url_original=url_original, url_acortada=url_acortada)			
	return HttpResponse(response)

def redirreccion (request, acortada):
	url = Url.objects.get(id = acortada)
	direc = url.direccion
	return  HttpResponseRedirect(direc)
	

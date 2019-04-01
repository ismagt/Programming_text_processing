from django.shortcuts import render
from django.http import HttpResponse
from .models import Estado
# Create your views here.


def suma(request, numero):

	#~ print("Ha entrado suma")
	
	#~ if not Estado.objects.filter(funcion = 'suma'):
		#~ print("Ha entrado if")
		#~ numero1 = Estado.objects.get(funcion='suma')
		#~ numero2 = numero
		#~ return HttpResponse('<html><head></head><body><h1>Usted ha implementado la funcion SUMA</h1></body></html>' +
		#~ str(numero1) + "-" + str(numero2) + "=" + str(numero1 - numero2))	
		
	#~ else:
	print("Ha entrado else")
	data_function = Estado(funcion = 'suma')
	data_num = Estado(name=numero)
	data_num.save();
	data_function.save(); 
	return HttpResponse('<html><head></head><body><h1>Usted ha guargado en la base de datos</h1></body></html>' 
	+ str(numero) + 'Con la funcion suma')
	

	#return HttpResponse('<html><head></head><body><h1>Usted ha implementado la funcion SUMA</h1></body></html>' +
	#str(numero1) + "+" + str(numero1) + "=" + str(numero1 + numero1))
def resta(request, numero1,numero2):
	return HttpResponse('<html><head></head><body><h1>Usted ha implementado la funcion RESTA</h1></body></html>' +
	str(numero1) + "-" + str(numero2) + "=" + str(numero1 - numero2))	
def multi(request, numero1, numero2):
	return HttpResponse('<html><head></head><body><h1>Usted ha implementado la funcion MULTIPLICAR</h1></body></html>' +
	str(numero1) + "*" + str(numero2) + "=" + str(numero1 * numero2))
def divi(request, numero1, numero2):
	try:
		return HttpResponse('<html><head></head><body><h1>Usted ha implementado la funcion DIVISION</h1></body></html>' +
		str(numero1) + "/" + str(numero2) + "=" + str(numero1 / numero2))
	except ZeroDivisionError:
		return HttpResponse('<html><head></head><body><h1>INDETERMINACION</h1></body></html>')
	
def barra(request):
	return HttpResponse('<html><head></head><body><h1>Bienvenido a la calculadora en django</h1></body></html>')

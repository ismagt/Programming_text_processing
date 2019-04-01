from django.shortcuts import render
from django.http import HttpResponse
from .models import Estado
# Create your views here.

try:	
	
	def suma(request, numero):
		
		if Estado.objects.filter(funcion = 'suma').exists():
			numero1 = str(Estado.objects.filter(funcion = 'suma').values('name'))
			numero1=numero1.split(":")[1]
			numero1=numero1.split("}")[0]
			numero2 = numero
			Estado.objects.filter(funcion='suma').delete()
			resultado = int(numero1) + int(numero2)
			return HttpResponse('<html><head></head><body><h1>Usted ha implementado la funcion SUMA</h1></body></html>' +
			str(numero1) + "+" + str(numero2) + "="	+ str(resultado))
			
		else:
			data_function = Estado(funcion = 'suma', name=numero)
			data_function.save(); 
			return HttpResponse('<html><head></head><body><h1>Usted ha guargado en la base de datos</h1></body></html>' 
			+ str(numero) + 'Con la funcion suma')
	
	def resta(request, numero):
		if Estado.objects.filter(funcion = 'resta').exists():
			numero1 = str(Estado.objects.filter(funcion = 'resta').values('name'))
			numero1=numero1.split(":")[1]
			numero1=numero1.split("}")[0]
			numero2 = numero
			Estado.objects.filter(funcion='resta').delete()
			resultado = int(numero1) - int(numero2)
			return HttpResponse('<html><head></head><body><h1>Usted ha implementado la funcion RESTA</h1></body></html>' +
			str(numero1) + "-" + str(numero2) + "="	+ str(resultado))
			
		else:
			data_function = Estado(funcion = 'resta', name=numero)
			data_function.save(); 
			return HttpResponse('<html><head></head><body><h1>Usted ha guargado en la base de datos</h1></body></html>' 
			+ str(numero) + ' Con la funcion resta')

	def multi(request, numero):
		if Estado.objects.filter(funcion = 'multi').exists():
			numero1 = str(Estado.objects.filter(funcion = 'multi').values('name'))
			numero1=numero1.split(":")[1]
			numero1=numero1.split("}")[0]
			numero2 = numero
			Estado.objects.filter(funcion='multi').delete()
			resultado = int(numero1) * int(numero2)
			return HttpResponse('<html><head></head><body><h1>Usted ha implementado la funcion MULTIPLICAR</h1></body></html>' +
			str(numero1) + " X " + str(numero2) + " = "	+ str(resultado))
			
		else:
			data_function = Estado(funcion = 'multi', name=numero)
			data_function.save(); 
			return HttpResponse('<html><head></head><body><h1>Usted ha guargado en la base de datos</h1></body></html>' 
			+ str(numero) + ' Con la funcion multi')


	def divi(request, numero):
		try:
			if Estado.objects.filter(funcion = 'div').exists():
				numero1 = str(Estado.objects.filter(funcion = 'div').values('name'))
				numero1=numero1.split(":")[1]
				numero1=numero1.split("}")[0]
				numero2 = numero
				Estado.objects.filter(funcion='div').delete()
				resultado = int(numero1) / int(numero2)
				return HttpResponse('<html><head></head><body><h1>Usted ha implementado la funcion DIVISION</h1></body></html>' +
				str(numero1) + "/" + str(numero2) + "="	+ str(resultado))
				
			else:
				data_function = Estado(funcion = 'div', name=numero)
				data_function.save(); 
				return HttpResponse('<html><head></head><body><h1>Usted ha guargado en la base de datos</h1></body></html>' 
				+ str(numero) + ' Con la funcion DIVISION')

		except ZeroDivisionError:
			return HttpResponse('<html><head></head><body><h1>INDETERMINACION</h1></body></html>')
		
	def barra(request):
		return HttpResponse('<html><head></head><body><h1>Bienvenido a la calculadora en django</h1></body></html>')

except Pages.DoesNotExist:
	HttpResponseNotFound('Page not found')

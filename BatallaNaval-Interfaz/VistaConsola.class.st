"
Vista de consola del juego. Muestra tableros, naves, resultados y errores en el Transcript, y le pide al usuario coordenadas, orientaciones y opciones de menú. No conoce las reglas del juego: solo presenta los datos que le entrega ControladorConsola.
"
Class {
	#name : 'VistaConsola',
	#superclass : 'Object',
	#instVars : [
		'salida'
	],
	#category : 'BatallaNaval-Interfaz',
	#package : 'BatallaNaval-Interfaz'
}

{ #category : 'as yet unclassified' }
VistaConsola class >> salida: unStream [

	^ self new setSalida: unStream
]

{ #category : 'initialization' }
VistaConsola >> initialize [

	super initialize.
	salida := Transcript
]

{ #category : 'initialization' }
VistaConsola >> setSalida: unStream [

	salida := unStream
]

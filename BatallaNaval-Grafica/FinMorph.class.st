"
Cartel de fin de partida.
"
Class {
	#name : 'FinMorph',
	#superclass : 'Morph',
	#instVars : [
		'controlador'
	],
	#category : 'BatallaNaval-Grafica',
	#package : 'BatallaNaval-Grafica'
}

{ #category : 'instance creation' }
FinMorph class >> controlador: unControlador [
	^ self new setControlador: unControlador
]

{ #category : 'drawing' }
FinMorph >> drawOn: unCanvas [
	| lineas y |
	Lapiz caja: bounds en: unCanvas relleno: Lapiz papelClaro semilla: 9.
	Lapiz
		textoCentrado: controlador tituloFin en: unCanvas
		rect: (bounds left @ (bounds top + 22) extent: bounds width @ 40)
		fuente: (Lapiz fuenteTitulo: 20) color: Lapiz grafito.
	y := bounds top + 78.
	lineas := Lapiz lineasDe: controlador textoFin ancho: bounds width - 40 fuente: (Lapiz fuenteCuerpo: 10).
	lineas do: [ :l |
		Lapiz
			textoCentrado: l en: unCanvas
			rect: (bounds left @ y extent: bounds width @ 20)
			fuente: (Lapiz fuenteCuerpo: 10) color: Lapiz grafito.
		y := y + 20 ]
]

{ #category : 'events' }
FinMorph >> handlesMouseDown: unEvento [
	^ true
]

{ #category : 'initialization' }
FinMorph >> initialize [
	super initialize.
	self color: Color transparent
]

{ #category : 'events' }
FinMorph >> mouseDown: unEvento [
	"Absorbe el clic para que no llegue a los tableros que quedan debajo."
	^ self
]

{ #category : 'initialization' }
FinMorph >> setControlador: unControlador [
	controlador := unControlador.
	self extent: 440 @ 210.
	self
		addMorph: ((BotonLapizMorph
			rotulo: [ 'Jugar otra vez' ] habilitado: [ true ] activo: [ false ]
			accion: [ controlador nuevaPartida ]) position: self position + (60 @ 140)).
	self
		addMorph: ((BotonLapizMorph
			rotulo: [ 'Ver los tableros' ] habilitado: [ true ] activo: [ false ]
			accion: [ controlador ocultarFin ]) position: self position + (240 @ 140))
]

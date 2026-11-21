"
Ficha de una nave de la flota; al tocarla se la elige.
"
Class {
	#name : 'ChipNaveMorph',
	#superclass : 'Morph',
	#instVars : [
		'nave',
		'controlador',
		'propia'
	],
	#category : 'BatallaNaval-Grafica',
	#package : 'BatallaNaval-Grafica'
}

{ #category : 'instance creation' }
ChipNaveMorph class >> nave: unaNave controlador: unControlador propia: unBooleano [
	^ self new setNave: unaNave controlador: unControlador propia: unBooleano
]

{ #category : 'testing' }
ChipNaveMorph >> activo [
	^ controlador chipActivo: nave propia: propia
]

{ #category : 'drawing' }
ChipNaveMorph >> drawOn: unCanvas [
	| rect seleccionada activa ancho x0 tinta |
	rect := bounds insetBy: 1.
	seleccionada := controlador seleccion == nave and: [ propia ].
	activa := self activo.
	seleccionada ifTrue: [ unCanvas fillRectangle: rect color: (Lapiz rojoLapiz alpha: 0.12) ].
	tinta := seleccionada ifTrue: [ Lapiz rojoLapiz ] ifFalse: [ Lapiz grafito alpha: (activa ifTrue: [ 0.9 ] ifFalse: [ 0.5 ]) ].
	Lapiz
		poligono: { rect topLeft. rect topRight. rect bottomRight. rect bottomLeft }
		cerrado: true en: unCanvas ancho: (seleccionada ifTrue: [ 2 ] ifFalse: [ 1 ]) color: tinta semilla: nave tamano * 7 + bounds left.
	ancho := nave tamano * 15 - 2.
	x0 := bounds center x - (ancho // 2).
	1 to: nave tamano do: [ :i |
		| r |
		r := (x0 + ((i - 1) * 15)) @ (bounds top + 5) extent: 13 @ 13.
		(propia not or: [ nave estaUbicada ])
			ifTrue: [ Lapiz hachurar: r en: unCanvas separacion: 3.6 ancho: 1 color: (Lapiz grafito alpha: 0.62) direccion: -1 ].
		(self segmentoGolpeado: i) ifTrue: [
			unCanvas fillRectangle: r color: (Lapiz papelClaro alpha: 0.9).
			Lapiz cruz: r center radio: 5 en: unCanvas ancho: 2 color: (nave estaHundida ifTrue: [ Lapiz rojoLapiz ] ifFalse: [ Lapiz grafito ]) semilla: i ].
		unCanvas frameRectangle: r width: 1 color: Lapiz grafito ].
	Lapiz
		textoCentrado: nave class name asString en: unCanvas
		rect: (bounds left @ (bounds top + 19) extent: bounds width @ 14)
		fuente: (Lapiz fuenteCuerpo: 8) color: (nave estaHundida ifTrue: [ Lapiz rojoLapiz ] ifFalse: [ Lapiz grafito ]).
	Lapiz
		textoCentrado: self nota en: unCanvas
		rect: (bounds left @ (bounds top + 31) extent: bounds width @ 12)
		fuente: (Lapiz fuenteCuerpo: 7) color: Lapiz rojoLapiz
]

{ #category : 'events' }
ChipNaveMorph >> handlesMouseDown: unEvento [
	^ true
]

{ #category : 'initialization' }
ChipNaveMorph >> initialize [
	super initialize.
	self color: Color transparent
]

{ #category : 'events' }
ChipNaveMorph >> mouseUp: unEvento [
	(self activo and: [ self containsPoint: unEvento position ]) ifTrue: [ controlador elegirNave: nave ]
]

{ #category : 'accessing' }
ChipNaveMorph >> nave [
	^ nave
]

{ #category : 'accessing' }
ChipNaveMorph >> nota [
	nave estaHundida ifTrue: [ ^ 'hundida' ].
	(propia and: [ nave estaUbicada not ]) ifTrue: [ ^ 'sin ubicar' ].
	(propia and: [ nave recargaRestante > 0 ]) ifTrue: [ ^ 'recarga ', nave recargaRestante printString ].
	(propia and: [ (nave respondsTo: #estaSumergido) and: [ nave estaSumergido ] ]) ifTrue: [ ^ 'sumergido' ].
	^ ''
]

{ #category : 'testing' }
ChipNaveMorph >> segmentoGolpeado: unIndice [
	| posicion |
	propia ifFalse: [ ^ unIndice <= nave cantidadDeImpactos ].
	nave estaUbicada ifFalse: [ ^ false ].
	posicion := nave posiciones at: unIndice.
	^ (controlador partida tablero casillaEn: posicion) estaAtacada
]

{ #category : 'initialization' }
ChipNaveMorph >> setNave: unaNave controlador: unControlador propia: unBooleano [
	nave := unaNave.
	controlador := unControlador.
	propia := unBooleano.
	self extent: 82 @ 44
]

"
Botón dibujado a lápiz cuyo estado sale de bloques.
"
Class {
	#name : 'BotonLapizMorph',
	#superclass : 'Morph',
	#instVars : [
		'rotulo',
		'habilitado',
		'activo',
		'accion'
	],
	#category : 'BatallaNaval-Grafica',
	#package : 'BatallaNaval-Grafica'
}

{ #category : 'instance creation' }
BotonLapizMorph class >> rotulo: unBloqueRotulo habilitado: unBloqueHabilitado activo: unBloqueActivo accion: unBloqueAccion [
	^ self new setRotulo: unBloqueRotulo habilitado: unBloqueHabilitado activo: unBloqueActivo accion: unBloqueAccion
]

{ #category : 'drawing' }
BotonLapizMorph >> drawOn: unCanvas [
	| rect habil fondo tinta |
	habil := self estaHabilitado.
	rect := bounds insetBy: 2.
	fondo := (activo value ifTrue: [ Lapiz rojoLapiz alpha: 0.18 ] ifFalse: [ Lapiz papelClaro alpha: 0.75 ]).
	unCanvas fillRectangle: (rect translateBy: 2 @ 3) color: (Lapiz grafito alpha: (habil ifTrue: [ 0.22 ] ifFalse: [ 0.08 ])).
	unCanvas fillRectangle: rect color: fondo.
	tinta := activo value ifTrue: [ Lapiz rojoLapiz ] ifFalse: [ Lapiz grafito ].
	habil
		ifTrue: [
			Lapiz
				poligono: { rect topLeft. rect topRight. rect bottomRight. rect bottomLeft }
				cerrado: true en: unCanvas ancho: 2 color: tinta semilla: bounds left + bounds top ]
		ifFalse: [
			Lapiz rectanguloPunteado: rect en: unCanvas ancho: 1 color: (Lapiz grafito alpha: 0.5) ].
	Lapiz
		textoCentrado: rotulo value en: unCanvas
		rect: (bounds left @ (bounds top + 6) extent: bounds width @ 20)
		fuente: (Lapiz fuenteCuerpo: 9) color: (habil ifTrue: [ tinta ] ifFalse: [ Lapiz grafito alpha: 0.42 ])
]

{ #category : 'testing' }
BotonLapizMorph >> estaHabilitado [
	^ habilitado value
]

{ #category : 'events' }
BotonLapizMorph >> handlesMouseDown: unEvento [
	^ true
]

{ #category : 'initialization' }
BotonLapizMorph >> initialize [
	super initialize.
	self color: Color transparent
]

{ #category : 'events' }
BotonLapizMorph >> mouseUp: unEvento [
	(self estaHabilitado and: [ self containsPoint: unEvento position ]) ifTrue: [ accion value ]
]

{ #category : 'initialization' }
BotonLapizMorph >> setRotulo: unBloqueRotulo habilitado: unBloqueHabilitado activo: unBloqueActivo accion: unBloqueAccion [
	rotulo := unBloqueRotulo.
	habilitado := unBloqueHabilitado.
	activo := unBloqueActivo.
	accion := unBloqueAccion.
	self extent: 108 @ 30
]

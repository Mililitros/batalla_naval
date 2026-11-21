"
Pasos narrados de una jugada, para el diario de a bordo.
"
Class {
	#name : 'JugadaNarrada',
	#superclass : 'Object',
	#instVars : [
		'titulo',
		'pasos',
		'terminada'
	],
	#category : 'BatallaNaval-Grafica',
	#package : 'BatallaNaval-Grafica'
}

{ #category : 'instance creation' }
JugadaNarrada class >> titulo: unTitulo [
	^ self new setTitulo: unTitulo
]

{ #category : 'actions' }
JugadaNarrada >> agregarPaso: unTexto [
	pasos add: unTexto -> nil
]

{ #category : 'actions' }
JugadaNarrada >> agregarPaso: unTexto estilo: unEstilo [
	pasos add: unTexto -> unEstilo
]

{ #category : 'accessing' }
JugadaNarrada >> pasos [
	^ pasos
]

{ #category : 'actions' }
JugadaNarrada >> reemplazarPrimerPaso: unTexto [
	pasos isEmpty
		ifTrue: [ self agregarPaso: unTexto ]
		ifFalse: [ pasos at: 1 put: unTexto -> nil ]
]

{ #category : 'initialization' }
JugadaNarrada >> setTitulo: unTitulo [
	titulo := unTitulo.
	pasos := OrderedCollection new.
	terminada := false
]

{ #category : 'testing' }
JugadaNarrada >> terminada [
	^ terminada
]

{ #category : 'actions' }
JugadaNarrada >> terminar [
	terminada := true
]

{ #category : 'accessing' }
JugadaNarrada >> titulo [
	^ titulo
]

{ #category : 'accessing' }
JugadaNarrada >> titulo: unTitulo [
	titulo := unTitulo
]

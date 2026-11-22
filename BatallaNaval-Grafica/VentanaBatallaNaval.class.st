"
Ventana principal: arma los morphs y los refresca.
"
Class {
	#name : 'VentanaBatallaNaval',
	#superclass : 'Morph',
	#instVars : [
		'controlador',
		'fondo',
		'divisor',
		'tableroPropio',
		'tableroRival',
		'diario',
		'fin',
		'chips',
		'versionVista'
	],
	#category : 'BatallaNaval-Grafica',
	#package : 'BatallaNaval-Grafica'
}

{ #category : 'instance creation' }
VentanaBatallaNaval class >> controlador: unControlador [
	^ self new setControlador: unControlador
]

{ #category : 'opening' }
VentanaBatallaNaval >> abrir [
	self openInWindowLabeled: 'Batalla Naval'.
	self startStepping
]

{ #category : 'stepping' }
VentanaBatallaNaval >> actualizarFin [
	controlador finVisible
		ifTrue: [
			fin owner isNil ifTrue: [
				fin position: self position + (250 @ 250).
				self addMorphFront: fin ] ]
		ifFalse: [ fin owner notNil ifTrue: [ fin delete ] ]
]

{ #category : 'background' }
VentanaBatallaNaval >> archivoDeFondo [
	{ FileLocator imageDirectory. FileLocator workingDirectory } do: [ :carpeta |
		| ref |
		ref := carpeta resolve / 'fondo-batalla-naval.png'.
		ref exists ifTrue: [ ^ ref ] ].
	^ nil
]

{ #category : 'building' }
VentanaBatallaNaval >> armar [
	| origen |
	origen := self position.
	divisor := DivisorMorph new.
	divisor extent: 58 @ 442.
	divisor position: origen + (448 @ 104).
	self addMorph: divisor.
	tableroPropio := TableroMorph controlador: controlador lado: #propio.
	tableroPropio position: origen + (16 @ 104).
	self addMorph: tableroPropio.
	tableroRival := TableroMorph controlador: controlador lado: #rival.
	tableroRival position: origen + (514 @ 104).
	self addMorph: tableroRival.
	diario := DiarioMorph controlador: controlador.
	diario position: origen + (976 @ 104).
	self addMorph: diario.
	fin := FinMorph controlador: controlador.
	self armarBotones
]

{ #category : 'building' }
VentanaBatallaNaval >> armarBotones [
	| definiciones |
	definiciones := {
		{ [ 'Rotar (' , (controlador orientacion = #horizontal ifTrue: [ 'horiz.' ] ifFalse: [ 'vert.' ]) , ')' ]. [ controlador puedeRotar ]. [ false ]. [ controlador rotar ] }.
		{ [ 'Cancelar' ]. [ controlador puedeCancelar ]. [ false ]. [ controlador cancelar ] }.
		{ [ 'Atacar' ]. [ controlador puedeModoAtacar ]. [ controlador modo = #atacar and: [ controlador seleccion notNil ] ]. [ controlador modoAtacar ] }.
		{ [ 'Reubicar' ]. [ controlador puedeModoReubicar ]. [ controlador modo = #reubicar and: [ controlador seleccion notNil ] ]. [ controlador modoReubicar ] }.
		{ [ '¡Fuego!' ]. [ controlador puedeDisparar ]. [ false ]. [ controlador disparar ] }.
		{ [ 'Pasar turno' ]. [ controlador puedePasar ]. [ false ]. [ controlador pasarTurnoHumano ] }.
		{ [ 'Minas al azar' ]. [ controlador puedeMinasAlAzar ]. [ false ]. [ controlador minasAlAzar ] }.
		{ [ 'Naves al azar' ]. [ controlador puedeNavesAlAzar ]. [ false ]. [ controlador navesAlAzar ] }.
		{ [ controlador rotuloDemo ]. [ true ]. [ controlador demo ]. [ controlador iniciarDemo ] }.
		{ [ controlador rotuloTerminar ]. [ controlador puedeTerminar ]. [ false ]. [ controlador terminarJuego ] }.
		{ [ controlador rotuloNueva ]. [ true ]. [ false ]. [ controlador nuevaPartida ] } }.
	definiciones doWithIndex: [ :d :i |
		| boton |
		boton := BotonLapizMorph rotulo: (d at: 1) habilitado: (d at: 2) activo: (d at: 3) accion: (d at: 4).
		boton position: self position + ((976 + ((i - 1) \\ 2 * 132)) @ (444 + ((i - 1) // 2 * 38))).
		self addMorph: boton ]
]

{ #category : 'background' }
VentanaBatallaNaval >> cargarFondo [
	^ [ | archivo |
		archivo := self archivoDeFondo.
		archivo isNil
			ifTrue: [ false ]
			ifFalse: [ (PNGReadWriter formFromStream: archivo binaryReadStream) scaledToSize: self extent ] ]
		on: Error
		do: [ :error | false ]
]

{ #category : 'drawing' }
VentanaBatallaNaval >> dibujarCabeceraEn: unCanvas [
	| o |
	o := bounds origin.
	Lapiz
		texto: 'Batalla Naval' en: unCanvas
		rect: ((o x + 24) @ (o y + 6) extent: 360 @ 56)
		fuente: (Lapiz fuenteTitulo: 30) color: Lapiz grafito.
	Lapiz linea: (o x + 26) @ (o y + 66) a: (o x + 330) @ (o y + 64) en: unCanvas ancho: 2 color: (Lapiz grafito alpha: 0.7) semilla: 3.
	Lapiz barcoDePapel: (o x + 400) @ (o y + 46) escala: 12 en: unCanvas semilla: 11.
	Lapiz barcoDePapel: (o x + 452) @ (o y + 52) escala: 8 en: unCanvas semilla: 13.
	Lapiz barcoDePapel: (o x + 494) @ (o y + 44) escala: 10 en: unCanvas semilla: 17.
	Lapiz caja: ((o x + 640) @ (o y + 14) extent: 330 @ 40) en: unCanvas relleno: (Lapiz papelClaro alpha: 0.6) semilla: 21.
	Lapiz
		textoCentrado: controlador textoFase en: unCanvas
		rect: ((o x + 640) @ (o y + 24) extent: 330 @ 22)
		fuente: (Lapiz fuenteCuerpo: 11) color: Lapiz grafito
]

{ #category : 'drawing' }
VentanaBatallaNaval >> dibujarFondoEn: unCanvas [
	fondo isNil ifTrue: [ fondo := self cargarFondo ].
	unCanvas fillRectangle: bounds color: Lapiz papel.
	fondo == false ifTrue: [ ^ self ].
	[ unCanvas image: fondo at: bounds origin ] on: Error do: [ :error | nil ]
]

{ #category : 'drawing' }
VentanaBatallaNaval >> dibujarTitulosEn: unCanvas [
	| o |
	o := bounds origin.
	{ #propio -> 16. #rival -> 514 } do: [ :a |
		Lapiz
			textoCentrado: (controlador tituloDe: a key) en: unCanvas
			rect: ((o x + a value) @ (o y + 76) extent: 424 @ 22)
			fuente: (Lapiz fuenteCuerpo: 11) color: Lapiz grafito.
		Lapiz
			linea: (o x + a value + 40) @ (o y + 98) a: (o x + a value + 384) @ (o y + 98)
			en: unCanvas ancho: 1 color: (Lapiz grafito alpha: 0.6) semilla: a value ]
]

{ #category : 'drawing' }
VentanaBatallaNaval >> drawOn: unCanvas [
	self dibujarFondoEn: unCanvas.
	self dibujarCabeceraEn: unCanvas.
	self dibujarTitulosEn: unCanvas
]

{ #category : 'initialization' }
VentanaBatallaNaval >> initialize [
	super initialize.
	self color: Color transparent
]

{ #category : 'building' }
VentanaBatallaNaval >> partidaNueva [
	chips do: [ :chip | chip delete ].
	chips := OrderedCollection new.
	#(#propio #rival) do: [ :unLado |
		| x |
		x := self position x + (unLado = #propio ifTrue: [ 16 ] ifFalse: [ 514 ]).
		(controlador propietarioDe: unLado) flota naves doWithIndex: [ :nave :i |
			| chip |
			chip := ChipNaveMorph nave: nave controlador: controlador propia: (unLado = #propio or: [ controlador demo ]).
			chip position: (x + ((i - 1) \\ 5 * 84)) @ (self position y + 552 + ((i - 1) // 5 * 48)).
			self addMorph: chip.
			chips add: chip ] ].
	versionVista := nil
]

{ #category : 'initialization' }
VentanaBatallaNaval >> setControlador: unControlador [
	controlador := unControlador.
	chips := OrderedCollection new.
	self extent: 1240 @ 730.
	self armar
]

{ #category : 'stepping' }
VentanaBatallaNaval >> step [
	self world isNil ifTrue: [ ^ self ].
	controlador paso.
	tableroPropio actualizarHover.
	tableroRival actualizarHover.
	versionVista = controlador version
		ifTrue: [
			controlador hayAnimacion ifTrue: [
				tableroPropio changed.
				tableroRival changed ] ]
		ifFalse: [
			versionVista := controlador version.
			self actualizarFin.
			self changed ]
]

{ #category : 'stepping' }
VentanaBatallaNaval >> stepTime [
	^ 40
]

{ #category : 'stepping' }
VentanaBatallaNaval >> wantsSteps [
	^ true
]

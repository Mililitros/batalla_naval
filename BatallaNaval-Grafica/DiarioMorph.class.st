"
Diario de a bordo: instrucción, ficha, jugada narrada y bitácora.
"
Class {
	#name : 'DiarioMorph',
	#superclass : 'Morph',
	#instVars : [
		'controlador'
	],
	#category : 'BatallaNaval-Grafica',
	#package : 'BatallaNaval-Grafica'
}

{ #category : 'instance creation' }
DiarioMorph class >> controlador: unControlador [
	^ self new setControlador: unControlador
]

{ #category : 'drawing' }
DiarioMorph >> drawOn: unCanvas [
	| x ancho y fuente chica texto lineas jugada limite |
	Lapiz caja: bounds en: unCanvas relleno: (Lapiz papelClaro alpha: 0.58) semilla: 5.
	x := bounds left + 12.
	ancho := bounds width - 24.
	limite := bounds bottom - 8.
	fuente := Lapiz fuenteCuerpo: 9.
	chica := Lapiz fuenteCuerpo: 8.
	Lapiz texto: 'DIARIO DE A BORDO' en: unCanvas rect: (x @ (bounds top + 6) extent: ancho @ 18) fuente: (Lapiz fuenteCuerpo: 9) color: Lapiz grafito.
	y := bounds top + 28.
	texto := controlador aviso isEmpty ifTrue: [ controlador textoInstruccion ] ifFalse: [ controlador aviso ].
	y := self
		escribirLineas: (Lapiz lineasDe: texto ancho: ancho fuente: fuente)
		desde: x @ y ancho: ancho fuente: fuente
		color: (controlador aviso isEmpty ifTrue: [ Lapiz grafito ] ifFalse: [ Lapiz rojoLapiz ])
		en: unCanvas salto: 17.
	y := y + 4.
	texto := controlador textoFicha.
	texto isEmpty ifFalse: [
		lineas := Lapiz lineasDe: texto ancho: ancho - 10 fuente: chica.
		unCanvas fillRectangle: (x @ y extent: 3 @ (lineas size * 14)) color: Lapiz grafito.
		y := self escribirLineas: lineas desde: (x + 8) @ y ancho: ancho - 10 fuente: chica color: Lapiz grafito en: unCanvas salto: 14.
		y := y + 4 ].
	jugada := controlador jugada.
	jugada notNil ifTrue: [
		| alto |
		alto := 22.
		jugada pasos do: [ :p | alto := alto + ((Lapiz lineasDe: p key ancho: ancho - 28 fuente: chica) size * 14) + 2 ].
		unCanvas fillRectangle: (x - 4 @ y extent: (ancho + 8) @ alto) color: (Lapiz papelClaro alpha: 0.8).
		Lapiz poligono: { (x - 4) @ y. (x + ancho + 4) @ y. (x + ancho + 4) @ (y + alto). (x - 4) @ (y + alto) } cerrado: true en: unCanvas ancho: 1 color: (Lapiz grafito alpha: 0.6) semilla: 77.
		Lapiz texto: jugada titulo asUppercase en: unCanvas rect: (x @ (y + 3) extent: ancho @ 16) fuente: chica color: Lapiz grafito.
		y := y + 20.
		jugada pasos doWithIndex: [ :p :i |
			| ultimo estilo |
			ultimo := i = jugada pasos size and: [ jugada terminada not ].
			estilo := p value = #res ifTrue: [ Lapiz rojoLapiz ] ifFalse: [ Lapiz grafito ].
			unCanvas
				fillOval: ((x + 2) @ (y + 3) extent: 8 @ 8)
				color: (ultimo ifTrue: [ Lapiz rojoLapiz alpha: 0.35 ] ifFalse: [ Lapiz grafito alpha: 0.85 ]).
			y := self
				escribirLineas: (Lapiz lineasDe: p key ancho: ancho - 28 fuente: chica)
				desde: (x + 18) @ y ancho: ancho - 28 fuente: chica color: estilo en: unCanvas salto: 14.
			y := y + 2 ].
		y := y + 8 ].
	controlador bitacora do: [ :entrada |
		lineas := Lapiz lineasDe: entrada key ancho: ancho - 10 fuente: chica.
		y + (lineas size * 14) <= limite ifTrue: [
			unCanvas fillRectangle: (x @ (y + 7) extent: 5 @ 1) color: Lapiz grafito.
			y := self
				escribirLineas: lineas desde: (x + 10) @ y ancho: ancho - 10 fuente: chica
				color: (entrada value = #alerta ifTrue: [ Lapiz rojoLapiz ] ifFalse: [ Lapiz grafito alpha: (entrada value = #mia ifTrue: [ 1 ] ifFalse: [ 0.75 ]) ])
				en: unCanvas salto: 14.
			y := y + 3 ] ]
]

{ #category : 'drawing' }
DiarioMorph >> escribirLineas: unasLineas desde: unaPosicion ancho: unAncho fuente: unaFuente color: unColor en: unCanvas salto: unSalto [
	"Escribe renglones uno debajo del otro y devuelve la coordenada y siguiente."
	| y |
	y := unaPosicion y.
	unasLineas do: [ :linea |
		Lapiz texto: linea en: unCanvas rect: (unaPosicion x @ y extent: unAncho @ unSalto) fuente: unaFuente color: unColor.
		y := y + unSalto ].
	^ y
]

{ #category : 'initialization' }
DiarioMorph >> initialize [
	super initialize.
	self color: Color transparent
]

{ #category : 'initialization' }
DiarioMorph >> setControlador: unControlador [
	controlador := unControlador.
	self extent: 240 @ 330
]

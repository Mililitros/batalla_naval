"
Utilidades de dibujo a lápiz (trazos irregulares, hachurado, texto).
"
Class {
	#name : 'Lapiz',
	#superclass : 'Object',
	#classInstVars : [
		'fuentes'
	],
	#category : 'BatallaNaval-Grafica',
	#package : 'BatallaNaval-Grafica'
}

{ #category : 'dibujo' }
Lapiz class >> barcoDePapel: unaBase escala: unaEscala en: unCanvas semilla: unaSemilla [
	"Barquito de papel de la cabecera: casco, vela y rayado."
	| s largo alto grafito |
	s := unaEscala.
	largo := s * 1.15.
	alto := s * 0.52.
	grafito := self grafito alpha: 0.9.
	self
		poligono: { (unaBase x - largo) @ unaBase y. (unaBase x + largo) @ unaBase y. (unaBase x + (largo * 0.7)) @ (unaBase y + alto). (unaBase x - (largo * 0.7)) @ (unaBase y + alto) }
		cerrado: true en: unCanvas ancho: 2 color: grafito semilla: unaSemilla.
	self
		hachurar: ((unaBase x + (largo * 0.05)) @ (unaBase y + 1) corner: (unaBase x + largo - 2) @ (unaBase y + alto - 1))
		en: unCanvas separacion: 3 ancho: 1 color: (self grafito alpha: 0.4) direccion: -1.
	self
		poligono: { (unaBase x - (largo * 0.62)) @ unaBase y. (unaBase x - (largo * 0.1)) @ (unaBase y - s). (unaBase x + (largo * 0.42)) @ unaBase y }
		cerrado: true en: unCanvas ancho: 2 color: grafito semilla: unaSemilla + 20
]

{ #category : 'dibujo' }
Lapiz class >> caja: unRect en: unCanvas relleno: unColor semilla: unaSemilla [
	"Caja dibujada a mano: sombra de lápiz, papel y borde irregular."
	unCanvas fillRectangle: (unRect translateBy: 2 @ 3) color: (self grafito alpha: 0.18).
	unCanvas fillRectangle: unRect color: unColor.
	self
		poligono: { unRect topLeft. unRect topRight. unRect bottomRight. unRect bottomLeft }
		cerrado: true en: unCanvas ancho: 2 color: (self grafito alpha: 0.9) semilla: unaSemilla
]

{ #category : 'dibujo' }
Lapiz class >> circulo: unCentro radio: unRadio en: unCanvas ancho: unAncho color: unColor [
	| previo |
	previo := nil.
	0 to: 24 do: [ :i |
		| angulo p |
		angulo := i / 24 * Float twoPi.
		p := unCentro + ((angulo cos * unRadio) @ (angulo sin * unRadio)).
		previo isNil ifFalse: [ self trazoDe: previo a: p en: unCanvas ancho: unAncho color: unColor ].
		previo := p ]
]

{ #category : 'poligonos' }
Lapiz class >> cruces: unosPuntos en: unaY [
	| xs |
	xs := OrderedCollection new.
	1 to: unosPuntos size do: [ :i |
		| p q |
		p := unosPuntos at: i.
		q := unosPuntos at: i \\ unosPuntos size + 1.
		((p y <= unaY and: [ q y > unaY ]) or: [ q y <= unaY and: [ p y > unaY ] ])
			ifTrue: [ xs add: p x + ((unaY - p y) * (q x - p x) / (q y - p y)) ] ].
	^ xs asSortedCollection asArray
]

{ #category : 'dibujo' }
Lapiz class >> cruz: unCentro radio: unRadio en: unCanvas ancho: unAncho color: unColor semilla: unaSemilla [
	"La X de impacto, trazada a mano."
	self linea: unCentro - unRadio a: unCentro + unRadio en: unCanvas ancho: unAncho color: unColor semilla: unaSemilla.
	self
		linea: (unCentro x + unRadio) @ (unCentro y - unRadio)
		a: (unCentro x - unRadio) @ (unCentro y + unRadio)
		en: unCanvas ancho: unAncho color: unColor semilla: unaSemilla + 7
]

{ #category : 'dibujo' }
Lapiz class >> elipse: unCentro rx: unRx ry: unRy en: unCanvas ancho: unAncho color: unColor [
	| previo |
	previo := nil.
	0 to: 24 do: [ :i |
		| angulo p |
		angulo := i / 24 * Float twoPi.
		p := unCentro + ((angulo cos * unRx) @ (angulo sin * unRy)).
		previo isNil ifFalse: [ self trazoDe: previo a: p en: unCanvas ancho: unAncho color: unColor ].
		previo := p ]
]

{ #category : 'fuentes' }
Lapiz class >> fuenteCuerpo: unosPuntos [

    | tamano |
    tamano := unosPuntos + 3.
    fuentes ifNil: [ fuentes := Dictionary new ].
    ^ fuentes
        at: #cuerpo -> tamano
        ifAbsentPut: [ LogicalFont familyName: StandardFonts defaultFont familyName pointSize: tamano ]


]

{ #category : 'fuentes' }
Lapiz class >> fuenteTitulo: unosPuntos [
    | tamano |
    tamano := unosPuntos + 4.
    fuentes ifNil: [ fuentes := Dictionary new ].
    ^ fuentes
        at: #titulo -> tamano
        ifAbsentPut: [ LogicalFont familyName: StandardFonts defaultFont familyName pointSize: tamano ]

]

{ #category : 'colores' }
Lapiz class >> grafito [
	^ Color r: 0.169 g: 0.149 b: 0.125
]

{ #category : 'dibujo' }
Lapiz class >> hachurar: unRect en: unCanvas separacion: unaSeparacion ancho: unAncho color: unColor direccion: unaDireccion [
	"Rayado diagonal con fase absoluta (las rayas de celdas vecinas continúan sin cortes). Dirección positiva: sube hacia la derecha."
	| x0 y0 x1 y1 desde |
	x0 := unRect left. y0 := unRect top. x1 := unRect right. y1 := unRect bottom.
	unaDireccion > 0
		ifTrue: [
			desde := ((x0 + y0) / unaSeparacion) ceiling * unaSeparacion.
			desde to: x1 + y1 by: unaSeparacion do: [ :c |
				| xa xb |
				xa := x0 max: c - y1.
				xb := x1 min: c - y0.
				xa < xb ifTrue: [ self trazoDe: xa @ (c - xa) a: xb @ (c - xb) en: unCanvas ancho: unAncho color: unColor ] ] ]
		ifFalse: [
			desde := ((x0 - y1) / unaSeparacion) ceiling * unaSeparacion.
			desde to: x1 - y0 by: unaSeparacion do: [ :c |
				| xa xb |
				xa := x0 max: c + y0.
				xb := x1 min: c + y1.
				xa < xb ifTrue: [ self trazoDe: xa @ (xa - c) a: xb @ (xb - c) en: unCanvas ancho: unAncho color: unColor ] ] ]
]

{ #category : 'poligonos' }
Lapiz class >> hachurarPoligono: unosPuntos en: unCanvas separacion: unaSeparacion color: unColor direccion: unaDireccion [
	| minY maxY |
	minY := (unosPuntos collect: [ :p | p y ]) min floor.
	maxY := (unosPuntos collect: [ :p | p y ]) max ceiling.
	minY to: maxY do: [ :y |
		| xs s |
		xs := self cruces: unosPuntos en: y + 0.5.
		s := unaDireccion > 0 ifTrue: [ y ] ifFalse: [ y negated ].
		1 to: xs size - 1 by: 2 do: [ :k |
			| xa xb |
			xa := xs at: k.
			xb := xs at: k + 1.
			(((xa + s) / unaSeparacion) ceiling) to: (((xb + s) / unaSeparacion) ceiling - 1) do: [ :m |
				unCanvas
					fillRectangle: ((((m * unaSeparacion) - s) rounded @ y) extent: 1 @ 1)
					color: unColor ] ] ]
]

{ #category : 'dibujo' }
Lapiz class >> islaEn: unRect canvas: unCanvas semilla: unaSemilla [
	"Isla a mano: contorno irregular, relleno ocre, rayado con sombra hacia el sudeste, curvas de nivel y colinas."
	| centro rx ry puntos anillos |
	centro := unRect center.
	rx := unRect width * 0.47.
	ry := unRect height * 0.47.
	puntos := (0 to: 13) collect: [ :i |
		| a k |
		a := i / 14 * Float twoPi.
		k := 0.74 + ((self ruido: unaSemilla * 17 + i) * 0.3).
		centro + ((a cos * rx * k) @ (a sin * ry * k)) ].
	self rellenarPoligono: puntos en: unCanvas color: (Color r: 0.44 g: 0.35 b: 0.16 alpha: 0.36).
	self hachurarPoligono: puntos en: unCanvas separacion: 4 color: (self grafito alpha: 0.22) direccion: -1.
	self hachurarPoligono: ((puntos collect: [ :p | p + (rx * 0.05) ]) collect: [ :p | p ]) en: unCanvas separacion: 3 color: (self grafito alpha: 0.5) direccion: 1.
	self poligono: puntos cerrado: true en: unCanvas ancho: 2 color: (self grafito alpha: 0.95) semilla: unaSemilla.
	unRect width > 24 ifTrue: [
		anillos := { 0.66. 0.36 }.
		anillos do: [ :f |
			self
				poligono: (puntos collect: [ :p | centro + ((p - centro) * f) ])
				cerrado: true en: unCanvas ancho: 1 color: (self grafito alpha: 0.55) semilla: unaSemilla + 50 ].
		0 to: 2 do: [ :i |
			| h q |
			h := centro + (((self ruido: unaSemilla + i) - 0.5 * rx * 0.8) @ ((self ruido: unaSemilla + i + 9) - 0.5 * ry * 0.7)).
			q := (rx min: ry) * 0.17.
			self trazoDe: h + (q negated @ (q * 0.8)) a: h + (0 @ q negated) en: unCanvas ancho: 1 color: (self grafito alpha: 0.85).
			self trazoDe: h + (0 @ q negated) a: h + (q @ (q * 0.8)) en: unCanvas ancho: 1 color: (self grafito alpha: 0.85) ] ]
]

{ #category : 'dibujo' }
Lapiz class >> linea: unPunto a: otroPunto en: unCanvas ancho: unAncho color: unColor semilla: unaSemilla [
	| dx dy largo n nx ny |
	dx := otroPunto x - unPunto x.
	dy := otroPunto y - unPunto y.
	largo := ((dx * dx) + (dy * dy)) sqrt max: 1.
	n := (largo / 16) rounded max: 2.
	nx := dy negated / largo.
	ny := dx / largo.
	1 to: 2 do: [ :pasada |
		| previo color ancho |
		previo := nil.
		color := pasada = 1 ifTrue: [ unColor ] ifFalse: [ unColor alpha: unColor alpha * 0.45 ].
		ancho := pasada = 1 ifTrue: [ unAncho ] ifFalse: [ unAncho * 0.7 ].
		0 to: n do: [ :i |
			| t desvio p |
			t := i / n.
			desvio := ((self ruido: (unaSemilla * 31) + (i * 7) + (pasada * 101)) - 0.5) * 1.8.
			p := (unPunto x + (dx * t) + (nx * desvio)) @ (unPunto y + (dy * t) + (ny * desvio)).
			previo isNil ifFalse: [ self trazoDe: previo a: p en: unCanvas ancho: ancho color: color ].
			previo := p ] ]
]

{ #category : 'texto' }
Lapiz class >> lineasDe: unTexto ancho: unAncho fuente: unaFuente [
	"Corta un texto en renglones que entren en el ancho dado."
	| lineas actual |
	lineas := OrderedCollection new.
	actual := ''.
	(unTexto substrings: ' ') do: [ :palabra |
		| prueba |
		prueba := actual isEmpty ifTrue: [ palabra ] ifFalse: [ actual , ' ' , palabra ].
		((unaFuente widthOfString: prueba) > unAncho and: [ actual notEmpty ])
			ifTrue: [ lineas add: actual. actual := palabra ]
			ifFalse: [ actual := prueba ] ].
	actual isEmpty ifFalse: [ lineas add: actual ].
	^ lineas
]

{ #category : 'dibujo' }
Lapiz class >> mina: unCentro radio: unRadio en: unCanvas [
	| color |
	color := self grafito alpha: 0.8.
	unCanvas fillOval: ((unCentro - (unRadio * 0.55)) corner: (unCentro + (unRadio * 0.55))) color: color.
	self circulo: unCentro radio: unRadio en: unCanvas ancho: 1 color: color.
	0 to: 7 do: [ :i |
		| a |
		a := i / 8 * Float twoPi.
		self
			trazoDe: unCentro + ((a cos * unRadio) @ (a sin * unRadio))
			a: unCentro + ((a cos * unRadio * 1.9) @ (a sin * unRadio * 1.9))
			en: unCanvas ancho: 1 color: color ]
]

{ #category : 'dibujo' }
Lapiz class >> ola: unAncho desde: x1 hasta: x2 y: unaY en: unCanvas semilla: unaSemilla [
	| previo |
	previo := nil.
	x1 to: x2 by: 5 do: [ :x |
		| p |
		p := x @ (unaY + ((x * 0.11 + unaSemilla) sin * unAncho)).
		previo isNil ifFalse: [ self trazoDe: previo a: p en: unCanvas ancho: 1 color: (self grafito alpha: 0.45) ].
		previo := p ]
]

{ #category : 'colores' }
Lapiz class >> papel [
	^ Color r: 0.90 g: 0.83 b: 0.65
]

{ #category : 'colores' }
Lapiz class >> papelClaro [
	^ Color r: 0.953 g: 0.906 b: 0.776
]

{ #category : 'dibujo' }
Lapiz class >> poligono: unosPuntos cerrado: unBooleano en: unCanvas ancho: unAncho color: unColor semilla: unaSemilla [
	| cantidad |
	cantidad := unBooleano ifTrue: [ unosPuntos size ] ifFalse: [ unosPuntos size - 1 ].
	1 to: cantidad do: [ :i |
		self
			linea: (unosPuntos at: i)
			a: (unosPuntos at: i \\ unosPuntos size + 1)
			en: unCanvas ancho: unAncho color: unColor semilla: unaSemilla + i ]
]

{ #category : 'dibujo' }
Lapiz class >> punto: unCentro radio: unRadio en: unCanvas semilla: unaSemilla [
	"El punto de agua: un círculo pequeño de grafito, nunca perfecto."
	| r |
	r := unRadio * (0.85 + ((self ruido: unaSemilla) * 0.3)).
	unCanvas fillOval: ((unCentro - r) corner: (unCentro + r)) color: (self grafito alpha: 0.92)
]

{ #category : 'dibujo' }
Lapiz class >> rectanguloPunteado: unRect en: unCanvas ancho: unAncho color: unColor [
	| lados |
	lados := { unRect topLeft -> unRect topRight. unRect topRight -> unRect bottomRight. unRect bottomRight -> unRect bottomLeft. unRect bottomLeft -> unRect topLeft }.
	lados do: [ :lado |
		| d largo pasos |
		d := lado value - lado key.
		largo := (d x * d x + (d y * d y)) sqrt max: 1.
		pasos := (largo / 7) floor.
		0 to: pasos - 1 by: 2 do: [ :k |
			self
				trazoDe: lado key + (d * (k / pasos))
				a: lado key + (d * ((k + 1) / pasos))
				en: unCanvas ancho: unAncho color: unColor ] ]
]

{ #category : 'poligonos' }
Lapiz class >> rellenarPoligono: unosPuntos en: unCanvas color: unColor [
	| minY maxY |
	minY := (unosPuntos collect: [ :p | p y ]) min floor.
	maxY := (unosPuntos collect: [ :p | p y ]) max ceiling.
	minY to: maxY do: [ :y |
		| xs |
		xs := self cruces: unosPuntos en: y + 0.5.
		1 to: xs size - 1 by: 2 do: [ :k |
			unCanvas
				fillRectangle: (((xs at: k) rounded @ y) corner: ((xs at: k + 1) rounded @ (y + 1)))
				color: unColor ] ]
]

{ #category : 'colores' }
Lapiz class >> rojoLapiz [
	^ Color r: 0.549 g: 0.165 b: 0.102
]

{ #category : 'dibujo' }
Lapiz class >> ruido: unNumero [
	"Número pseudoaleatorio entre 0 y 1 que depende solo del argumento: el trazo a lápiz es irregular pero siempre igual."
	^ (((unNumero * 12.9898) sin * 43758.5453) fractionPart) abs
]

{ #category : 'texto' }
Lapiz class >> texto: unTexto en: unCanvas rect: unRect fuente: unaFuente color: unColor [
	unCanvas drawString: unTexto in: unRect font: unaFuente color: unColor
]

{ #category : 'texto' }
Lapiz class >> textoCentrado: unTexto en: unCanvas rect: unRect fuente: unaFuente color: unColor [
	| ancho |
	ancho := unaFuente widthOfString: unTexto.
	self
		texto: unTexto en: unCanvas
		rect: (((unRect left + ((unRect width - ancho) // 2)) @ unRect top) corner: unRect bottomRight)
		fuente: unaFuente color: unColor
]

{ #category : 'dibujo' }
Lapiz class >> trazoDe: unPunto a: otroPunto en: unCanvas ancho: unAncho color: unColor [
	unCanvas line: unPunto rounded to: otroPunto rounded width: (unAncho rounded max: 1) color: unColor
]

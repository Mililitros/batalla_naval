"
Dibuja un territorio de 12x12 y recibe los toques.
"
Class {
	#name : 'TableroMorph',
	#superclass : 'Morph',
	#instVars : [
		'controlador',
		'lado',
		'hover'
	],
	#category : 'BatallaNaval-Grafica',
	#package : 'BatallaNaval-Grafica'
}

{ #category : 'medidas' }
TableroMorph class >> celda [
	^ 32
]

{ #category : 'instance creation' }
TableroMorph class >> controlador: unControlador lado: unLado [
	^ self new setControlador: unControlador lado: unLado
]

{ #category : 'medidas' }
TableroMorph class >> margenIzquierdo [
	^ 34
]

{ #category : 'medidas' }
TableroMorph class >> margenSuperior [
	^ 28
]

{ #category : 'events' }
TableroMorph >> actualizarHover [
	| nuevo |
	nuevo := (self containsPoint: self currentHand position)
		ifTrue: [ self coordenadaEn: self currentHand position ]
		ifFalse: [ nil ].
	nuevo = hover ifFalse: [
		hover := nuevo.
		controlador hover: nuevo de: lado.
		self changed ]
]

{ #category : 'geometry' }
TableroMorph >> coordenadaEn: unPunto [
	| x y columna fila |
	x := unPunto x - bounds left - self class margenIzquierdo.
	y := unPunto y - bounds top - self class margenSuperior.
	(x < 0 or: [ y < 0 ]) ifTrue: [ ^ nil ].
	columna := x // self class celda + 1.
	fila := y // self class celda + self territorio filaInicial.
	(columna > 12 or: [ fila > self territorio filaFinal ]) ifTrue: [ ^ nil ].
	^ Coordenada fila: fila columna: columna
]

{ #category : 'drawing' }
TableroMorph >> dibujarCasillasEn: unCanvas matriz: unaMatriz [
	| tablero territorio verTodo celda |
	tablero := controlador partida tablero.
	territorio := self territorio.
	verTodo := controlador demo.
	celda := self class celda.
	territorio filaInicial to: territorio filaFinal do: [ :fila |
		1 to: tablero columnas do: [ :columna |
			| coordenada casilla simbolo rect |
			coordenada := Coordenada fila: fila columna: columna.
			casilla := tablero casillaEn: coordenada.
			simbolo := (unaMatriz at: fila) at: columna.
			rect := self rectanguloDe: coordenada.
			simbolo = #isla ifTrue: [ Lapiz islaEn: rect canvas: unCanvas semilla: fila * 131 + (columna * 17) + 3 ].
			simbolo = #agua ifTrue: [ Lapiz punto: rect center radio: (celda * 0.085 max: 2.2) en: unCanvas semilla: fila * 29 + columna ].
			(#(#nave #impacto #hundida) includes: simbolo)
				ifTrue: [ self dibujarNaveDe: casilla simbolo: simbolo rect: rect matriz: unaMatriz en: unCanvas ].
			((casilla tieneMina and: [ casilla estaAtacada not ]) and: [ verTodo or: [ lado = #rival ] ])
				ifTrue: [ Lapiz mina: rect center radio: celda * 0.13 en: unCanvas ] ] ]
]

{ #category : 'drawing' }
TableroMorph >> dibujarChapoteo: unEfecto progreso: t en: unCanvas [
	| centro |
	centro := (self rectanguloDe: unEfecto coordenada) center.
	0 to: 2 do: [ :k |
		| q rx |
		q := (((t * 1.25) - (k * 0.2)) min: 1) max: 0.
		q > 0 ifTrue: [
			rx := self class celda * (0.12 + (0.5 * q)).
			Lapiz elipse: centro rx: rx ry: rx * 0.5 en: unCanvas ancho: 1 color: (Lapiz grafito alpha: 0.75 * (1 - q)) ] ]
]

{ #category : 'drawing' }
TableroMorph >> dibujarCuadriculaEn: unCanvas [
	| celda x0 y0 fuente tinta |
	celda := self class celda.
	x0 := bounds left + self class margenIzquierdo.
	y0 := bounds top + self class margenSuperior.
	fuente := Lapiz fuenteCuerpo: 9.
	0 to: 12 do: [ :i |
		| borde ancho color |
		borde := i = 0 or: [ i = 12 ].
		ancho := borde ifTrue: [ 2 ] ifFalse: [ 1 ].
		color := Lapiz grafito alpha: (borde ifTrue: [ 0.9 ] ifFalse: [ 0.6 ]).
		Lapiz linea: x0 @ (y0 + (i * celda)) a: (x0 + (12 * celda)) @ (y0 + (i * celda)) en: unCanvas ancho: ancho color: color semilla: 100 + i.
		Lapiz linea: (x0 + (i * celda)) @ y0 a: (x0 + (i * celda)) @ (y0 + (12 * celda)) en: unCanvas ancho: ancho color: color semilla: 200 + i ].
	tinta := Lapiz grafito alpha: 0.85.
	1 to: 12 do: [ :c |
		Lapiz
			textoCentrado: (String with: (Character value: 64 + c))
			en: unCanvas
			rect: ((x0 + ((c - 1) * celda)) @ (y0 - 22) extent: celda @ 20)
			fuente: fuente color: tinta ].
	0 to: 11 do: [ :f |
		Lapiz
			textoCentrado: (self territorio filaInicial + f) printString
			en: unCanvas
			rect: ((bounds left + 2) @ (y0 + (f * celda) + 7) extent: (self class margenIzquierdo - 8) @ 20)
			fuente: fuente color: tinta ]
]

{ #category : 'drawing' }
TableroMorph >> dibujarCubiertaEn: unCanvas [
	"Las filas que el arma elegida no alcanza se tapan con grafito oscuro."
	controlador filasFueraDeAlcance do: [ :fila |
		| izq der rect |
		izq := self rectanguloDe: (Coordenada fila: fila columna: 1).
		der := self rectanguloDe: (Coordenada fila: fila columna: 12).
		rect := (izq topLeft + 1) corner: (der bottomRight - 1).
		unCanvas fillRectangle: rect color: (Color r: 0.18 g: 0.14 b: 0.09 alpha: 0.3).
		Lapiz hachurar: rect en: unCanvas separacion: 3 ancho: 1 color: (Lapiz grafito alpha: 0.85) direccion: -1.
		Lapiz hachurar: rect en: unCanvas separacion: 3 ancho: 1 color: (Lapiz grafito alpha: 0.6) direccion: 1 ]
]

{ #category : 'drawing' }
TableroMorph >> dibujarEfectosEn: unCanvas [
	| ahora |
	ahora := Time millisecondClockValue.
	controlador efectos do: [ :fx |
		| t |
		t := fx progreso: ahora.
		(t >= 0 and: [ t <= 1 ]) ifTrue: [
			fx tipo = #estela
				ifTrue: [ self dibujarEstela: fx progreso: t en: unCanvas ]
				ifFalse: [
					(fx coordenada notNil and: [ self territorio incluye: fx coordenada ]) ifTrue: [
						fx tipo = #proyectil
							ifTrue: [ self dibujarProyectil: fx progreso: t en: unCanvas ]
							ifFalse: [
								fx tipo = #agua
									ifTrue: [ self dibujarChapoteo: fx progreso: t en: unCanvas ]
									ifFalse: [ self dibujarEstallido: fx progreso: t en: unCanvas ] ] ] ] ] ]
]

{ #category : 'drawing' }
TableroMorph >> dibujarEstallido: unEfecto progreso: t en: unCanvas [
	"Impacto, hundimiento y mina: estallido de rayas de lápiz rojo."
	| centro celda grande n tt |
	celda := self class celda.
	centro := (self rectanguloDe: unEfecto coordenada) center.
	grande := unEfecto tipo ~= #impacto.
	n := grande ifTrue: [ 16 ] ifFalse: [ 10 ].
	tt := (t * 1.3) min: 1.
	unEfecto tipo = #isla ifTrue: [
		1 to: 7 do: [ :k |
			| d |
			d := celda * (0.1 + (0.4 * t)).
			unCanvas
				fillOval: ((centro x + ((k * 0.9 + 1) cos * d) - 1.5) @ (centro y + ((k * 0.9 + 1) sin * d * 0.7) - 1.5)
					corner: (centro x + ((k * 0.9 + 1) cos * d) + 1.5) @ (centro y + ((k * 0.9 + 1) sin * d * 0.7) + 1.5))
				color: (Lapiz grafito alpha: 0.5 * (1 - t)) ].
		^ self ].
	0 to: n - 1 do: [ :k |
		| a r0 r1 |
		a := k / n * Float twoPi.
		r0 := celda * (0.12 + (tt * 0.1)).
		r1 := celda * (0.25 + (tt * (grande ifTrue: [ 0.85 ] ifFalse: [ 0.5 ]))) * (k odd ifTrue: [ 0.7 ] ifFalse: [ 1 ]).
		Lapiz
			trazoDe: centro + ((a cos * r0) @ (a sin * r0))
			a: centro + ((a cos * r1) @ (a sin * r1))
			en: unCanvas ancho: 2 color: (Lapiz rojoLapiz alpha: 1 - (t * t)) ].
	unCanvas
		fillOval: ((centro - (celda * (0.2 + (0.35 * tt)))) corner: (centro + (celda * (0.2 + (0.35 * tt)))))
		color: (Color r: 1 g: 0.94 b: 0.78 alpha: 0.55 * (1 - t) * (1 - t))
]

{ #category : 'drawing' }
TableroMorph >> dibujarEstela: unEfecto progreso: t en: unCanvas [
	| x desde hasta y celda |
	unEfecto territorio == self territorio ifFalse: [ ^ self ].
	celda := self class celda.
	x := (self rectanguloDe: (Coordenada fila: self territorio filaInicial columna: unEfecto columna)) center x.
	desde := unEfecto deAbajo
		ifTrue: [ bounds top + self class margenSuperior + (12 * celda) ]
		ifFalse: [ bounds top + self class margenSuperior ].
	hasta := unEfecto deAbajo
		ifTrue: [ bounds top + self class margenSuperior ]
		ifFalse: [ bounds top + self class margenSuperior + (12 * celda) ].
	y := desde + ((hasta - desde) * t).
	Lapiz trazoDe: x @ desde a: x @ y en: unCanvas ancho: 2 color: (Lapiz grafito alpha: 0.7).
	unCanvas fillOval: ((x - (celda * 0.1)) @ (y - (celda * 0.22)) corner: (x + (celda * 0.1)) @ (y + (celda * 0.22))) color: Lapiz grafito
]

{ #category : 'drawing' }
TableroMorph >> dibujarMarcasEn: unCanvas [
	| territorio celda rojo columna |
	territorio := self territorio.
	celda := self class celda.
	rojo := Lapiz rojoLapiz.
	(lado = #propio and: [ controlador demo not ]) ifTrue: [ self resaltarNave: controlador seleccion en: unCanvas ].
	self resaltarNave: controlador atacante en: unCanvas.
	"corchetes rojos en las casillas del último ataque"
	controlador ultimos do: [ :u |
		(territorio incluye: u) ifTrue: [
			| rect q |
			rect := self rectanguloDe: u.
			q := celda * 0.3.
			{ rect topLeft -> (1 @ 1). rect topRight -> (-1 @ 1). rect bottomLeft -> (1 @ -1). rect bottomRight -> (-1 @ -1) } do: [ :esquina |
				| p |
				p := esquina key + (esquina value * 1).
				Lapiz trazoDe: p a: p + (esquina value x * q @ 0) en: unCanvas ancho: 2 color: rojo.
				Lapiz trazoDe: p a: p + (0 @ (esquina value y * q)) en: unCanvas ancho: 2 color: rojo ] ] ].
	"objetivos elegidos por el humano"
	lado = #rival ifTrue: [
		controlador objetivos do: [ :o |
			(territorio incluye: o) ifTrue: [ self dibujarMiraEn: unCanvas coordenada: o ] ] ].
	"mira de la computadora"
	controlador miraObjetivos ifNotNil: [ :objetivos |
		objetivos do: [ :o | (territorio incluye: o) ifTrue: [ self dibujarMiraEn: unCanvas coordenada: o ] ].
		controlador miraAfectadas do: [ :a |
			(territorio incluye: a) ifTrue: [ Lapiz rectanguloPunteado: ((self rectanguloDe: a) insetBy: 3) en: unCanvas ancho: 1 color: rojo ] ] ].
	"recorrido del torpedo"
	columna := controlador columnaDelTorpedoEn: territorio.
	columna notNil ifTrue: [
		| x |
		x := (self rectanguloDe: (Coordenada fila: territorio filaInicial columna: columna)) center x.
		Lapiz
			rectanguloPunteado: (x - 1 @ (bounds top + self class margenSuperior + 2) corner: x + 1 @ (bounds top + self class margenSuperior + (12 * celda) - 2))
			en: unCanvas ancho: 1 color: rojo ]
]

{ #category : 'drawing' }
TableroMorph >> dibujarMiraEn: unCanvas coordenada: unaCoordenada [
	| rect centro pulso radio rojo |
	rect := self rectanguloDe: unaCoordenada.
	centro := rect center.
	pulso := ((Time millisecondClockValue / 130.0) sin + 1) / 2.
	radio := self class celda * (0.34 + (0.06 * pulso)).
	rojo := Lapiz rojoLapiz.
	Lapiz circulo: centro radio: radio en: unCanvas ancho: 2 color: rojo.
	Lapiz trazoDe: (centro x - (self class celda * 0.5)) @ centro y a: (centro x - (radio * 0.5)) @ centro y en: unCanvas ancho: 2 color: rojo.
	Lapiz trazoDe: (centro x + (radio * 0.5)) @ centro y a: (centro x + (self class celda * 0.5)) @ centro y en: unCanvas ancho: 2 color: rojo.
	Lapiz trazoDe: centro x @ (centro y - (self class celda * 0.5)) a: centro x @ (centro y - (radio * 0.5)) en: unCanvas ancho: 2 color: rojo.
	Lapiz trazoDe: centro x @ (centro y + (radio * 0.5)) a: centro x @ (centro y + (self class celda * 0.5)) en: unCanvas ancho: 2 color: rojo
]

{ #category : 'drawing' }
TableroMorph >> dibujarNaveDe: unaCasilla simbolo: unSimbolo rect: unRect matriz: unaMatriz en: unCanvas [
	| nave c norte sur oeste este margen r separacion alfa tinta semilla |
	nave := unaCasilla nave.
	c := unaCasilla coordenada.
	norte := self hayMismaNave: nave en: (Coordenada fila: c fila - 1 columna: c columna) matriz: unaMatriz.
	sur := self hayMismaNave: nave en: (Coordenada fila: c fila + 1 columna: c columna) matriz: unaMatriz.
	oeste := self hayMismaNave: nave en: (Coordenada fila: c fila columna: c columna - 1) matriz: unaMatriz.
	este := self hayMismaNave: nave en: (Coordenada fila: c fila columna: c columna + 1) matriz: unaMatriz.
	margen := 2.
	r := Rectangle
		left: unRect left + (oeste ifTrue: [ 0 ] ifFalse: [ margen ])
		right: unRect right - (este ifTrue: [ 0 ] ifFalse: [ margen ])
		top: unRect top + (norte ifTrue: [ 0 ] ifFalse: [ margen ])
		bottom: unRect bottom - (sur ifTrue: [ 0 ] ifFalse: [ margen ]).
	separacion := unSimbolo = #hundida ifTrue: [ 2.4 ] ifFalse: [ unSimbolo = #impacto ifTrue: [ 6 ] ifFalse: [ 3.3 ] ].
	alfa := unSimbolo = #hundida ifTrue: [ 0.85 ] ifFalse: [ unSimbolo = #impacto ifTrue: [ 0.3 ] ifFalse: [ 0.58 ] ].
	tinta := Lapiz grafito alpha: 0.95.
	semilla := c fila * 53 + c columna.
	Lapiz hachurar: r en: unCanvas separacion: separacion ancho: 1 color: (Lapiz grafito alpha: alfa) direccion: 1.
	norte ifFalse: [ Lapiz linea: r topLeft a: r topRight en: unCanvas ancho: 2 color: tinta semilla: semilla ].
	sur ifFalse: [ Lapiz linea: r bottomLeft a: r bottomRight en: unCanvas ancho: 2 color: tinta semilla: semilla + 1 ].
	oeste ifFalse: [ Lapiz linea: r topLeft a: r bottomLeft en: unCanvas ancho: 2 color: tinta semilla: semilla + 2 ].
	este ifFalse: [ Lapiz linea: r topRight a: r bottomRight en: unCanvas ancho: 2 color: tinta semilla: semilla + 3 ].
	unSimbolo = #impacto ifTrue: [ Lapiz cruz: unRect center radio: self class celda * 0.3 en: unCanvas ancho: 3 color: tinta semilla: semilla ].
	unSimbolo = #hundida ifTrue: [
		Lapiz cruz: unRect center radio: self class celda * 0.34 en: unCanvas ancho: 3 color: Lapiz papel semilla: semilla.
		Lapiz cruz: unRect center radio: self class celda * 0.31 en: unCanvas ancho: 2 color: Lapiz rojoLapiz semilla: semilla ]
]

{ #category : 'drawing' }
TableroMorph >> dibujarPieEn: unCanvas [
	| texto |
	texto := controlador textoPieDe: lado.
	texto isEmpty ifTrue: [ ^ self ].
	Lapiz
		textoCentrado: texto en: unCanvas
		rect: (bounds left @ (bounds top + self class margenSuperior + (12 * self class celda) + 8) extent: bounds width @ 20)
		fuente: (Lapiz fuenteCuerpo: 10) color: Lapiz grafito
]

{ #category : 'drawing' }
TableroMorph >> dibujarProyectil: unEfecto progreso: t en: unCanvas [
	| centro y0 y radio celda |
	celda := self class celda.
	centro := (self rectanguloDe: unEfecto coordenada) center.
	y0 := unEfecto deAbajo
		ifTrue: [ bounds top + self class margenSuperior + (12 * celda) + (celda * 0.6) ]
		ifFalse: [ bounds top + self class margenSuperior - (celda * 0.6) ].
	y := y0 + ((centro y - y0) * t).
	radio := celda * (0.08 + (0.09 * (t * Float pi) sin)).
	unCanvas fillOval: ((centro x - radio - 1) @ (y - radio - 1) corner: (centro x + radio + 1) @ (y + radio + 1)) color: (Lapiz grafito alpha: 0.9).
	1 to: 4 do: [ :k |
		| ty |
		ty := unEfecto deAbajo ifTrue: [ y + (k * celda * 0.16) ] ifFalse: [ y - (k * celda * 0.16) ].
		unCanvas fillOval: ((centro x - 1.5) @ (ty - 1.5) corner: (centro x + 1.5) @ (ty + 1.5)) color: (Lapiz grafito alpha: 0.5 - (k * 0.1)) ]
]

{ #category : 'drawing' }
TableroMorph >> dibujarVistaPreviaEn: unCanvas [
	| tablero |
	hover isNil ifTrue: [ ^ self ].
	tablero := controlador partida tablero.
	(controlador previaDe: lado en: hover) do: [ :a |
		| rect |
		(tablero coordenadaValida: a key) ifTrue: [
			(self territorio incluye: a key) ifTrue: [
				rect := self rectanguloDe: a key.
				lado = #propio
					ifTrue: [
						Lapiz
							hachurar: (rect insetBy: 2) en: unCanvas separacion: 4 ancho: 1
							color: ((a value ifTrue: [ Lapiz grafito ] ifFalse: [ Lapiz rojoLapiz ]) alpha: 0.6) direccion: 1.
						Lapiz
							rectanguloPunteado: (rect insetBy: 2) en: unCanvas ancho: 1
							color: (a value ifTrue: [ Lapiz grafito ] ifFalse: [ Lapiz rojoLapiz ]) ]
					ifFalse: [
						controlador esColocandoMinas
							ifTrue: [ Lapiz mina: rect center radio: self class celda * 0.13 en: unCanvas ]
							ifFalse: [ Lapiz rectanguloPunteado: (rect insetBy: 3) en: unCanvas ancho: 1 color: Lapiz rojoLapiz ] ] ] ] ]
]

{ #category : 'drawing' }
TableroMorph >> drawOn: unCanvas [
	controlador partida isNil ifTrue: [ ^ self ].
	self dibujarCuadriculaEn: unCanvas.
	self dibujarCasillasEn: unCanvas matriz: controlador matrizVisible.
	self dibujarCubiertaEn: unCanvas.
	self dibujarMarcasEn: unCanvas.
	self dibujarVistaPreviaEn: unCanvas.
	self dibujarEfectosEn: unCanvas.
	self dibujarPieEn: unCanvas
]

{ #category : 'events' }
TableroMorph >> handlesMouseDown: unEvento [
	^ true
]

{ #category : 'drawing' }
TableroMorph >> hayMismaNave: unaNave en: unaCoordenada matriz: unaMatriz [
	| territorio |
	territorio := self territorio.
	((territorio incluye: unaCoordenada) and: [ unaCoordenada columna between: 1 and: 12 ]) ifFalse: [ ^ false ].
	^ ((#(#nave #impacto #hundida) includes: ((unaMatriz at: unaCoordenada fila) at: unaCoordenada columna))
		and: [ (controlador partida tablero casillaEn: unaCoordenada) nave == unaNave ])
]

{ #category : 'accessing' }
TableroMorph >> hover [
	^ hover
]

{ #category : 'initialization' }
TableroMorph >> initialize [
	super initialize.
	self color: Color transparent
]

{ #category : 'accessing' }
TableroMorph >> lado [
	^ lado
]

{ #category : 'events' }
TableroMorph >> mouseDown: unEvento [
	| coordenada |
	coordenada := self coordenadaEn: unEvento position.
	coordenada notNil ifTrue: [ controlador tocarCoordenada: coordenada en: lado ]
]

{ #category : 'geometry' }
TableroMorph >> rectanguloDe: unaCoordenada [
	| celda |
	celda := self class celda.
	^ ((bounds left + self class margenIzquierdo + ((unaCoordenada columna - 1) * celda))
		@ (bounds top + self class margenSuperior + ((unaCoordenada fila - self territorio filaInicial) * celda)))
		extent: celda @ celda
]

{ #category : 'drawing' }
TableroMorph >> resaltarNave: unaNave en: unCanvas [
	| posiciones a b |
	(unaNave isNil or: [ unaNave estaUbicada not ]) ifTrue: [ ^ self ].
	posiciones := unaNave posiciones select: [ :c | self territorio incluye: c ].
	posiciones isEmpty ifTrue: [ ^ self ].
	a := (self rectanguloDe: (Coordenada
		fila: (posiciones collect: [ :c | c fila ]) min
		columna: (posiciones collect: [ :c | c columna ]) min)) topLeft - 3.
	b := (self rectanguloDe: (Coordenada
		fila: (posiciones collect: [ :c | c fila ]) max
		columna: (posiciones collect: [ :c | c columna ]) max)) bottomRight + 3.
	Lapiz
		poligono: { a. b x @ a y. b. a x @ b y }
		cerrado: true en: unCanvas ancho: 2 color: Lapiz rojoLapiz semilla: a x + a y
]

{ #category : 'initialization' }
TableroMorph >> setControlador: unControlador lado: unLado [
	controlador := unControlador.
	lado := unLado.
	self extent: (self class margenIzquierdo + (12 * self class celda) + 6) @ (self class margenSuperior + (12 * self class celda) + 30)
]

{ #category : 'accessing' }
TableroMorph >> territorio [
	^ controlador territorioDe: lado
]

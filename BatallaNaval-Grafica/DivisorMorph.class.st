"
Islas decorativas entre los dos tableros.
"
Class {
	#name : 'DivisorMorph',
	#superclass : 'Morph',
	#category : 'BatallaNaval-Grafica',
	#package : 'BatallaNaval-Grafica'
}

{ #category : 'drawing' }
DivisorMorph >> drawOn: unCanvas [
	"isla decorativa que separa el territorio enemigo del propio (no participa del juego)"
	| u i |
	u := 12.
	i := 0.
	[ u < (bounds height - 60) ] whileTrue: [
		| radio rect alto |
		radio := 18 + ((Lapiz ruido: i * 3 + 1) * 9).
		alto := radio * 1.8.
		rect := (bounds center x - radio + (((Lapiz ruido: i + 11) - 0.5) * 4)) @ (bounds top + u) extent: (radio * 2) @ alto.
		Lapiz islaEn: rect canvas: unCanvas semilla: i + 40.
		Lapiz islaEn: ((bounds center x - 5 + (((Lapiz ruido: i + 21) - 0.5) * 14)) @ (bounds top + u + alto + 3) extent: 11 @ 9) canvas: unCanvas semilla: i + 90.
		u := u + alto + 24.
		i := i + 1 ]
]

{ #category : 'initialization' }
DivisorMorph >> initialize [
	super initialize.
	self color: Color transparent
]

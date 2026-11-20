"
Representa el resultado de haber impactado en una nave sin llegar a hundirla 
"
Class {
	#name : 'ResultadoImpacto',
	#superclass : 'ResultadoDisparo',
	#instVars : [
		'coordenada'
	],
	#category : 'BatallaNaval-Disparos',
	#package : 'BatallaNaval-Disparos'
}

{ #category : 'instance creation' }
ResultadoImpacto class >> coordenada: unaCoordenada [
    ^ self new setCoordenada: unaCoordenada

]

{ #category : 'initialization' }
ResultadoImpacto >> coordenada [
    ^ coordenada

]

{ #category : 'testing' }
ResultadoImpacto >> esImpacto [
	^ true

]

{ #category : 'initialization' }
ResultadoImpacto >> setCoordenada: unaCoordenada [
    coordenada := unaCoordenada

]

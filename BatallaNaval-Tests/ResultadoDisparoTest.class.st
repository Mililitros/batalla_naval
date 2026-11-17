Class {
	#name : 'ResultadoDisparoTest',
	#superclass : 'TestCase',
	#category : 'BatallaNaval-Tests',
	#package : 'BatallaNaval-Tests'
}

{ #category : 'running' }
ResultadoDisparoTest >> testAguaNoEsImpactoNiHundido [

	| resultado |
	resultado := ResultadoAgua new.
	self deny: resultado esImpacto.
	self deny: resultado esHundido

]

{ #category : 'running' }
ResultadoDisparoTest >> testHundidoEsHundidoYTambienImpacto [

	| resultado |
	resultado := ResultadoHundido new.
	self assert: resultado esHundido.
	self assert: resultado esImpacto


]

{ #category : 'running' }
ResultadoDisparoTest >> testImpactoEsImpactoPeroNoHundido [

	| resultado |
	resultado := ResultadoImpacto new.
	self assert: resultado esImpacto.
	self deny: resultado esHundido

]

Class {
	#name : 'Flota',
	#superclass : 'Object',
	#instVars : [
		'naves'
	],
	#category : 'BatallaNaval-Flota',
	#package : 'BatallaNaval-Flota'
}

{ #category : 'initialization' }
Flota >> initialize [
    super initialize.
    naves := OrderedCollection new.
    
    2 timesRepeat: [ naves add: Portaaviones new ].
    2 timesRepeat: [ naves add: Acorazado new ].
    2 timesRepeat: [ naves add: Crucero new ].
    1 timesRepeat: [ naves add: Submarino new ].
    3 timesRepeat: [ naves add: Destructor new ].
]

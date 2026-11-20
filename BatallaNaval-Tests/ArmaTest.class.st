Class {
	#name : 'ArmaTest',
	#superclass : 'TestCase',
	#instVars : [
		'tablero',
		'rival',
		'origen'
	],
	#category : 'BatallaNaval-Tests',
	#package : 'BatallaNaval-Tests'
}

{ #category : 'running' }
ArmaTest >> setUp [
    super setUp.
    tablero := Tablero estandar.
    rival := Territorio superior.
    origen := Coordenada fila: 13 columna: 6

]

{ #category : 'tests' }
ArmaTest >> testCanionImpactaUnaNaveRival [

    | resultados |
    tablero ubicarNave: Destructor new desde: (Coordenada fila: 5 columna: 6) orientacion: #horizontal en: rival.
    resultados := Canion new
        disparar: { Coordenada fila: 5 columna: 6 }
        desde: origen contra: tablero rival: rival.
    self assert: resultados size equals: 1.
    self assert: resultados first esImpacto

]

{ #category : 'tests' }
ArmaTest >> testElBombardeoIgnoraLasIslas [

    | resultados |
    tablero ubicarIslaEn: (Coordenada fila: 4 columna: 4).
    resultados := BombardeoAereo new
        disparar: { Coordenada fila: 4 columna: 4. Coordenada fila: 5 columna: 5 }
        desde: origen contra: tablero rival: rival.
    self deny: resultados first esBloqueado.
    self deny: (tablero casillaEn: (Coordenada fila: 4 columna: 4)) estaRevelada



]

{ #category : 'tests' }
ArmaTest >> testElCanionTurboEnLaFronteraNoAfectaAlTerritorioPropio [
    self
        assert: (CanionTurbo new
            disparar: { Coordenada fila: 12 columna: 6 }
            desde: origen contra: tablero rival: rival) size
        equals: 4

]

{ #category : 'tests' }
ArmaTest >> testElCanionTurboImpactaEnCruz [
    self
        assert: (CanionTurbo new
            disparar: { Coordenada fila: 6 columna: 6 }
            desde: origen contra: tablero rival: rival) size
        equals: 5

]

{ #category : 'tests' }
ArmaTest >> testElTorpedoHorizontalSeRecortaEnElBorde [
    self
        assert: (TorpedoHorizontal new
            disparar: { Coordenada fila: 5 columna: 1 }
            desde: origen contra: tablero rival: rival) size
        equals: 2


]

{ #category : 'tests' }
ArmaTest >> testElTorpedoIgnoraLasNavesPropias [

    | resultados |
    tablero ubicarNave: Destructor new desde: (Coordenada fila: 15 columna: 6) orientacion: #horizontal en: Territorio inferior.
    resultados := Torpedo new
        disparar: #() desde: (Coordenada fila: 16 columna: 6) contra: tablero rival: rival.
    self deny: resultados first esImpacto




]

{ #category : 'tests' }
ArmaTest >> testElTorpedoSeDetieneEnLaPrimeraNaveRival [

    | crucero resultados |
    crucero := Crucero new.
    tablero ubicarNave: crucero desde: (Coordenada fila: 8 columna: 6) orientacion: #horizontal en: rival.
    resultados := Torpedo new
        disparar: #() desde: (Coordenada fila: 13 columna: 6) contra: tablero rival: rival.
    self assert: resultados first esImpacto.
    self assert: crucero cantidadDeImpactos equals: 1




]

{ #category : 'tests' }
ArmaTest >> testNoPuedeDispararAlPropioTerritorio [
    self
        should: [ Canion new
            disparar: { Coordenada fila: 14 columna: 6 }
            desde: origen contra: tablero rival: rival ]
        raise: ObjetivosInvalidos

]

{ #category : 'tests' }
ArmaTest >> testNoPuedeDispararFueraDeAlcance [
    self
        should: [ Canion new
            disparar: { Coordenada fila: 1 columna: 6 }
            desde: (Coordenada fila: 24 columna: 6) contra: tablero rival: rival ]
        raise: ObjetivosInvalidos

]

{ #category : 'tests' }
ArmaTest >> testUnaIslaFrenaElTorpedo [

    | crucero resultados |
    crucero := Crucero new.
    tablero ubicarNave: crucero desde: (Coordenada fila: 3 columna: 6) orientacion: #horizontal en: rival.
    tablero ubicarIslaEn: (Coordenada fila: 8 columna: 6).
    resultados := Torpedo new
        disparar: #() desde: (Coordenada fila: 13 columna: 6) contra: tablero rival: rival.
    self assert: resultados first esBloqueado.
    self assert: crucero cantidadDeImpactos equals: 0




]

Extension { #name : #PWBIRNamedEntity }

{ #category : #'*SymbolResolver' }
PWBIRNamedEntity >> hasMatchingType: aClass [ 
	^self expectedFamixKinds includes: aClass
]

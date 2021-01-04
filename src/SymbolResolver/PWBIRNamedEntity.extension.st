Extension { #name : #PWBIRNamedEntity }

{ #category : #'*SymbolResolver' }
PWBIRNamedEntity >> hasMatchingType: aClass [ 
	^self expectedFamixKinds isNotNil and: [self expectedFamixKinds includes: aClass]
]

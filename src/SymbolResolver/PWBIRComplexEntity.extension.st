Extension { #name : #PWBIRComplexEntity }

{ #category : #'*SymbolResolver' }
PWBIRComplexEntity >> asSREntityScope [
	^SREntityScope new
		entity: self ;
		yourself
]

{ #category : #'*SymbolResolver' }
PWBIRComplexEntity >> reachableEntities [
	^self members
]

Extension { #name : #PWBIRValueHolder }

{ #category : #'*SymbolResolver' }
PWBIRValueHolder >> asSREntityScope [
	^declaredType
		ifNil: [ SRNullScope new ]
		ifNotNil: [ ^SREntityScope entity: declaredType ]
]

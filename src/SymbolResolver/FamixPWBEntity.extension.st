Extension { #name : #FamixPWBEntity }

{ #category : #'*SymbolResolver' }
FamixPWBEntity >> hasMatchingType: aClass [
	^self isKindOf: aClass
]

{ #category : #'*SymbolResolver' }
FamixPWBEntity >> isResolvable [
	^ false
]

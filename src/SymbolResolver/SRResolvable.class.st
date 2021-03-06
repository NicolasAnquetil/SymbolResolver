"
I am a resolvable thing, i have an identifier and the solver will try to resolve me to fill the real entity (or candidates if multiple are possible).
"
Class {
	#name : #SRResolvable,
	#superclass : #Object,
	#instVars : [
		'identifier',
		'node',
		'next',
		'expectedKind',
		'foundAction',
		'notFoundReplacementEntity',
		'isCaseSensitive',
		'arrayDefinition',
		'previous'
	],
	#category : #'SymbolResolver-Core'
}

{ #category : #'instance creation' }
SRResolvable class >> name: anIdentifier expectedKind: aKind node: aNode [ 
	^ (self name: anIdentifier node: aNode)
		expectedKind: aKind;
		yourself
]

{ #category : #'instance creation' }
SRResolvable class >> name: aString node: aNode [
	^ self new
		identifier: aString ;
		node: aNode ;
		yourself
]

{ #category : #'instance creation' }
SRResolvable class >> name: aString node: aNode next: aNextIdentifierWithNode [
	^ self new
		identifier: aString ;
		node: aNode ;
		next: aNextIdentifierWithNode ;
		yourself
]

{ #category : #hooks }
SRResolvable >> applyReplacementStrategyWithCurrentEntity: aCurrentEntity [
	self subclassResponsibility 
]

{ #category : #accessing }
SRResolvable >> arrayDefinition [
	^ arrayDefinition
]

{ #category : #accessing }
SRResolvable >> arrayDefinition: anObject [
	arrayDefinition := anObject
]

{ #category : #resolution }
SRResolvable >> checkKindOfEntity: anEntity [
	self expectedKind ifNil: [ ^ true ].
	^ self expectedKind isCollection
		ifTrue: [ self expectedKind
				anySatisfy: [ :expectedPossibility | anEntity hasMatchingType: expectedPossibility ] ]
		ifFalse: [ anEntity isKindOf: self expectedKind ]
]

{ #category : #accessing }
SRResolvable >> entity [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SRResolvable >> expectedKind [
	^ expectedKind
]

{ #category : #accessing }
SRResolvable >> expectedKind: anObject [
	expectedKind := anObject
]

{ #category : #accessing }
SRResolvable >> foundAction [
	^ foundAction
]

{ #category : #accessing }
SRResolvable >> foundAction: anObject [
	foundAction := anObject
]

{ #category : #testing }
SRResolvable >> hasFoundAction [
	^ self foundAction notNil
]

{ #category : #testing }
SRResolvable >> hasReplacementStrategy [
	^ self notFoundReplacementEntity notNil
]

{ #category : #accessing }
SRResolvable >> identifier [
	^ identifier
]

{ #category : #accessing }
SRResolvable >> identifier: anObject [
	identifier := anObject
]

{ #category : #resolution }
SRResolvable >> initialize [
	super initialize.
	isCaseSensitive := true
]

{ #category : #accessing }
SRResolvable >> isCaseSensitive [
	^ isCaseSensitive
]

{ #category : #accessing }
SRResolvable >> isCaseSensitive: aBoolean [
	isCaseSensitive := aBoolean
]

{ #category : #testing }
SRResolvable >> isFirst [
	^ self previous isNil
]

{ #category : #testing }
SRResolvable >> isLast [
	^ self next isNil
]

{ #category : #testing }
SRResolvable >> isResolvable [
	^ true
]

{ #category : #resolution }
SRResolvable >> name: aString isSameAs: anotherString [
	^ self isCaseSensitive
		ifTrue: [ aString = anotherString ]
		ifFalse: [ aString asLowercase = anotherString asLowercase ]
]

{ #category : #accessing }
SRResolvable >> next [
	^ next
]

{ #category : #accessing }
SRResolvable >> next: anObject [
	next := anObject.
	anObject previous: self
]

{ #category : #accessing }
SRResolvable >> node [
	^ node
]

{ #category : #accessing }
SRResolvable >> node: anObject [
	node := anObject
]

{ #category : #accessing }
SRResolvable >> notFoundReplacementEntity [
	^ notFoundReplacementEntity
]

{ #category : #accessing }
SRResolvable >> notFoundReplacementEntity: anObject [
	notFoundReplacementEntity := anObject
]

{ #category : #accessing }
SRResolvable >> previous [
	^ previous
]

{ #category : #accessing }
SRResolvable >> previous: aSResolvable [
	previous := aSResolvable
]

{ #category : #printing }
SRResolvable >> printIdentifierPath: aStream [
	aStream nextPutAll: self identifier.
	self isLast
		ifFalse: [ aStream nextPut: $..
			self next printIdentifierPath: aStream ]
]

{ #category : #printing }
SRResolvable >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self printIdentifierPath: aStream.
	aStream nextPut: $)
]

{ #category : #hooks }
SRResolvable >> replacementWhenUnresolvedIn: currentEntity [
	^self hasReplacementStrategy
		ifTrue: [ | replacementEntity |
			self applyReplacementStrategyWithCurrentEntity: currentEntity.
			replacementEntity := self triggerFoundActionWithCurrentEntity: currentEntity.
			self isLast
			ifFalse: [
				self
					resolveChained: self next
					usedIn: currentEntity
					definedIn: self entity asSREntityScope
			] ]
		ifFalse: [
			SRReferencesNotFound signalIdentifiers: self ]
]

{ #category : #printing }
SRResolvable >> representationString [
	^ String streamContents: [ :s | self printIdentifierPath: s ]
]

{ #category : #resolution }
SRResolvable >> resolveChained: usedIdentifier usedIn: currentEntity definedIn: owningScope [
	"similar to SRReferenceToResolve >> resolve, but will look only in one scope"
	owningScope isNullPatternObject
	ifTrue: [ ^ usedIdentifier replacementWhenUnresolvedIn: currentEntity ]
	ifFalse: [
		[ usedIdentifier resolveInScope: owningScope currentEntity: currentEntity  ]
		on: NotFound
		do: [ ^ usedIdentifier replacementWhenUnresolvedIn: currentEntity ] ]
]

{ #category : #resolution }
SRResolvable >> resolveInScope: aScope currentEntity: currentEntity [ 
	^ self subclassResponsibility 
]

{ #category : #accessing }
SRResolvable >> startPosition [
	^ self isFirst
		ifTrue: [ node startPosition ]
		ifFalse: [ self previous startPosition ]
]

{ #category : #accessing }
SRResolvable >> stopPosition [
	^ self isLast
		ifTrue: [ node stopPosition ]
		ifFalse: [ self next stopPosition ]
]

{ #category : #accessing }
SRResolvable >> targetEntity [
	^ self isLast
		ifFalse: [ self next targetEntity ]
		ifTrue: [ self entity ]
]

{ #category : #hooks }
SRResolvable >> triggerFoundActionWithCurrentEntity: aCurrentEntity [
	aCurrentEntity isNullPatternObject
		ifTrue: [ ^ aCurrentEntity ].
	^self hasFoundAction
		ifTrue: [ self foundAction cull: self cull: aCurrentEntity ]
		ifFalse: [ self entity ]

]

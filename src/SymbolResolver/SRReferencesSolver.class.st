"
I am a class that can solve references

I also handle the current entity visited, which is the one making the references.
Current entity is found by going up the scope stack and finding the first scope which has a #currentEntity

Note: should be renamed #referencingEntity ?
"
Class {
	#name : #SRReferencesSolver,
	#superclass : #Object,
	#instVars : [
		'scopes',
		'isCaseSensitive'
	],
	#category : #'SymbolResolver-Solver'
}

{ #category : #'scopes management' }
SRReferencesSolver >> copyScopes [
	^ scopes := scopes copy
]

{ #category : #manager }
SRReferencesSolver >> createScopeManager [
	^ SRScopeManager newAssociatedToSolver: self
]

{ #category : #accessing }
SRReferencesSolver >> currentEntity [
	"Finds the innermost scope that has a #currentEntity (the one making a reference to a Resolvable)"
	^ (self scopes
		detect: [:e | e hasCurrentEntity]
		ifNone: [ SRNoCurrentEntityAvailable signalReferencesResolver: self ]) currentEntity
]

{ #category : #alias }
SRReferencesSolver >> defineAliasInCurrentScope: aString for: aBlockClosure [
	self topScope addAlias: aString forEntity: aBlockClosure value
]

{ #category : #accessing }
SRReferencesSolver >> detect: aBlock [
	"Detects the scope for which aBlock evaluates to true."
	^ self scopes detect: aBlock
]

{ #category : #initialization }
SRReferencesSolver >> initialize [
	super initialize.
	self scopes: Stack new.
	isCaseSensitive := true
]

{ #category : #accessing }
SRReferencesSolver >> isCaseSensitive [
	^ isCaseSensitive
]

{ #category : #accessing }
SRReferencesSolver >> isCaseSensitive: anObject [
	isCaseSensitive := anObject
]

{ #category : #accessing }
SRReferencesSolver >> peekScopeAtIndex: anInteger [
	"DISCLAIMER:
	 Returns the scope at index anInteger (index 1 is the top of the stack).
	 This method is really specific and should usually NOT BE USED.
	 Beware, if you use it you're problably doing it wrongly.
	 However there are some special cases where you need to do it."
	^ self scopes at: anInteger
]

{ #category : #'scopes management' }
SRReferencesSolver >> popScope [
	^ self copyScopes pop
]

{ #category : #'scopes management' }
SRReferencesSolver >> pushAsScopeAll: aType ofModel: aModel [
	self
		pushScope:
			(SRFamixTypeScope new
				model: aModel;
				entityType: aType;
				yourself)
]

{ #category : #'scopes management' }
SRReferencesSolver >> pushEntitiesAsScope: aCollectionOfEntities [
	self pushScope: (SRCollectionScope reachableEntities: aCollectionOfEntities)
]

{ #category : #'scopes management' }
SRReferencesSolver >> pushEntityAsScope: anEntity [
	self pushScope: (SREntityScope entity: anEntity)
]

{ #category : #'scopes management' }
SRReferencesSolver >> pushIRModelAsScope: aDictionnary [
	self pushScope: (SRIRModelScope model: aDictionnary)
]

{ #category : #'scopes management' }
SRReferencesSolver >> pushScope: aScope [
	^ self copyScopes push: aScope
]

{ #category : #detect }
SRReferencesSolver >> reachableEntitiesFor: aScope detect: aBlockClosure ifFound: aBlockClosureAction [
	"optimisation to avoid recreate collection"

	aScope reachableEntities
		detect: aBlockClosure
		ifFound: [ :f | ^ aBlockClosureAction value: f ]
		ifNone: [ "continue" ].
	NotFound signal
]

{ #category : #'scopes management' }
SRReferencesSolver >> removeScope: aScope [
	self copyScopes remove: aScope
]

{ #category : #factory }
SRReferencesSolver >> resolvable: aResolvable [
	^aResolvable
		isCaseSensitive: self isCaseSensitive  ;
		yourself
]

{ #category : #resolution }
SRReferencesSolver >> resolve: aChainOfIdentifiers [
	"a collection of identifier will be for example {'myTable' . 'columnA'}"

	self scopes
		do: [ :aScope | 
			[ ^ aChainOfIdentifiers resolveInScope: aScope currentEntity: self currentEntity ]
				on: NotFound
				do: [ "do nothing to try superior scope" ] ].
	aChainOfIdentifiers hasReplacementStrategy
		ifTrue: [ aChainOfIdentifiers applyReplacementStrategyWithCurrentEntity: self currentEntity.
			^ aChainOfIdentifiers triggerFoundActionWithCurrentEntity: self currentEntity ]
		ifFalse: [ SRReferencesNotFound signalIdentifiers: aChainOfIdentifiers ]
]

{ #category : #accessing }
SRReferencesSolver >> scopes [
	^ scopes
]

{ #category : #accessing }
SRReferencesSolver >> scopes: anObject [
	scopes := anObject
]

{ #category : #accessing }
SRReferencesSolver >> topScope [
	^ self scopes top
]

{ #category : #accessing }
SRReferencesSolver >> topScopeReachableEntities [
	^ self topScope reachableEntities
]

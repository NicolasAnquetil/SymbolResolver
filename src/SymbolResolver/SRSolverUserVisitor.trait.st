"
I am a trait for visitors that are using a solver
"
Trait {
	#name : #SRSolverUserVisitor,
	#instVars : [
		'solver',
		'errorReport'
	],
	#category : #'SymbolResolver-Core'
}

{ #category : #accessing }
SRSolverUserVisitor >> currentEntity [
	^ self solver currentEntity
]

{ #category : #alias }
SRSolverUserVisitor >> defineAliasInCurrentScope: anAlias for: aBlockClosure [
	^ self solver defineAliasInCurrentScope: anAlias for: aBlockClosure
]

{ #category : #accessing }
SRSolverUserVisitor >> errorReport [
	errorReport ifNil: [ errorReport := SRParsingReport new ].
	^ errorReport
]

{ #category : #accessing }
SRSolverUserVisitor >> errorReport: anObject [
	errorReport := anObject
]

{ #category : #initialization }
SRSolverUserVisitor >> initialiseFutureSolver [
	solver := SRFutureReferencesSolver new.
	solver isCaseSensitive: false
]

{ #category : #initialization }
SRSolverUserVisitor >> initialiseSolver [
	solver := SRReferencesSolver new
]

{ #category : #scope }
SRSolverUserVisitor >> popScope [
	^ self solver popScope
]

{ #category : #scope }
SRSolverUserVisitor >> pushAsScopeAll: aType ofModel: aModel [ 
	self solver pushAsScopeAll: aType ofModel: aModel 
]

{ #category : #scope }
SRSolverUserVisitor >> pushEntitiesAsScope: aCollectionOfEntities [
	self solver pushEntitiesAsScope: aCollectionOfEntities
]

{ #category : #scope }
SRSolverUserVisitor >> pushEntityAsScope: anEntity [
	self solver pushEntityAsScope: anEntity
]

{ #category : #scope }
SRSolverUserVisitor >> pushIRModelAsScope: aDictionnary [
	self solver pushIRModelAsScope: aDictionnary
]

{ #category : #factory }
SRSolverUserVisitor >> resolvable: aResolvable [
	^ self solver resolvable: aResolvable
]

{ #category : #resolution }
SRSolverUserVisitor >> resolve: identifiers [
	self solver resolve: identifiers
]

{ #category : #resolution }
SRSolverUserVisitor >> resolve: identifiers onNotFoundDo: aBlock [
	^ [ self solver resolve: identifiers ]
		on: SRReferencesNotFound
		do: [ aBlock value: identifiers ]
]

{ #category : #resolution }
SRSolverUserVisitor >> resolveSilently: identifiers [
	self errorReport
		catch: SRReferencesInconsistencies , SRReferencesNotFound
		during: [ self resolve: identifiers ]
]

{ #category : #accessing }
SRSolverUserVisitor >> solver [
	^ solver
]

{ #category : #accessing }
SRSolverUserVisitor >> solver: aSolver [
	solver := aSolver
]

{ #category : #accessing }
SRSolverUserVisitor >> topScopeReachableEntities [
	^ self solver topScopeReachableEntities
]

{ #category : #scope }
SRSolverUserVisitor >> useCurrentEntity: anEntity during: aBlock [
	self useScope: (SREntityScope currentEntity: anEntity) during: aBlock.
	"backward compatibility with old return"
	^anEntity
]

{ #category : #scope }
SRSolverUserVisitor >> useEntityNamed: aName ofType: aType during: aBlock [
	^ self
		useCurrentEntity:
			((self model entityStorage selectAllWithType: aType)
				detect: [ :entity | entity name = aName ])
		during: aBlock
]

{ #category : #scope }
SRSolverUserVisitor >> useScope: aScope during: aBlock [
	| result |
	self solver pushScope: aScope.
	[ result := aBlock value]
	ensure: [
		"This assert is to check that the good scope is poped"
		self assert: self solver topScope = aScope.
		self popScope ].
	^ result
]

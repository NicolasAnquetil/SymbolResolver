Class {
	#name : #SRReferencesSolverTest,
	#superclass : #TestCase,
	#instVars : [
		'referencesSolver'
	],
	#category : #'SymbolResolver-Tests'
}

{ #category : #running }
SRReferencesSolverTest >> setUp [
	referencesSolver := SRReferencesSolver new
]

{ #category : #tests }
SRReferencesSolverTest >> testCreateScopeManager [
	| scopeManager |
	scopeManager := referencesSolver createScopeManager.
	
	self assert: scopeManager class equals: SRScopeManager.
	self assert: scopeManager associatedSolver equals: referencesSolver
]

{ #category : #tests }
SRReferencesSolverTest >> testCurrentEntity [
	| mockEntity |
	mockEntity := Mock new.
	mockEntity stub asSREntityScope
		willReturn: (SREntityScope new
			entity: mockEntity ;
			isCurrentEntity: true ;
			yourself).

	self should: [ referencesSolver currentEntity ] raise: SRNoCurrentEntityAvailable.

	referencesSolver pushScope: (SREntityScope new
			entity: (Object new) ;
			isCurrentEntity: false ;
			yourself).
	self should: [ referencesSolver currentEntity ] raise: SRNoCurrentEntityAvailable.
			
	referencesSolver pushScope: (SREntityScope currentEntity: mockEntity).
	self assert: referencesSolver currentEntity equals: mockEntity.
	
	referencesSolver pushScope: (SRCollectionScope reachableEntities: { Object new }).
	self assert: referencesSolver currentEntity equals: mockEntity.

]

{ #category : #tests }
SRReferencesSolverTest >> testEnsureScopesAreCopied [
	| firstScope scopesFirstState secondScope scopesSecondState |
	firstScope := SREntityScope new.
	secondScope := SREntityScope new.
	referencesSolver pushScope: firstScope.
	scopesFirstState := referencesSolver scopes.
	self assert: scopesFirstState equals: {firstScope}.
	referencesSolver pushScope: secondScope.
	scopesSecondState := referencesSolver scopes.
	self
		assert: scopesSecondState
		equals:
			{secondScope.
			firstScope}.
	self deny: scopesFirstState == scopesSecondState.
	self assert: scopesFirstState equals: {firstScope}
]

{ #category : #tests }
SRReferencesSolverTest >> testIRModelScope [
	| irModel |
	irModel := PWBIRModel new.
	irModel createIR: PWBIRType named: 'typ1' owner: nil.
	irModel createIR: PWBIRType named: 'typ2' owner: #anything.

	referencesSolver pushIRModelAsScope: irModel.

	self should: [ referencesSolver currentEntity ] raise: SRNoCurrentEntityAvailable.
	self assert: referencesSolver topScopeReachableEntities size equals: 2.
	self assert: (referencesSolver topScopeReachableEntities anyOne name beginsWith: 'typ')

]

{ #category : #tests }
SRReferencesSolverTest >> testPopScope [
	| sizeBefore scope |
	sizeBefore := referencesSolver scopes size.
	scope := SRScope new.
	referencesSolver pushScope: scope.
	self assert: referencesSolver scopes size equals: sizeBefore + 1.
	
	referencesSolver popScope.
	self assert: referencesSolver scopes size equals: sizeBefore
]

{ #category : #tests }
SRReferencesSolverTest >> testPushEntitiesAsScope [
	| entities |
	entities := { Object new. Object new. Object new }.
	
	referencesSolver pushEntitiesAsScope: entities.
	
	self assert: referencesSolver scopes first class equals: SRCollectionScope.
	self assert: referencesSolver scopes first reachableEntitiesOwned equals: entities.
]

{ #category : #tests }
SRReferencesSolverTest >> testPushEntityAsScope [
	| mockEntity |
	mockEntity := Mock new.
	mockEntity stub asSREntityScope
		willReturn: (SREntityScope new
			entity: mockEntity ;
			isCurrentEntity: true ;
			yourself).
	
	referencesSolver pushEntityAsScope: mockEntity.
	
	self assert: referencesSolver scopes first class equals: SREntityScope.
	self assert: referencesSolver scopes first entity equals: mockEntity.
]

{ #category : #tests }
SRReferencesSolverTest >> testPushScope [
	| scope |
	scope := SRScope new.
	referencesSolver pushScope: scope.
	
	self assert: referencesSolver scopes first equals: scope
]

{ #category : #tests }
SRReferencesSolverTest >> testRemoveScope [
	| scopesCount scope1 scope2 scope3 |
	scopesCount := referencesSolver scopes size.
	scope1 := SRScope new.
	scope2 := SRScope new.
	scope3 := SRScope new.
	referencesSolver pushScope: scope1.
	referencesSolver pushScope: scope2.
	referencesSolver pushScope: scope3.
	
	self assert: referencesSolver scopes size equals: scopesCount + 3.
	self assert: referencesSolver scopes first equals: scope3.
	self assert: referencesSolver scopes allButFirst first equals: scope2.
	self assert: (referencesSolver scopes allButFirst: 2) first equals: scope1.
	
	referencesSolver removeScope: scope2.
	
	self assert: referencesSolver scopes size equals: scopesCount + 2.
	self assert: referencesSolver scopes first equals: scope3.
	self assert: referencesSolver scopes allButFirst first equals: scope1
]

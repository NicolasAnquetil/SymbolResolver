"
I represent a reference that will be resolved in the future.

I contain everything required for that:
- identifier to look for (SRResolvable)
- scopes where to look for (SRScope)
- actions (in the SRResolvable) to perform when I am resolved or if I cannot be resolved

And I know the #currentEntity that references me
"
Class {
	#name : #SRReferenceToResolve,
	#superclass : #Object,
	#instVars : [
		'scopes',
		'identifiers'
	],
	#category : #'SymbolResolver-Solver'
}

{ #category : #'instance creation' }
SRReferenceToResolve class >> newFromScopes: aCollectionOfScopes identifiers: aSRIdentifierWithNode [
	^ self new
		scopes: aCollectionOfScopes;
		identifiers: aSRIdentifierWithNode;
		yourself
]

{ #category : #accessing }
SRReferenceToResolve >> currentEntity [
	"returns the entity making a reference to self"
	^ (self scopes
		detect: #hasCurrentEntity
		ifNone: [ SRNoCurrentEntityAvailable signalReferencesResolver: self ])
		currentEntity
]

{ #category : #accessing }
SRReferenceToResolve >> identifiers [
	^ identifiers
]

{ #category : #accessing }
SRReferenceToResolve >> identifiers: anObject [
	identifiers := anObject
]

{ #category : #printing }
SRReferenceToResolve >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	identifiers printOn: aStream.
	aStream nextPut: $)
]

{ #category : #resolution }
SRReferenceToResolve >> replacementForUnresolvedIdentifier [
	^identifiers replacementWhenUnresolvedIn: self currentEntity.

]

{ #category : #resolution }
SRReferenceToResolve >> resolve [
	self scopes
		do: [ :aScope | 
			[ ^ identifiers resolveInScope: aScope currentEntity: self currentEntity  ]
				on: NotFound
				do: [ "do nothing to try superior scope" ] ].
	^ self replacementForUnresolvedIdentifier
]

{ #category : #accessing }
SRReferenceToResolve >> scopes [
	^ scopes
]

{ #category : #accessing }
SRReferenceToResolve >> scopes: anObject [
	"Scopes are poped and pushed during the visit but the mechanism ensure that you can point a collection of scopes because a copy is done each time. This way its limitate the memory usage"
	scopes := anObject
]

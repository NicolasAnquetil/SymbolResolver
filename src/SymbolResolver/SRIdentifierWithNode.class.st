"
I am a resolvable only identified by an identifier (like an instance variable or a property)
"
Class {
	#name : #SRIdentifierWithNode,
	#superclass : #SRResolvable,
	#instVars : [
		'entity',
		'access'
	],
	#category : #'SymbolResolver-Core'
}

{ #category : #'as yet unclassified' }
SRIdentifierWithNode class >> identifier: anIdentifier expectedKind: aKind node: aNode arrayWithSize: aString [
	^ (self name: anIdentifier node: aNode)
		expectedKind: aKind;
		arrayDefinition: aString;
		yourself
]

{ #category : #accessing }
SRIdentifierWithNode >> access [
	^ access
]

{ #category : #accessing }
SRIdentifierWithNode >> access: anObject [
	access := anObject
]

{ #category : #hooks }
SRIdentifierWithNode >> applyReplacementStrategyWithCurrentEntity: aCurrentEntity [
	aCurrentEntity isNullPatternObject ifTrue: [ ^ self ].
	self
		entity: (self notFoundReplacementEntity cull: self cull: aCurrentEntity)
]

{ #category : #accessing }
SRIdentifierWithNode >> entity [
	^ entity
]

{ #category : #accessing }
SRIdentifierWithNode >> entity: anObject [
	entity := anObject
]

{ #category : #resolution }
SRIdentifierWithNode >> resolveInScope: aScope currentEntity: currentEntity [
	currentEntity isNullPatternObject
		ifTrue: [ ^ currentEntity ].

	self
		entity:
			(aScope
				detect: [ :anEntity | 
					(self name: anEntity name isSameAs: self identifier)
						and: [ self checkKindOfEntity: anEntity ] ]).
	self triggerFoundActionWithCurrentEntity: currentEntity.

	self isLast ifFalse: [
		^self
			resolveChained: self next
			usedIn: currentEntity
			definedIn: self entity ].
	^self entity

]

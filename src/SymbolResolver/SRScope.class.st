"
A scope contains (reachable) entities

- reachableEntities
- reachableEntitiesOwned
- canContainsEntitiesOfType:

Note: aliases don't seem to be used anymore
"
Class {
	#name : #SRScope,
	#superclass : #Object,
	#instVars : [
		'aliases'
	],
	#category : #'SymbolResolver-Scopes'
}

{ #category : #adding }
SRScope >> addAlias: anAlias forEntity: aCorrespondingEntity [
	self aliases
		add:
			(SRAliasDefinition new
				alias: anAlias;
				entity: aCorrespondingEntity;
				yourself)
]

{ #category : #accessing }
SRScope >> aliases [
	^ aliases ifNil: [ aliases := OrderedCollection new ] ifNotNil: [ aliases ]
]

{ #category : #accessing }
SRScope >> aliases: anObject [
	aliases := anObject
]

{ #category : #converting }
SRScope >> asSREntityScope [
	^self
]

{ #category : #testing }
SRScope >> canContainsEntitiesOfType: aClass [ 
	^ true
]

{ #category : #helpers }
SRScope >> createReferenceEntityFrom: aFmxEntity [ 
	"I am a convenient function that does nothing because an identifier pointed this scope (because of an aliasing)"
]

{ #category : #iterator }
SRScope >> detect: aBlockClosure [ 
	^ self reachableEntitiesOwned detect: aBlockClosure
]

{ #category : #accessing }
SRScope >> hasAliases [
	^ aliases notNil and: [ aliases notEmpty ]
]

{ #category : #testing }
SRScope >> hasCurrentEntity [
	^ false
]

{ #category : #testing }
SRScope >> isEntityScope [
	^ false
]

{ #category : #testing }
SRScope >> isNullPatternObject [
	^false
]

{ #category : #convenient }
SRScope >> mooseModel: aMooseModel [ 
	""
]

{ #category : #accessing }
SRScope >> reachableEntities [
	^ self hasAliases
		ifTrue: [ self aliases , self reachableEntitiesOwned ]
		ifFalse: [ self reachableEntitiesOwned ]
]

{ #category : #accessing }
SRScope >> reachableEntitiesOwned [
	^ self subclassResponsibility 
]

{ #category : #iterator }
SRScope >> select: aBlockClosure [
	^ self reachableEntitiesOwned select: aBlockClosure
]

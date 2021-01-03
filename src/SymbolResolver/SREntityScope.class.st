"
I am a scope based on one entity (either a Famix or an IR entity).
My reachable entities are the ones reachable by my entity.
My entity can be the 'current' one (basically meaning it can make references to identifiers) or not
"
Class {
	#name : #SREntityScope,
	#superclass : #SRScope,
	#instVars : [
		'entity',
		'isCurrentEntity'
	],
	#category : #'SymbolResolver-Scopes'
}

{ #category : #accessing }
SREntityScope class >> currentEntity: anEntity [
	^ (self entity: anEntity)
		isCurrentEntity: true;
		yourself
]

{ #category : #accessing }
SREntityScope class >> entity: anEntity [
	^ (anEntity asSREntityScope)
		isCurrentEntity: false;
		yourself
]

{ #category : #accessing }
SREntityScope >> currentEntity [
	self assert: self isCurrentEntity.
	^ self entity
]

{ #category : #accessing }
SREntityScope >> entity [
	^ entity
]

{ #category : #accessing }
SREntityScope >> entity: anObject [
1haltIf: [ anObject class = PWBIRValueHolder ].
	entity := anObject
]

{ #category : #accessing }
SREntityScope >> hasCurrentEntity [
	^ self isCurrentEntity
]

{ #category : #initialization }
SREntityScope >> initialize [
	super initialize.
	self isCurrentEntity: false
]

{ #category : #accessing }
SREntityScope >> isCurrentEntity [
	^ isCurrentEntity
]

{ #category : #accessing }
SREntityScope >> isCurrentEntity: anObject [
	isCurrentEntity := anObject
]

{ #category : #accessing }
SREntityScope >> isEntityScope [
	^ true
]

{ #category : #printing }
SREntityScope >> printOn: aStream [
	super printOn: aStream.
	aStream << $(.
	aStream << $".
	self entity
		ifNil: [ aStream << 'No Entity' ]
		ifNotNil: [ self entity name printOn: aStream.
			aStream << '":'.
			self entity class printOn: aStream ].
	aStream << $)
]

{ #category : #accessing }
SREntityScope >> reachableEntitiesOwned [
	^ self entity reachableEntities
]

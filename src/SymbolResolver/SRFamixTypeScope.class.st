"
I am a scope that provides all entities of a givewn Famix type in a model
For example:
  `SRFamixTypeScope new entityType: FamixPWBFunction`
"
Class {
	#name : #SRFamixTypeScope,
	#superclass : #SRScope,
	#instVars : [
		'model',
		'entityType'
	],
	#category : #'SymbolResolver-Scopes'
}

{ #category : #testing }
SRFamixTypeScope >> canContainsEntitiesOfType: aType [
	^ aType isNil
		or:
			[ aType = self entityType or: [ aType inheritsFrom: self entityType ] ]
]

{ #category : #accessing }
SRFamixTypeScope >> entityType [
	^ entityType
]

{ #category : #accessing }
SRFamixTypeScope >> entityType: anObject [
	entityType := anObject
]

{ #category : #accessing }
SRFamixTypeScope >> model [
	^ model
]

{ #category : #accessing }
SRFamixTypeScope >> model: anObject [
	model := anObject
]

{ #category : #accessing }
SRFamixTypeScope >> printOn: aStream [
	super printOn: aStream.
	aStream << $(.
	self model printOn: aStream.
	aStream << '->'.
	self entityType printOn: aStream.
	aStream << $)
]

{ #category : #accessing }
SRFamixTypeScope >> reachableEntitiesOwned [
	^ self model entityStorage selectAllWithType: self entityType
]

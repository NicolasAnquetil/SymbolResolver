"
I am a scope defined by a collection of all its reachable entities.
I am ignored considering the current entity level.
"
Class {
	#name : #SRCollectionScope,
	#superclass : #SRScope,
	#instVars : [
		'reachableEntitiesOwned'
	],
	#category : #'SymbolResolver-Scopes'
}

{ #category : #'instance creation' }
SRCollectionScope class >> reachableEntities: aMooseGroup [
	^ self new
		reachableEntitiesOwned: aMooseGroup;
		yourself
]

{ #category : #accessing }
SRCollectionScope >> reachableEntitiesOwned [
	^ reachableEntitiesOwned
]

{ #category : #accessing }
SRCollectionScope >> reachableEntitiesOwned: aCollection [
	reachableEntitiesOwned := aCollection 
]

Class {
	#name : #SRIRModelScope,
	#superclass : #SRScope,
	#instVars : [
		'dictionnary'
	],
	#category : #'SymbolResolver-Scopes'
}

{ #category : #accessing }
SRIRModelScope class >> model: aDictionnary [
	^self new
		model: aDictionnary ;
		yourself
]

{ #category : #accessing }
SRIRModelScope >> model: aDictionnary [
	dictionnary := aDictionnary 
]

{ #category : #accessing }
SRIRModelScope >> reachableEntitiesOwned [
	^ dictionnary values flatCollect: [ :irEntities | irEntities select: [ :ir | ir owner isNil ] ]
]

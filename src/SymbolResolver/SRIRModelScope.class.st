Class {
	#name : #SRIRModelScope,
	#superclass : #SRScope,
	#instVars : [
		'irModel'
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
	irModel := aDictionnary 
]

{ #category : #accessing }
SRIRModelScope >> reachableEntitiesOwned [
	^ irModel reachableEntitiesOwned
]

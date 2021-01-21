Class {
	#name : #SRThisWithNode,
	#superclass : #SRResolvable,
	#instVars : [
		'entity',
		'validationAsTypeBlock'
	],
	#category : #'SymbolResolver-Core'
}

{ #category : #accessing }
SRThisWithNode class >> node: aNode [
	^ self new node: aNode
]

{ #category : #accessing }
SRThisWithNode class >> node: aNode validationBlock: validationAsTypeBlock [
	^ self new
		node: aNode;
		validationBlock: validationAsTypeBlock;
		yourself
]

{ #category : #hooks }
SRThisWithNode >> applyReplacementStrategyWithCurrentEntity: aCurrentEntity [
	"there should always be a #currentEntity to which 'this' refers"
	self shouldNotImplement
]

{ #category : #accessing }
SRThisWithNode >> entity [
	^ entity
]

{ #category : #accessing }
SRThisWithNode >> entity: anObject [
	entity := anObject
]

{ #category : #printing }
SRThisWithNode >> printIdentifierPath: aStream [
	aStream nextPutAll: 'this'
]

{ #category : #resolution }
SRThisWithNode >> resolveInScope: aSRScope currentEntity: currentEntity [
	(aSRScope isEntityScope and: [ self validateThisEntity: aSRScope entity ])
		ifFalse: [ NotFound signal ]
		ifTrue: [ self entity: aSRScope entity.
			self triggerFoundActionWithCurrentEntity: currentEntity.
			^ self entity ]
]

{ #category : #validation }
SRThisWithNode >> validateThisEntity: aFamixEntity [
	^ self validationBlock value: aFamixEntity
]

{ #category : #accessing }
SRThisWithNode >> validationBlock [
	^ validationAsTypeBlock
]

{ #category : #accessing }
SRThisWithNode >> validationBlock: anObject [
	validationAsTypeBlock := anObject
]

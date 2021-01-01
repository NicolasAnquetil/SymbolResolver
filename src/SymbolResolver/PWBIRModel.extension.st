Extension { #name : #PWBIRModel }

{ #category : #'*SymbolResolver' }
PWBIRModel >> reachableEntitiesOwned [
	"small optimization not using #getAllEntities"
	^ irEntities values flatCollect: [ :each | each select: [ :ir | ir owner isNil ] ]
]

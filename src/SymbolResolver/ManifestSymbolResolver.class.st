"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestSymbolResolver,
	#superclass : #PackageManifest,
	#category : #'SymbolResolver-Manifest'
}

{ #category : #'code-critics' }
ManifestSymbolResolver class >> ruleRBEmptyExceptionHandlerRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#SRReferenceToResolve #resolve #false)) #'2020-12-30T11:40:59.483383+01:00') )
]

Class {
	#name : 'MyNullPieceTest',
	#superclass : 'TestCase',
	#category : 'Myg-Chess-Tests',
	#package : 'Myg-Chess-Tests'
}

{ #category : 'tests' }
MyNullPieceTest >> testNullPieceBehavior [
	| nullPiece |
	nullPiece := MyNullPiece new.

	self assert: nullPiece isEmpty.
	self assert: nullPiece isPiece not.
	self assert: (nullPiece targetSquaresLegal: true) isEmpty
]

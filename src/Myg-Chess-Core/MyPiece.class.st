Class {
	#name : 'MyPiece',
	#superclass : 'Object',
	#instVars : [
		'color',
		'square'
	],
	#category : 'Myg-Chess-Core',
	#package : 'Myg-Chess-Core'
}

{ #category : 'constants' }
MyPiece class >> black [

	^ self new
		  color: Color black;
		  yourself
]

{ #category : 'constants' }
MyPiece class >> white [

	^ self new
		  color: Color white;
		  yourself
]

{ #category : 'as yet unclassified' }
MyPiece >> attackingSquares [

	^ self legalTargetSquares
]

{ #category : 'path commands' }
MyPiece >> board [

	^ square board
]

{ #category : 'testing' }
MyPiece >> canMoveTo: aSquare [
	self board ifNil: [ ^ true ].
	aSquare ifNil: [ ^ false ]. 

	^ self simulateMoveTo: aSquare during: [ self isKingSafe ]
]

{ #category : 'rendering' }
MyPiece >> collectSquares: aBlock [

	^ self collectSquares: aBlock legal: false
	

]

{ #category : 'rendering' }
MyPiece >> collectSquares: aBlock legal: shouldBeLegal [
	^ self collectSquares: aBlock while: [ :aSquare |
		aSquare notNil
			and: [ aSquare contents isPiece not ]
	]
]

{ #category : 'rendering' }
MyPiece >> collectSquares: collectBlock while: untilBlock [
	| targets next |

	targets := OrderedCollection new.

	next := square.

	[ untilBlock value: (next := collectBlock value: next) ]
		whileTrue: [
			targets add: next
		].

	next ifNotNil: [
		(next contents notNil and: [ next contents isPiece ]) ifTrue: [
			targets add: next
		]
	].

	^ targets
]

{ #category : 'accessing' }
MyPiece >> color [

	^ color
]

{ #category : 'accessing' }
MyPiece >> color: aColor [

	color := aColor
]

{ #category : 'rendering' }
MyPiece >> downFile [
	^ self downFileLegal: false
]

{ #category : 'rendering' }
MyPiece >> downFileLegal: aBoolean [
	| squares current |
	squares := OrderedCollection new.
	self square ifNil: [ ^ squares ].
	
	current := self square down.
	[ current isNotNil ] whileTrue: [
		squares add: current.
	
		current contents isPiece ifTrue: [
			current contents color ~= color ifTrue: [ squares add: current ].
			^ squares
		].
		current := current down.
	].
	
	^ squares
]

{ #category : 'rendering' }
MyPiece >> downLeftDiagonal [

	^ self downLeftDiagonalLegal: false
]

{ #category : 'rendering' }
MyPiece >> downLeftDiagonalLegal: aBoolean [

	^ self
		  collectSquares: [ :aSquare | aSquare down ifNotNil: #left ]
		  legal: aBoolean
]

{ #category : 'rendering' }
MyPiece >> downRightDiagonal [

	^ self downRightDiagonalLegal: false
]

{ #category : 'rendering' }
MyPiece >> downRightDiagonalLegal: aBoolean [

	^ self
		  collectSquares: [ :aSquare | aSquare down ifNotNil: #right ]
		  legal: aBoolean
]

{ #category : 'accessing' }
MyPiece >> id [

	^ 'Q'
]

{ #category : 'testing' }
MyPiece >> isEmpty [
	^ false
]

{ #category : 'testing' }
MyPiece >> isKing [
	^ false
]

{ #category : 'testing' }
MyPiece >> isKingSafe [
	| myKing validPieces |
	self board ifNil: [ ^ true ].
	
	"On ne garde que les vraies pièces (non nil)"
	validPieces := self board pieces select: [ :p | p isNotNil ].
	
	myKing := validPieces 
		detect: [ :p | p isKing and: [ p color = self color ] ] 
		ifNone: [ ^ true ].

	^ (validPieces select: [ :p | p color ~= self color and: [ p square isNotNil ] ])
		noneSatisfy: [ :enemy | 
			(enemy targetSquaresLegal: false) includes: myKing square ]
]

{ #category : 'testing' }
MyPiece >> isPiece [
	
	^ true
]

{ #category : 'testing' }
MyPiece >> isWhite [
	
	^ color isBlack not
]

{ #category : 'rendering' }
MyPiece >> leftFile [

	^ self leftFileLegal: false
]

{ #category : 'rendering' }
MyPiece >> leftFileLegal: aBoolean [
	^ self collectSquares: [ :aSquare | aSquare left ] legal: aBoolean
]

{ #category : 'rendering' }
MyPiece >> legalTargetSquares [
	self board ifNil: [ ^ self targetSquares ].

	^ self targetSquares select: [ :aSquare |
		self canMoveTo: aSquare
	]
]

{ #category : 'path commands' }
MyPiece >> moveTo: aSquare [

	(self legalTargetSquares includes: aSquare) ifFalse: [ ^ self ].

	square emptyContents.
	square := aSquare.
	aSquare contents: self
]

{ #category : 'rendering' }
MyPiece >> rightFile [

	^ self rightFileLegal: false
]

{ #category : 'rendering' }
MyPiece >> rightFileLegal: aBoolean [
	^ self collectSquares: [ :aSquare | aSquare right ] legal: aBoolean
]

{ #category : 'as yet unclassified' }
MyPiece >> simulateMoveTo: aSquare during: aBlock [
	| oldSquare targetContents result |
	oldSquare := square.
	targetContents := aSquare contents.

	oldSquare ifNotNil: [ oldSquare contents: nil ].
	square := aSquare.
	aSquare contents: self.

	result := aBlock value.

	aSquare contents: targetContents.
	square := oldSquare.
	oldSquare ifNotNil: [ oldSquare contents: self ].

	^ result
]

{ #category : 'accessing' }
MyPiece >> square [
	^ square
]

{ #category : 'accessing' }
MyPiece >> square: aMyChessSquare [ 
	
	square := aMyChessSquare
]

{ #category : 'rendering' }
MyPiece >> targetSquares [
	
	^ self subclassResponsibility
]

{ #category : 'rendering' }
MyPiece >> targetSquaresLegal: aBoolean [

	self subclassResponsibility
]

{ #category : 'rendering' }
MyPiece >> upFile [

	^ self upFileLegal: false
]

{ #category : 'rendering' }
MyPiece >> upFileLegal: aBoolean [
	^ self collectSquares: [ :aSquare | aSquare up ] legal: aBoolean
]

{ #category : 'rendering' }
MyPiece >> upLeftDiagonal [

	^ self upLeftDiagonalLegal: false
]

{ #category : 'rendering' }
MyPiece >> upLeftDiagonalLegal: aBoolean [

	^ self collectSquares: [ :aSquare | aSquare up ifNotNil: #left ] legal: aBoolean
]

{ #category : 'rendering' }
MyPiece >> upRightDiagonal [

	^ self upRightDiagonalLegal: false
]

{ #category : 'rendering' }
MyPiece >> upRightDiagonalLegal: aBoolean [

	^ self
		  collectSquares: [ :aSquare | aSquare up ifNotNil: #right ]
		  legal: aBoolean
]

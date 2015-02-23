# This imports all the layers for "LocalGuide_Screen2" into localguide_screen2Layers
Screen2 = Framer.Importer.load "imported/LocalGuide_Screen2"

for layerGroupName of Screen2
  window[layerGroupName] = Screen2[layerGroupName]
  #make Screen 2 disappear
 

for layerGroupName of Screen2
  Screen2[layerGroupName].originalFrame = window[layerGroupName].frame

# This imports all the layers for "LocalGuide" into localguideLayers
Screen1 = Framer.Importer.load "imported/LocalGuide"


#import layers and their initial states
mapSlot = new Layer
	width:640, height:400, x:0, y:110

map = new Layer width:1120,height:883,image:"images/map.png",superLayer:mapSlot
appBack = new Layer width:640, height:525, backgroundColor:"#FFFFFF",y:510

dragSection = new Layer width:640, height:960, backgroundColor:"#FFFFFF", superLayer:appBack
dragSection.draggable.enabled = true
dragSection.draggable.speedX = 0

locationError = new Layer width:640,height:60,image:"images/locationErrorBar.png",
y:110,opacity:0

comboTitle = new Layer x:17,y:25, width:400, height:40, backgroundColor:"#FFF",
superLayer: dragSection
comboTitle.html = "<span style='color:grey; font-size:30px'>Popular tours near your area</span>"

fishermanCombo = new Layer y:50,width:700, height:300, image:"images/fishermanCombo.png",
superLayer:dragSection
fishermanCombo.centerX()

techCombo = new Layer width:700, height:300, image:"images/techtour.png", y:320, superLayer:dragSection
techCombo.centerX()

nightLifeCombo = new Layer width:700, height:300, image:"images/nightLife.png", y:590, superLayer:dragSection
nightLifeCombo.centerX()

famousCombo = new Layer width:700, height:300, image:"images/famousSite.png", y:590, superLayer:dragSection
famousCombo.centerX()
famousCombo.visible = false

historyCombo = new Layer width:700, height:300, image:"images/historycombo.png", y:590, superLayer:dragSection
historyCombo.centerX()
historyCombo.visible = false

downtownCombo = new Layer width:700, height:300, image:"images/downtownCombo.png", y:590, superLayer:dragSection
downtownCombo.centerX()
downtownCombo.visible = false

locationUn = new Layer width:70, height:70, image:"images/locationUnselected.png",
superLayer:mapSlot, x:30, y:300
locationUn.states.add
	hide: {opacity:0}

locationSelected = new Layer width:70, height:70, image:"images/locationSelected.png",
superLayer:mapSlot, x:30, y:300, opacity:0
locationSelected.states.add
	show: {opacity:1}
	
myLocation = new Layer scale:1.5, image:"images/myLocation.png", opacity:0,superLayer:mapSlot
myLocation.center();
myLocation.states.add("show",{opacity:1})

loadingArrow = new Layer width:100, height:115, image:"images/loading.png", superLayer:appBack, opacity:0
loadingArrow.states.add("show",{opacity:1})
loadingArrow.center()

startingPinOne = new Layer width:176, height:269,image:"images/redPin.png",scale: 0.3, superLayer:mapSlot, y:-300

startingPinTwo = new Layer width:176, height:269,image:"images/redPin.png",scale: 0.3, superLayer:mapSlot, x:200, y:-300

startingPinThree = new Layer width:176, height:269,image:"images/redPin.png",scale: 0.3, superLayer:mapSlot, x:400, y:-300

protoWarning = new Layer width:640, height:60, image:"images/protoWarning.png", y:110,opacity:0
protoWarning.visible = false

screen2Button = new Layer width:640, height:1035,y:100,opacity:0,backgroundColor:"#000"
screen2Button.visible = false

wcButtonScreener = new Layer width:640, height:1035,y:100,opacity:0,backgroundColor:"#FFF"
wcButtonScreener.visible = false

#activate button event listener layer
cButton = new Layer width:60,height:60,x:440,y:940,opacity:0
cButton.visible = false

wButton = new Layer width:60,height:60,x:540,y:940,opacity:0
wButton.visible = false


appear=(element)->
	element.animate({properties:{opacity:1},time:0.2})

springVal = 'spring(800,60,0)'
springVal2 = 'spring(500,30,10)'

#events on drag lower section
dragUpperY = dragSection.y
dragLowerY = dragSection.y-380

beingDragged = false;

#red pin animator after reallocating
redPinDragAnimator=->
	if locationErrorCheck == true
		return
	if dragSection.y > -10
		first = startingPinOne.animate({properties:{y:-30},time:0.1})
		first.on Events.AnimationEnd,->
			last = startingPinOne.animate({properties:{y:0},time:0.1})
	else if dragSection.y < -100 && dragSection.y > -250
		first = startingPinTwo.animate({properties:{y:170},time:0.1})
		first.on Events.AnimationEnd,->
			last = startingPinTwo.animate({properties:{y:200},time:0.1})
	else if dragSection.y < -400
		first = startingPinThree.animate({properties:{y:27},time:0.1})
		first.on Events.AnimationEnd,->
			last = startingPinThree.animate({properties:{y:57},time:0.1})


#bounce back if dragged too much
boundaryBounce=(section)->
	if section.y > 20
		section.animate 
			properties: y:dragUpperY, time:0.3
			curve:springVal
	else if section.y < -400
		section.animate 
			properties: y:dragLowerY, time:0.3
			curve:springVal
	
	
dragSection.on Events.DragMove,->
	draggingY = this.y
	redPinDragAnimator()
	beingDragged = true;
	boundaryBounce(this)

dragSection.on Events.DragEnd,->
	beingDragged = false
	boundaryBounce(this)
	
	

#loading error function
loadError = (combo)->
	if locationError.isAnimating is true
		return
	else if beingDragged is true
		return
	else
		combo.on Events.Click,->
			locationError.animate
				properties: opacity:1
				time:0.5
			
			locationUn.ignoreEvents = true
			locationError.on Events.AnimationEnd,->
				Utils.delay 2,->
					loadContentPage()

#reallocate warning animation
loadError(fishermanCombo)
loadError(techCombo)
loadError(nightLifeCombo)

locationErrorCheck = true

loadContentPage=->
	#turn off locationUn
	locationUn.visible = false
	locationError.visible = false
	#reset appback position and lock scroll
	dragSection.y = dragUpperY
	
	#Show selected
	locationSelected.states.switchInstant("show")
	#turn off original combos
	comboTitle.opacity = 0
	fishermanCombo.visible = false
	techCombo.visible = false
	nightLifeCombo.visible = false
	#loading screen
	loadingArrow.states.switchInstant("show");
	loadingArrow.animate
		properties: rotation:180
		time:3
	#move maps
	map.animate
		properties: x:-300, y:-400
		curve:'spring(100,12,0)'
	
	locationErrorCheck = false
	
	#Show my location
	map.on Events.AnimationEnd,->
		myLocation.states.switchInstant("show")
		myLocation.animate
			properties: rotation:90
			curve:'cubic-bezier(0.4, 0, 0.2, 1)'	
		loadingArrow.opacity = 0
		#pop up new pins
		startingPinOne.animate 
			properties: y:0
			time:0.3
			curve: "spring(200,20,0)"
		startingPinTwo.animate
			properties: y:200
			time:0.3
			curve: "spring(200,20,0)"
		startingPinThree.animate
			properties: y:57
			time:0.3
			curve: "spring(200,20,0)"
	#pop up new tours
		myLocation.on Events.AnimationEnd,->
		newTours = [famousCombo, historyCombo, downtownCombo]
		dis = 50
		comboTitle.opacity = 1
		for combo in newTours
			combo.visible = true
			combo.centerX()
			combo.animate
				properties: y:dis
				curve: "spring(200,30,5)"
			dis += 270

#animation of relocating
locationUn.on Events.Click, ->
	loadContentPage()
					



			
Screen1Elements = [mapSlot, Screen1.mapSlot, Screen1.Bar__Status_Bar__White__LocalGuide, Screen1.LowerBar, appBack]

Screen2Pins = [startPin,Pin2,Pin3,Pin4,Pin5,Pin6]
for pin in Screen2Pins
	pin.y = pin.originalFrame.y - 1000
	pin.opacity = 0


Screen2Paths = [path1,path2,path3,path4,path5,path6]
for path in Screen2Paths
	path.opacity = 0

Screen2Hide = [siteIntroAbout,siteIntroRecDuration,tourIntro5,tourIntro4,tourIntro3,tourIntro2,tourIntro1,
historicalPark,Car,walkIcon,firstRoadMap_6,firstRoadMap_5,firstRoadMap_4,firstRoadMap_3,
firstRoadMap_2,firstRoadMap,path62,path52,path42,path32,path22,path12,tripBeginButton,pinIntro,routeIntro,hotelIntro,tripIntro,leftSlide,rightSlide,sixthDes,fifthDes,fourthDes,thirdDes,
secondDes,firstDes,indicatorBar,noProto,pinDirect,cancelTrip,routeBar,uberWindow,blackCircle3,blackCircle2,blackCircle1,loadCircle3,loadCircle2,loadCircle1,uberContact,destinationOne]
#hide rest of UI
for element in Screen2Hide
	element.visible = false

loadTravellingPage=->
	if beingDragged is true
		return
	if protoWarning.isAnimating is true
		protoWarning.visible = false
		
	tripBeginButton.visible = true

	#drag away screen 1
	for element in Screen1Elements
		element.animate
			properties: x:-650
			curve:springVal
		element.on Events.AnimationEnd,->
			element.destroy()


famousCombo.on Events.Click,->
	loadTravellingPage()
					
#first time load Screen 2
firstLoadChecker = true	

#pin loader checker
isFirstPinsFalling = true

pathAnimator=(path,delay)->
	path.animate
		properties: opacity:1
		time:0.3
		delay:delay
	
pinAnimator=(pin,delay)->
	pin.animate
		properties: y: pin.originalFrame.y, opacity:1
		time:0.3
		delay:0.1+delay
		curve:springVal2

#set up pins and routes
mapSlot.on Events.AnimationEnd,->
		#put in layer to prevent premature clicking
		Screen1.buildOwn.visible = false
		pathAnimator(path1,0)
		pinAnimator(startPin,0)
		pathAnimator(path2,0.2)
		pinAnimator(Pin2,0.2)
		pathAnimator(path3,0.4)
		pinAnimator(Pin3,0.4)
		pathAnimator(path4,0.6)
		pinAnimator(Pin4,0.6)
		pathAnimator(path5,0.8)
		pinAnimator(Pin5,0.8)
		pathAnimator(path6,1)
		lastPin = pinAnimator(Pin6,1)
		
		lastPin.on Events.AnimationEnd,->
			pinIntro.opacity = 0
			pinIntro.visible = true
			routeIntro.opacity = 0
			routeIntro.visible = true
			tripIntro.opacity = 0
			tripIntro.visible = true
			hotelIntro.opacity = 0
			hotelIntro.visible = true
			pinIntro.animate({properties:{opacity:1},time:0.2})
			tripIntro.animate({properties:{opacity:1},time:0.2})
			hotelIntro.animate({properties:{opacity:1},time:0.2})
			lastRoute = routeIntro.animate({properties:{opacity:1},time:0.2})
			lastRoute.on Events.AnimationEnd,->
				screen2Button.visible = true
				startScreen = screen2Button.on Events.Click,->
					screen2Button.visible = false
					pinIntro.animate({properties:{opacity:0},time:0.2})
					tripIntro.animate({properties:{opacity:0},time:0.2})
					hotelIntro.animate({properties:{opacity:0},time:0.2})
					disp = routeIntro.animate({properties:{opacity:0},time:0.2})
					firstLoadChecker = false
					isFirstPinsFalling = false
					disp.on Events.AnimationEnd,->
						pinIntro.visible = false
						routeIntro.visible = false
						tripIntro.visible = false
						hotelIntro.visible = false
					

						
			#load indicator bars
			indicatorBar.opacity = 0
			rightSlide.opacity = 0
			firstDes.opacity = 0
							
			indicatorBar.visible = true
			leftSlide.visible = true
			rightSlide.visible = true
			firstDes.visible = true
							
			appear(indicatorBar)
			appear(leftSlide)
			appear(rightSlide)
			appear(firstDes)
			desDraggableLoader()
					
				
				
			
#function to hide on screen pins and blur background

firstTimeChecker = true

elementBlur=(element)->
	element.animate
		properties: blur:10
		time:0.3

elementDeblur=(element)->
	element.animate
		properties: blur:0
		time:0.3
		
screen2Blur=->
	for pin in Screen2Pins
		elementBlur(pin)
	for path in Screen2Paths
		elementBlur(path)
	elementBlur(mapFull)
	elementBlur(tripBeginButton)
	elementBlur(hotelButton)
	elementBlur(myLocationS2)
	elementBlur(indicatorBar)
	elementBlur(leftSlide)
	elementBlur(rightSlide)
	elementBlur(firstDes)
	elementBlur(secondDes)
	elementBlur(thirdDes)
	elementBlur(fourthDes)
	elementBlur(fifthDes)
	elementBlur(sixthDes)
	elementBlur(pinDirect)
	elementBlur(cancelTrip)
	elementBlur(destinationOne)
	elementBlur(routeBar)
			
screen2Deblur=->
	for pin in Screen2Pins
		elementDeblur(pin)
	for path in Screen2Paths
		elementDeblur(path)
	elementDeblur(mapFull)
	elementDeblur(tripBeginButton)
	elementDeblur(hotelButton)
	elementDeblur(myLocationS2)
	elementDeblur(indicatorBar)
	elementDeblur(leftSlide)
	elementDeblur(rightSlide)
	elementDeblur(firstDes)
	elementDeblur(secondDes)
	elementDeblur(thirdDes)
	elementDeblur(fourthDes)
	elementDeblur(fifthDes)
	elementDeblur(sixthDes)
	elementDeblur(pinDirect)
	elementDeblur(cancelTrip)
	elementDeblur(destinationOne)
	elementDeblur(routeBar)
	
	
## Intro pop up window animator
introsAnimator=(intro)->
	if isFirstPinsFalling is true
		return
	intro.blur = 5
	intro.scale = 0.8
	#load corresponsding intro
	intro.visible = true
	#load button activator to revert
	intro.animate
		properties: scale:1, blur:0
		time:0.2
		curve:'spring(300,20,0)'
	if firstTimeChecker is true
		siteIntroAbout.visible = true
		siteIntroRecDuration.visible = true
	
	screen2Blur()

	intro.on Events.AnimationEnd,->
		#load deactivator
		if intro.visible == true
			screen2Button.visible = true
			
		screen2Button.on Events.Click,->
			final = intro.animate
				properties: blur:5,scale:1
				curve:'spring(300,20,0)'
				
			if firstTimeChecker is true
				siteIntroAbout.visible = false
				siteIntroRecDuration.visible = false
				firstTimeChecker = false
			
			intro.visible = false
			#intro deblur
			screen2Deblur()
			screen2Button.visible = false

pathGroupOne = [path1,firstRoadMap,path12,startPin]
pathGroupTwo = [path2,firstRoadMap_2,path22,Pin2]
pathGroupThree = [path3,firstRoadMap_3,path32,Pin3]
pathGroupFour = [path4,firstRoadMap_4,path42,Pin4]
pathGroupFive = [path5,firstRoadMap_5,path52,Pin5]
pathGroupSix = [path6,firstRoadMap_6,path62,Pin6]

#animate path intros
pathIntroAnimator=(pathGroup)->
	#don't animate if the screen is still loading
	if isFirstPinsFalling is true
		return
	pathGroup[1].opacity = 0
	pathGroup[2].opacity = 0
	pathGroup[1].visible = true
	pathGroup[1].animate	
		properties:opacity:1
		time:0.1
	pathGroup[2].visible = true
	pathGroup[2].animate
		properties:opacity:1
		time:0.1
	pathGroup[3].animate
		properties:scale:1.3
		time:0.1
	
	pathGroup[2].on Events.AnimationEnd,->
		if pathGroup[2].visible == true
			screen2Button.visible = true
			screen2Button.on Events.Click,->
				pathGroup[1].animate
					properties:opacity:0
					time:0.1
				pathGroup[2].animate
					properties:opacity:0
					time:0.1
				appear = pathGroup[3].animate
					properties:scale:1
					time:0.1
				appear.on Events.AnimationEnd,->
					pathGroup[1].visible = false
					pathGroup[2].visible = false
					screen2Button.visible = false				
	
#pin and intro section animation
startPin.on Events.Click,->
	introsAnimator(tourIntro1)
Pin2.on Events.Click,->
	introsAnimator(tourIntro2)
Pin3.on Events.Click,->
	introsAnimator(historicalPark)
Pin4.on Events.Click,->
	introsAnimator(tourIntro3)
Pin5.on Events.Click,->
	introsAnimator(tourIntro4)
Pin6.on Events.Click,->
	introsAnimator(tourIntro5)
path1.on Events.Click,->
	pathIntroAnimator(pathGroupOne)
path2.on Events.Click,->
	pathIntroAnimator(pathGroupTwo)
path3.on Events.Click,->
	pathIntroAnimator(pathGroupThree)
path4.on Events.Click,->
	pathIntroAnimator(pathGroupFour)
path5.on Events.Click,->
	pathIntroAnimator(pathGroupFive)	
path6.on Events.Click,->
	pathIntroAnimator(pathGroupSix)

tripIconAnimator=->
	if isFirstPinsFalling is true
		return
	if walkIcon.visible == true
		return
		
	screen2Blur()
	
	Car.y = Car.originalFrame.y + 700
	Car.scale = 0.3
	walkIcon.y = walkIcon.originalFrame.y + 700
	walkIcon.scale = 0.3
	Car.visible = true
	walkIcon.visible = true
	Car.animate
		properties: y:Car.originalFrame.y, scale:1
		time:0.2
		curve:'spring(300,20,0)'
	appear = walkIcon.animate
		properties: y:walkIcon.originalFrame.y, scale:1
		time:0.2
		delay:0.2
		curve:'spring(300,20,0)'
		
	cButton.visible = true
	wButton.visible = true
		
	wcButtonScreener.visible = true
	
	wcButtonScreener.on Events.Click,->
		callBackButtons()
	
#call back walkIcon and car icons
callBackButtons =->
	if wcButtonScreener.visible is true
		wcButtonScreener.visible = false
	screen2Button.visible = false
	Car.animate
		properties: y:Car.originalFrame.y+300, scale:0.2
		time:0.1
		curve:'spring(300,20,0)'
	returnWalk = walkIcon.animate
		properties: y:walkIcon.originalFrame.y+300, scale:0.2
		time:0.1
		delay:0.1
		curve:'spring(300,20,0)'
	screen2Deblur()	
	returnWalk.on Events.AnimationEnd,->
		Car.visible = false
		walkIcon.visible = false
	cButton.visible = false
	wButton.visible = false


#click on let the trip begin
tripBeginButton.on Events.Click,->
	tripIconAnimator()

textSlideOutToLeft=(text)->
	text.animate
		properties: x:-640, opacity:0
		curve:"spring(350,35,0)"

textSlideOutToRight=(text)->
	text.animate
		properties: x:640, opacity:0
		curve:"spring(350,35,0)"

textSlideInFromRight=(text)->
	text.x = 640
	text.animate
		properties: x:text.originalFrame.x, opacity:1
		curve:"spring(350,35,0)"

textSlideInFromLeft=(text)->
	text.x = -640
	text.animate
		properties: x:text.originalFrame.x, opacity:1
		curve:"spring(350,35,0)"

### --------------------- 
	Major Event: Overview Animation
	--------------------- ###  

desDraggableLoader=->
	placeNames = [secondDes,thirdDes,fourthDes,fifthDes,sixthDes]
	for place in placeNames
		place.visible = true
		place.opacity = 0
		place.x = 640
		place.draggable.enabled = true
		place.draggable.speedY = 0

	firstDes.draggable.enabled = true
	firstDes.draggable.speedY = 0


desAnimator=(leftDes,des,rightDes,leftPin,pin,rightPin)->
	
	des.on Events.DragEnd,->
		if pin.scale != 1
			pin.animate({properties:{scale:1},time:0.2})
							
		##Drag to right, left slide in
		if des.x > des.originalFrame.x
			textSlideOutToRight(des)
			textSlideInFromLeft(leftDes)
			pinEnlarge = leftPin.animate({properties:{scale:1.3},time:0.2})

		else
			textSlideOutToLeft(des)
			textSlideInFromRight(rightDes)
			pinEnlarge = rightPin.animate({properties:{scale:1.3},time:0.2})

#animate destination text dragging
desAnimator(sixthDes,firstDes,secondDes,Pin6,startPin,Pin2)
desAnimator(firstDes,secondDes,thirdDes,startPin,Pin2,Pin3)
desAnimator(secondDes,thirdDes,fourthDes,Pin2,Pin3,Pin4)
desAnimator(thirdDes,fourthDes,fifthDes,Pin3,Pin4,Pin5)
desAnimator(fourthDes,fifthDes,sixthDes,Pin4,Pin5,Pin6)
desAnimator(fifthDes,sixthDes,firstDes,Pin5,Pin6,startPin)

				
				
				
				
#prototype banner appear function
prototypeWarningLoader=->
	if protoWarning.visible is true
		return
	protoWarning.visible = true
	warningAppear = protoWarning.animate({properties:{opacity:1},time:1})
	warningAppear.on Events.AnimationEnd,->
		warningDisappear = protoWarning.animate({properties:{opacity:0},time:1,delay:0.5})
		warningDisappear.on Events.AnimationEnd,->
			protoWarning.visible = false
	
historyCombo.on Events.Click,->
	loadTravellingPage()
downtownCombo.on Events.Click,->
	loadTravellingPage()
backPage.on Events.Click,->
	prototypeWarningLoader()
cancelTrip.on Events.Click,->
	prototypeWarningLoader()
Screen1.buildOwn.on Events.Click,->
	prototypeWarningLoader()
	
	
hotelButton.on Events.Click,->
	if isFirstPinsFalling is true
		return
	prototypeWarningLoader(hotelButton)
	
#start walking
tripScreenLoading=->
	destinationOne.y = 640
	destinationOne.visible = true
	#let path stop listening to events
	placeNames = [secondDes,thirdDes,fourthDes,fifthDes,sixthDes]
	for place in placeNames
		place.visible = true
		place.opacity = 0
		place.x = 640

	backPage.visible = false
	
	firstDes.opacity = 1
	firstDes.x = firstDes.originalFrame.x

	path1.ignoreEvents = true
	
	for pin in Screen2Pins
		pin.visible = false
	for path in Screen2Paths
		path.visible = false
	
	tripBeginButton.visible = false
	cancelTrip.visible = true
	
	path1.visible = true
	
	#set pin initial location
	pinDirect.scale = 2
	pinDirect.x = pinDirect.x - 50
	pinDirect.y = pinDirect.y + 30
	
	callBackButtons()
	#turn off buttons
	wButton.visible = false
	cButton.visible = false
	#enlarge map
	mapFull.scale = 2
	mapFull.y = mapFull.y-380
	mapFull.x = mapFull.x-130
	
	startPin.scale = 1.5
	
	path1.scale = 2
	path1.y = path1.y-250
	path1.x = path1.x-200
	
	myLocationS2.scale = 2
	myLocationS2.y = myLocationS2.y-190
	myLocationS2.x = myLocationS2.x-55
	
	locationSpin = myLocationS2.animate
		properties: rotation:350
		curve:'cubic-bezier(0.4, 0, 0.2, 1)'
	
	Utils.delay 0.5,->
		destinationUp = destinationOne.animate
			properties: y:destinationOne.originalFrame.y
			curve:springVal
		destinationUp.on Events.AnimationEnd,->
			pinDirect.visible = true
			destinationOne.on Events.Click,->
				introsAnimator(tourIntro1)

loadingAnimator=->
	blackCircle1.opacity = 1
	loadCircle2.opacity = 1
	loadCircle3.opacity = 1
	Utils.delay 0.5,->
		blackCircle1.opacity = 0
		loadCircle1.opacity = 1
		loadCircle2.opacity = 0
		blackCircle2.opacity = 1
		loadCircle3.opacity = 1
		Utils.delay 0.5,->
			loadCircle1.opacity = 1
			loadCircle2.opacity = 1
			blackCircle2.opacity = 0
			blackCircle3.opacity = 1
			loadCircle3.opacity = 0
			Utils.delay 0.5,->
				loadCircle1.opacity = 0
				blackCircle1.opacity = 1
				loadCircle2.opacity = 1
				blackCircle3.opacity = 0
				loadCircle3.opacity = 1
				Utils.delay 0.5,->
					blackCircle1.opacity = 0
					loadCircle1.opacity = 1
					loadCircle2.opacity = 0
					blackCircle2.opacity = 1
					loadCircle3.opacity = 1
					loadCircle3.animate({properties:{opacity:1},time:0.1})


	
wButton.on Events.Click,->
	tripScreenLoading()
	routeBar.visible = true
	
#start ubering
cButton.on Events.Click,->
	tripScreenLoading()
	
	#loading Uber module
	Utils.delay 0.5,->
		uberContact.visible = true
		loadCircles = [loadCircle1,loadCircle2,loadCircle3]
		blackCircles = [blackCircle1,blackCircle2,blackCircle3]
		for circle in loadCircles
			circle.visible = true
			circle.opacity = 0
		for circle in blackCircles
			circle.visible = true
			circle.opacity = 0
		
		Utils.delay 0.2,->
			loadingAnimator()
			loadCircle3.on Events.AnimationEnd,->
				for circle in loadCircles
					circle.visible = false
				for circle in blackCircles
					circle.visible = false
				screen2Blur()
				uberWindow.scale = 0.7
				uberWindow.blur = 5
				uberWindow.visible = true
				uberWindow.animate({properties:{scale:1,blur:0},curve:springVal})
				cancelTrip.ignoreEvents = true
				hotelButton.ignoreEvents = true				

				
	
	
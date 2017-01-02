 
; Accelerated Scrolling
; V1.3
; By BoffinbraiN

#NoEnv
 
#SingleInstance, Force
#MaxHotkeysPerInterval 120
Menu, Tray, Icon, Shell32.dll, 29
Process, Priority, , H
SendMode Input

; Show scroll velocity as a tooltip while scrolling. 1 or 0.
tooltips := 1

; The length of a scrolling session.
; Keep scrolling within this time to accumulate boost.
; Default: 500. Recommended between 400 and 1000.
timeout := 400

; If you scroll a long distance in one session, apply additional boost factor.
; The higher the value, the longer it takes to activate, and the slower it accumulates.
; Set to zero to disable completely. Default: 30.
boost := 10

; Spamming applications with hundreds of individual scroll events can slow them down.
; This sets the maximum number of scrolls sent per click, i.e. max velocity. Default: 60.
limit := 15

; Runtime variables. Do not modify.
distance := 0
vmax := 1

; Key bindings
WheelUp::
    Goto Scroll
	return
WheelDown::
  Goto Scroll
 return

Scroll:
	t := A_TimeSincePriorHotkey
	if (A_PriorHotkey = A_ThisHotkey && t < timeout)
	{
		; Remember how many times we've scrolled in the current direction
		distance++

		; Calculate acceleration factor using a 1/x curve
		v := (t < 80 && t > 1) ? (250.0 / t) - 1 : 1

		; Apply boost
		if (boost > 1 && distance > boost)
		{
			; Hold onto the highest speed we've achieved during this boost
			if (v > vmax)
				vmax := v
			else
				v := vmax

			v *= distance / boost
		}

		; Validate
		v := (v > 1) ? ((v > limit) ? limit : Floor(v)) : 1

		if (v > 1 && tooltips)
			 tmp=1 ;null statement

		MouseClick, %A_ThisHotkey%, , , v
	}
	else
	{
		; Combo broken, so reset session variables
		distance := 0
		vmax := 1

		MouseClick %A_ThisHotkey%
	}
	return

 

 
 
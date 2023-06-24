#!/bin/sh
# Start wish (#!/usr/bin/wish)  \
exec wish "$0" ${1+"$@"}

set scale 1

proc dpi { pixles } {
  global scale
  return [expr {$pixles*$scale}]
}

wm title . "El-kalkylator"
wm geometry . [dpi 640]x[dpi 480]+100+100
wm iconphoto . [image create photo -file pig.gif]

tk scaling [expr {1.0/$scale}]

# LEFT FRAME
frame .leftFrame -background gray0 -height [dpi 480] -width [dpi 320]
pack .leftFrame -side left -anchor w -expand false -fill y


# RIGHT FRAME
frame .rightFrame -background gray10 -height [dpi 480] -width [dpi 320]
pack .rightFrame -side left -anchor w -expand true -fill both -after .leftFrame

# LABEL
proc newLabel { itemId itemText } {
  return [label .$itemId -font {Helvetica -12} -text $itemText -background gray0 -foreground gray50 -borderwidth 0 -highlightthickness 0 -activebackground gray2 -activeforeground gray60 -anchor w -padx [dpi 10]]
}

# INPUT
proc newTextInput { inputId } {
  return [text .$inputId -font {Helvetica -12} -background gray15 -foreground gray50 -borderwidth 0 -highlightthickness 1 -highlightcolor gray30 -highlightbackground gray20 -selectborderwidth 0 -selectbackground turquoise -selectforeground turquoise4 -insertbackground gray50 -insertwidth 1 -insertofftime 500 -insertontime 500 -padx [dpi 5] -pady [dpi 5]]
}

# BUTTON
proc newButton { itemId itemText } {
  return [label .$itemId -font {Helvetica -12} -text $itemText -background orange -foreground gray0 -borderwidth 0 -highlightthickness 0 -activebackground gray2 -activeforeground gray60 -anchor w -padx [dpi 5]]
}

# RESULT
proc newResult { itemId itemText } {
  return [label .$itemId -font {Helvetica -12} -text $itemText -background gray10 -foreground gold -borderwidth 0 -highlightthickness 0 -activebackground gray2 -activeforeground gray60 -anchor w -padx [dpi 10]]
}

set yp [dpi 10]

# FÖRBRUKNING LABEL
newLabel forbrukningLabel "Förbrukning (kWh)"
place .forbrukningLabel -in .leftFrame -x 0 -y [dpi $yp] -width [dpi 300] -height [dpi 26]

incr yp [dpi 26]

# FÖRBRUKNING INPUT
newTextInput "forbrukningInput"
place .forbrukningInput -in .leftFrame -x [dpi 10] -y [dpi $yp] -width [dpi 300] -height [dpi 26]

incr yp [dpi 36]

# ELÖVERFÖRING LABEL
newLabel eloverforingLabel "Elöverföring (öre/kWh)"
place .eloverforingLabel -in .leftFrame -x 0 -y [dpi $yp] -width [dpi 300] -height [dpi 26]

incr yp [dpi 26] 

# ELÖVERFÖRING INPUT
newTextInput "eloverforingInput"
place .eloverforingInput -in .leftFrame -x [dpi 10] -y [dpi $yp] -width [dpi 300] -height [dpi 26]

incr yp [dpi 36]

# ENERGISKATT LABEL
newLabel energiskattLabel "Energiskatt (öre/kWh)"
place .energiskattLabel -in .leftFrame -x 0 -y [dpi $yp] -width [dpi 300] -height [dpi 26]

incr yp [dpi 26] 

# ENERGISKATT INPUT
newTextInput "energiskattInput"
place .energiskattInput -in .leftFrame -x [dpi 10] -y [dpi $yp] -width [dpi 300] -height [dpi 26]

incr yp [dpi 36]

# ELPRIS LABEL
newLabel elprisLabel "Elpris (öre/kWh)"
place .elprisLabel -in .leftFrame -x 0 -y [dpi $yp] -width [dpi 300] -height [dpi 26]

incr yp [dpi 26] 

# ELPRIS INPUT
newTextInput "elprisInput"
place .elprisInput -in .leftFrame -x [dpi 10] -y [dpi $yp] -width [dpi 300] -height [dpi 26]

incr yp [dpi 36]

# SPOTPÅSLAG LABEL
newLabel spotpaslagLabel "Spotpåslag (öre/kWh)"
place .spotpaslagLabel -in .leftFrame -x 0 -y [dpi $yp] -width [dpi 300] -height [dpi 26]

incr yp [dpi 26] 

# SPOTPÅSLAG INPUT
newTextInput "spotpaslagInput"
place .spotpaslagInput -in .leftFrame -x [dpi 10] -y [dpi $yp] -width [dpi 300] -height [dpi 26]

incr yp [dpi 36]

# ELCENTRAL LABEL
newLabel elcentralLabel "Elcentral (öre/kWh)"
place .elcentralLabel -in .leftFrame -x 0 -y [dpi $yp] -width [dpi 300] -height [dpi 26]

incr yp [dpi 26] 

# ELCENTRAL INPUT
newTextInput "elcentralInput"
place .elcentralInput -in .leftFrame -x [dpi 10] -y [dpi $yp] -width [dpi 300] -height [dpi 26]

incr yp [dpi 88]

# CALCULATE BUTTON
newButton calculateButton "Räkna ut pris"
set buttonWidth [expr {[font measure {Helvetica -12} "Räkna ut pris"]+10}]
set buttonPos [expr {320-$buttonWidth-10}]
place .calculateButton -in .leftFrame -x [dpi $buttonPos] -y [dpi $yp] -width [dpi $buttonWidth] -height [dpi 26]
bind .calculateButton <ButtonPress-1> calculateResult

## RIGHT FRAME

proc calculateResult {} {
  set yp [dpi 36]
  
  set forbrukning [.forbrukningInput get 0.0 "end - 1 char"]
  set forbrukningValid [string is double -strict $forbrukning]
  
  set eloverforing [.eloverforingInput get 0.0 "end - 1 char"]
  set eloverforingValid [string is double -strict $eloverforing]

  set energiskatt [.energiskattInput get 0.0 "end - 1 char"]
  set energiskattValid [string is double -strict $energiskatt]

  set elpris [.elprisInput get 0.0 "end - 1 char"]
  set elprisValid [string is double -strict $elpris]

  set spotpaslag [.spotpaslagInput get 0.0 "end - 1 char"]
  set spotpaslagValid [string is double -strict $spotpaslag]

  set elcentral [.elcentralInput get 0.0 "end - 1 char"]
  set elcentralValid [string is double -strict $elcentral]

  
  # FÖRBRUKNING RESULT LABEL
  destroy .forbrukningResult

  if {$forbrukningValid} {
    newResult forbrukningResult "[format "%.2f" $forbrukning] kWh"
    place .forbrukningResult -in .rightFrame -x 0 -y [dpi $yp] -width [dpi 300] -height [dpi 26]
  }

  incr yp [dpi 62]

  # ELÖVERFÖRING RESULT LABEL
  destroy .eloverforingResult
  if {$forbrukningValid && $eloverforingValid} {
    set eloverforingString "[format "%.2f" [expr {$eloverforing/100.00}]] kr X [format "%.2f" $forbrukning] kWh = [format "%.2f" [expr {$eloverforing*$forbrukning/100.00}]] kr"
    newResult eloverforingResult $eloverforingString
    place .eloverforingResult -in .rightFrame -x 0 -y [dpi $yp] -width [dpi 300] -height [dpi 26]
  }

  incr yp [dpi 62]

  # ENERGISKATT RESULT LABEL
  destroy .energiskattResult
  if {$forbrukningValid && $energiskattValid} {
    set energiskattString "[format "%.2f" [expr {$energiskatt/100.00}]] kr X [format "%.2f" $forbrukning] kWh = [format "%.2f" [expr {$energiskatt*$forbrukning/100.00}]] kr"
    newResult energiskattResult $energiskattString
    place .energiskattResult -in .rightFrame -x 0 -y [dpi $yp] -width [dpi 300] -height [dpi 26]
  }
  incr yp [dpi 62]

  # ELPRIS RESULT LABEL
  destroy .elprisResult
  if {$forbrukningValid && $elprisValid} {
    set elprisString "[format "%.2f" [expr {$elpris/100.00}]] kr X [format "%.2f" $forbrukning] kWh = [format "%.2f" [expr {$elpris*$forbrukning/100.00}]] kr"
    newResult elprisResult $elprisString
    place .elprisResult -in .rightFrame -x 0 -y [dpi $yp] -width [dpi 300] -height [dpi 26]
  }
  incr yp [dpi 62]

  # SPOTPÅSLAG RESULT LABEL
  destroy .spotpaslagResult
  if {$forbrukningValid && $spotpaslagValid} {
    set spotpaslagString "[format "%.2f" [expr {$spotpaslag/100.00}]] kr X [format "%.2f" $forbrukning] kWh = [format "%.2f" [expr {$spotpaslag*$forbrukning/100.00}]] kr"
    newResult spotpaslagResult $spotpaslagString
    place .spotpaslagResult -in .rightFrame -x 0 -y [dpi $yp] -width [dpi 300] -height [dpi 26]
  }
  incr yp [dpi 62]

  # ELCENTRAL RESULT LABEL
  destroy .elcentralResult
  if {$forbrukningValid && $elcentralValid} {
    set elcentralString "[format "%.2f" [expr {$elcentral/100.00}]] kr X [format "%.2f" $forbrukning] kWh = [format "%.2f" [expr {$elcentral*$forbrukning/100.00}]] kr"
    newResult elcentralResult $elcentralString
    place .elcentralResult -in .rightFrame -x 0 -y [dpi $yp] -width [dpi 300] -height [dpi 26]
  }
  incr yp [dpi 36] 

  if {$forbrukningValid && $eloverforingValid && $energiskattValid && $elprisValid && $spotpaslagValid && $elcentralValid} {
    set summa [expr {$forbrukning*($eloverforing+$energiskatt+$elpris+$spotpaslag+$elcentral)/100.00}]
    set moms [expr $summa*0.25]
    set grandTotal [expr $summa+$moms]

    destroy .summaResult
    newResult summaResult "Summa: [format "%.2f" $summa] kr"
    place .summaResult -in .rightFrame -x 0 -y [dpi $yp] -width [dpi 300] -height [dpi 26]
    incr yp [dpi 26]
 
    destroy .momsResult
    newResult momsResult "Moms: [format "%.2f" $moms] kr"
    place .momsResult -in .rightFrame -x 0 -y [dpi $yp] -width [dpi 300] -height [dpi 26]
    incr yp [dpi 26]
  
    destroy .grandTotalResult
    newResult grandTotalResult "Inkl. moms: [format "%.2f" $grandTotal] kr"
    place .grandTotalResult -in .rightFrame -x 0 -y [dpi $yp] -width [dpi 300] -height [dpi 26]
  }
}

calculateResult
(uiop/package:define-package :mycin/mycin-r (:use :cl :mycin/mycin))
(in-package :mycin/mycin-r)
;;;; Code from Paradigms of AI Programming
;;;; Copyright (c) 1991 Peter Norvig

(defparm name :context patient
  :type-restriction t
  :prompt "Patient's name: " :ask-first t :reader read-line)
(defparm sex :context patient
  :type-restriction (member male female)
  :prompt "Sex:" :ask-first t)
(defparm age  :context patient
  :type-restriction number
  :prompt "Age:" :ask-first t)
(defparm burn :context patient
  :type-restriction (member no mild serious)
  :prompt "Is ~a a burn patient?  If so, mild or serious?" :ask-first t)
(defparm compromised-host
  :context patient :type-restriction yes/no
  :prompt "Is ~a a compromised host?")

;;; Parameters for culture:
(defparm site :context culture
  :type-restriction (member blood)
  :prompt "From what site was the specimen for ~a taken?" :ask-first t)
(defparm days-old :context culture
  :type-restriction number
  :prompt "How many days ago was this culture (~a) obtained?" :ask-first t)

;;; Parameters for organism:
(defparm identity :context organism
  :type-restriction (member pseudomonas klebsiella enterobacteriaceae
                            staphylococcus bacteroides streptococcus)
  :prompt "Enter the identity (genus) of ~a:" :ask-first t)
(defparm gram :context organism
  :type-restriction (member acid-fast pos neg)
  :prompt "The gram stain of ~a:" :ask-first t)
(defparm morphology :context organism
  :type-restriction (member rod coccus)
  :prompt "Is ~a a rod or coccus (etc.):")
(defparm aerobicity :context organism
  :type-restriction (member aerobic anaerobic))
(defparm growth-conformation :context organism
  :type-restriction (member chains pairs clumps))

(clear-rules)

(defrule 52
  if (site culture is blood)
     (gram organism is neg)
     (morphology organism is rod)
     (burn patient is serious)
  then .4
     (identity organism is pseudomonas))

(defrule 71
  if (gram organism is pos)
     (morphology organism is coccus)
     (growth-conformation organism is clumps)
  then .7
     (identity organism is staphylococcus))

(defrule 73
  if (site culture is blood)
     (gram organism is neg)
     (morphology organism is rod)
     (aerobicity organism is anaerobic)
  then .9
     (identity organism is bacteroides))

(defrule 75
  if (gram organism is neg)
     (morphology organism is rod)
     (compromised-host patient is yes)
  then .6
     (identity organism is pseudomonas))

(defrule 107
  if (gram organism is neg)
     (morphology organism is rod)
     (aerobicity organism is aerobic)
  then .8
     (identity organism is enterobacteriaceae))

(defrule 165
  if (gram organism is pos)
     (morphology organism is coccus)
     (growth-conformation organism is chains)
  then .7
     (identity organism is streptococcus))

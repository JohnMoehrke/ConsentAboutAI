// This includes the AI specific Consent profiles and examples. 

Alias: $purposeOfUse = http://terminology.hl7.org/CodeSystem/v3-ActReason
Alias: $obligation = http://terminology.hl7.org/CodeSystem/v3-ActCode

Instance: AllowMLtraining
InstanceOf: Consent
Title: "Consent for Machine Learning Training"
Description: "Consent for using data for machine learning training purposes."
Usage: #example
* meta.security = $purposeOfUse#HTEST
* status = #active
* scope = http://terminology.hl7.org/CodeSystem/consentscope#patient-privacy
* category[+] = http://loinc.org#64292-6 "Release of information consent"
* category[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#IDSCL
* patient = Reference(Patient/ex-patient)
* dateTime = "2022-06-13"
* performer.reference = "http://example.org/organizations/ex-organization"
* sourceReference.reference = "http://example.org/documentreferences/ex-documentreference"
* policy.uri = "http://example.org/consent-policies#ml-training-consent-policy"
* provision.type = #permit
* provision.purpose[+] = $purposeOfUse#MLTRAINING



Instance: DenyMLtraining
InstanceOf: Consent
Title: "Consent to disallow Machine Learning Training"
Description: "Consent to disallow using data for machine learning training purposes."
Usage: #example
* meta.security = $purposeOfUse#HTEST
* status = #active
* scope = http://terminology.hl7.org/CodeSystem/consentscope#patient-privacy
* category[+] = http://loinc.org#64292-6 "Release of information consent"
* category[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#IDSCL
* patient = Reference(Patient/ex-patient)
* dateTime = "2022-06-13"
* performer.reference = "http://example.org/organizations/ex-organization"
* sourceReference.reference = "http://example.org/documentreferences/ex-documentreference"
* policy.uri = "http://example.org/consent-policies#ml-training-consent-policy"
* provision.type = #deny
* provision.purpose[+] = $purposeOfUse#MLTRAINING


// Extension to bring the Permission.rule.limit element into the Consent.provision element. This is needed to express the limit on the use of data for ML training to only de-identified data.
Extension: PermissionRuleLimit
Id: permissionRuleLimit
Title: "Permission Rule Limit"
Description: "Extension to express the limit on the use of data for ML training to only de-identified data.

This extension should be used as a ModifierExtension as it is critical to the proper understanding of the consent. If the rule limit is not observed, then the consent is effectively not valid and should not be applied."
* . ^isModifier = true
* . ^isModifierReason = "Indicates limits on a permit."
* ^context[+].type = #element
* ^context[=].expression = "Consent.provision"
* ^context[+].type = #element
* ^context[=].expression = "Consent.provision.provision"
* ^context[+].type = #element
* ^context[=].expression = "Consent.provision.provision.provision"
* ^context[+].type = #element
* ^context[=].expression = "Consent.provision.provision.provision.provision"

* extension contains 
  control 0..* and
  tag 0..* and
  element 0..*
* extension[control] ^short = "Coded restriction such as a refrain or obligation."
* extension[control].value[x] only CodeableConcept
* extension[control].valueCodeableConcept from http://terminology.hl7.org/ValueSet/v3-SecurityControlObservationValue (preferred)
* extension[tag] ^short = "Meta.security tags to be applied to data that is used under this provision."
* extension[tag].value[x] only CodeableConcept
* extension[tag].valueCodeableConcept from http://terminology.hl7.org/ValueSet/v3-InformationSensitivityPolicy (preferred)
* extension[element] ^short = "Specific elements that must be redacted from the data."
* extension[element] ^comment = "The path identifies the element and is expressed as a . separated list of ancestor elements, beginning with the name of the resource or extension."
* extension[element].value[x] only string


Profile: ConsentWithLimits
Parent: Consent
Title: "Consent with use of the Limits extension"
Description: "Consent profile that includes the use of the PermissionRuleLimit extension to express limits on the use of data for ML training."
* provision.modifierExtension contains PermissionRuleLimit named limit 0..*
* provision.provision.modifierExtension contains PermissionRuleLimit named limit 0..*
* provision.provision.provision.modifierExtension contains PermissionRuleLimit named limit 0..*
* provision.provision.provision.provision.modifierExtension contains PermissionRuleLimit named limit 0..*
* provision.provision.provision.provision.provision.modifierExtension contains PermissionRuleLimit named limit 0..*



Instance: AllowMLtrainingOnDeIdentifiedData
InstanceOf: ConsentWithLimits
Title: "Consent for Machine Learning Training on De-Identified Data"
Description: "Consent for using de-identified data for machine learning training purposes."
Usage: #example
* meta.security = $purposeOfUse#HTEST
* status = #active
* scope = http://terminology.hl7.org/CodeSystem/consentscope#patient-privacy
* category[+] = http://loinc.org#64292-6 "Release of information consent"
* category[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#IDSCL
* patient = Reference(Patient/ex-patient)
* dateTime = "2022-06-13"
* performer.reference = "http://example.org/organizations/ex-organization"
* sourceReference.reference = "http://example.org/documentreferences/ex-documentreference"
* policy.uri = "http://example.org/consent-policies#ml-training-consent-policy"
* provision.type = #permit
* provision.purpose[+] = $purposeOfUse#MLTRAINING
* provision.modifierExtension[limit].extension[control].valueCodeableConcept = $obligation#DEID 


Instance: AllowCDS
InstanceOf: Consent
Title: "Consent for Clinical Decision Support"
Description: "Consent for using data for clinical decision support purposes."
Usage: #example
* meta.security = $purposeOfUse#HTEST
* status = #active
* scope = http://terminology.hl7.org/CodeSystem/consentscope#patient-privacy
* category[+] = http://loinc.org#64292-6 "Release of information consent"
* category[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#IDSCL
* patient = Reference(Patient/ex-patient)
* dateTime = "2022-06-13"
* performer.reference = "http://example.org/organizations/ex-organization"
* sourceReference.reference = "http://example.org/documentreferences/ex-documentreference"
* policy.uri = "http://example.org/consent-policies#cds-consent-policy"
* provision.type = #permit
* provision.purpose[+] = $purposeOfUse#TREATDS

Instance: DenyCDS
InstanceOf: Consent
Title: "Consent to disallow Clinical Decision Support"
Description: "Consent to disallow using data for clinical decision support purposes."
Usage: #example
* meta.security = $purposeOfUse#HTEST
* status = #active
* scope = http://terminology.hl7.org/CodeSystem/consentscope#patient-privacy
* category[+] = http://loinc.org#64292-6 "Release of information consent"
* category[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#IDSCL
* patient = Reference(Patient/ex-patient)
* dateTime = "2022-06-13"
* performer.reference = "http://example.org/organizations/ex-organization"
* sourceReference.reference = "http://example.org/documentreferences/ex-documentreference"
* policy.uri = "http://example.org/consent-policies#cds-consent-policy"
* provision.type = #deny
* provision.purpose[+] = $purposeOfUse#TREATDS


Instance: AIdevice
InstanceOf: Device
Title: "AI Device"
Description: """
A Device that indicates an AI system or model. This is not using the AI-Transparency profile in order to keep this IG simple. 
"""
Usage: #example
* identifier.system = "http://example.org/ehr/client-ids"
* identifier.value = "goodhealth"
* manufacturer = "Acme Devices, Inc"
* type = http://snomed.info/sct#736253002 
* type.text = "Artificial intelligence device"
* version.value = "10.23-23423"
* contact.system = #url
* contact.value = "http://example.org"

Instance: AllowSpecificAIforSpecificPurpose
InstanceOf: Consent
Title: "Consent to allow specific AI for a specific purpose"
Description: "Consent to allow the use of a specific AI device for a specific purpose.
In this case a Device is used to represent the specific AI system or model. In this case the purpose is for CDS use."
Usage: #example
* meta.security = $purposeOfUse#HTEST
* status = #active
* scope = http://terminology.hl7.org/CodeSystem/consentscope#patient-privacy
* category[+] = http://loinc.org#64292-6 "Release of information consent"
* category[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#IDSCL
* patient = Reference(Patient/ex-patient)
* dateTime = "2022-06-13"
* performer.reference = "http://example.org/organizations/ex-organization"
* sourceReference.reference = "http://example.org/documentreferences/ex-documentreference"
* policy.uri = "http://example.org/consent-policies#specific-ai-consent"
* provision.type = #permit
* provision.purpose[+] = $purposeOfUse#TREATDS
* provision.actor[0].reference = Reference(AIdevice)
* provision.actor[0].role.coding.display = "CDS"

Instance: AllAiProvisions
InstanceOf: ConsentWithLimits
Title: "Consent with all kinds of Provisions"
Description: "Consent that includes provisions using the various AI mechanisms along with normal TPO.

This consent 
1. permits the patient's care team to have full access
2. permits TPO purposes to have access to Normal data, but not sensitive dta
3. permits ML training purposes to have access to Normal de-identified data, but not sensitive data

Given that FHIR R4 Consent has only ONE root level provision, we need to extra deep nesting:

Provisions
- Permit all the purposes
  - deny ML training for sensitive data
    - permit ML training for de-identified data
  - deny TPO -- just so we can skip to a permit
    - permit TPO for normal confidentiality
    - permit TPO for the care team for sensitive data
"
Usage: #example
* meta.security = $purposeOfUse#HTEST
* status = #active
* scope = http://terminology.hl7.org/CodeSystem/consentscope#patient-privacy
* category[+] = http://loinc.org#64292-6 "Release of information consent"
* category[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#IDSCL
* patient = Reference(Patient/ex-patient)
* dateTime = "2022-06-13"
* performer.reference = "http://example.org/organizations/ex-organization"
* sourceReference.reference = "http://example.org/documentreferences/ex-documentreference"
* policy.uri = "http://example.org/consent-policies#ml-training-consent-policy"

* provision[0]
  * type = #permit
  // Permit of all of the purposeOfUse that are addressed positively in this Consent.
  * purpose[+] = $purposeOfUse#TREAT
  * purpose[+] = $purposeOfUse#HPAYMT
  * purpose[+] = $purposeOfUse#HOPERAT
  * purpose[+] = $purposeOfUse#MLTRAINING

  * provision[0]
    * type = #deny
    // deny ML training to see sensitive topics
    * purpose[+] = $purposeOfUse#MLTRAINING
    * securityLabel[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#ETH
    * securityLabel[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#BH
    * securityLabel[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#PREGNANT
    // Note this does leave ambiguous any R data that are not these three sensitivity tags.
    * provision[0]
      // permit ML to see Normal data that is de-identified
      * provision.type = #permit
      * provision.purpose[+] = $purposeOfUse#MLTRAINING
      * securityLabel[+] = http://terminology.hl7.org/CodeSystem/v3-Confidentiality#N "Normal"
      * provision.modifierExtension[limit].extension[control].valueCodeableConcept = $obligation#DEID 

  * provision[1]
    * type = #deny
    // This deny is simply so we can get to a refined permit for TPO
    * provision[0]
      * type = #permit
      // permit TPO with normal confidentiality and the relevant purposes of use
      * securityLabel[+] = http://terminology.hl7.org/CodeSystem/v3-Confidentiality#N "Normal"
      * purpose[+] = $purposeOfUse#TREAT
      * purpose[+] = $purposeOfUse#HPAYMT
      * purpose[+] = $purposeOfUse#HOPERAT
    * provision[1]
      * type = #permit
      // permit TPO for the careTeam of this patient for sensitive topics
      * securityLabel[+] = http://terminology.hl7.org/CodeSystem/v3-Confidentiality#R
      * purpose[+] = $purposeOfUse#TREAT
      * purpose[+] = $purposeOfUse#HPAYMT
      * purpose[+] = $purposeOfUse#HOPERAT    
      * actor.role = http://terminology.hl7.org/CodeSystem/v3-ParticipationFunction#AUTM  
      * actor.reference.reference = "http://example.org/CareTeam/ex-patient-careteam"

// Note that R4 Consent does not address what rule applies if NONE of the provisions match. (R6 has a default rule at the top level)

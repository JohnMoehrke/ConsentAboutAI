// This includes the AI specific Consent profiles and examples. 

Instance: AllowMLtraining
InstanceOf: Consent
Title: "Consent for Machine Learning Training"
Description: "Consent for using data for machine learning training purposes."
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
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
* provision.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#MLTRAINING



Instance: DenyMLtraining
InstanceOf: Consent
Title: "Consent to disallow Machine Learning Training"
Description: "Consent to disallow using data for machine learning training purposes."
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
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
* provision.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#MLTRAINING


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

* extension contains 
  control 0..* and
  tag 0..* and
  element 0..*
* extension[control] ^short = "Control"
//* extension[control] ^definition = "One or more coded restriction such as a refrain or obligation."
* extension[control].value[x] only CodeableConcept
* extension[control].valueCodeableConcept from http://terminology.hl7.org/ValueSet/v3-SecurityControlObservationValue (preferred)
* extension[tag] ^short = "Tag"
//* extension[tag] ^definition = "One or more tags to be applied to data that is used under this provision."
* extension[tag].value[x] only CodeableConcept
* extension[tag].valueCodeableConcept from http://terminology.hl7.org/ValueSet/v3-InformationSensitivityPolicy (preferred)
* extension[element] ^short = "Element"
//* extension[element] ^definition = "One or more specific elements must be redacted from the data."
//* extension[element] ^comment = "The path identifies the element and is expressed as a . separated list of ancestor elements, beginning with the name of the resource or extension."
* extension[element].value[x] only string


Profile: ConsentWithLimits
Parent: Consent
Title: "Consent with use of the Limits extension"
Description: "Consent profile that includes the use of the PermissionRuleLimit extension to express limits on the use of data for ML training."
* provision.modifierExtension contains PermissionRuleLimit named limit 0..*


Instance: AllowMLtrainingOnDeIdentifiedData
InstanceOf: ConsentWithLimits
Title: "Consent for Machine Learning Training on De-Identified Data"
Description: "Consent for using de-identified data for machine learning training purposes."
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
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
* provision.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#MLTRAINING
* provision.modifierExtension[limit].extension[control].valueCodeableConcept = http://terminology.hl7.org/CodeSystem/v3-ActCode#DEID 


Instance: AllowCDS
InstanceOf: Consent
Title: "Consent for Clinical Decision Support"
Description: "Consent for using data for clinical decision support purposes."
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
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
* provision.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREATDS

Instance: DenyCDS
InstanceOf: Consent
Title: "Consent to disallow Clinical Decision Support"
Description: "Consent to disallow using data for clinical decision support purposes."
Usage: #example
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
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
* provision.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREATDS


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
* meta.security = http://terminology.hl7.org/CodeSystem/v3-ActReason#HTEST
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
* provision.purpose[+] = http://terminology.hl7.org/CodeSystem/v3-ActReason#TREATDS
* provision.actor[0].reference = Reference(AIdevice)
* provision.actor[0].role.coding.display = "CDS"

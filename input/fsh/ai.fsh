// This includes the AI specific Consent profiles and examples. 

Alias: $purposeOfUse = http://terminology.hl7.org/CodeSystem/v3-ActReason
Alias: $obligation = http://terminology.hl7.org/CodeSystem/v3-ActCode
Alias: $limit = http://hl7.org/fhir/StructureDefinition/consent-provision-limit
Alias: $obligationExt = http://hl7.org/fhir/StructureDefinition/obligation
Alias: $AIDevice = http://hl7.org/fhir/uv/aitransparency/StructureDefinition/AI-Device

ValueSet: AiPurposeOfUse
Id: ai-purposeofuse
Title: "AI Purposes Of Use"
Description: "The PurposeOfUse codes for AI uses of data: machine learning training, clinical decision support, and payment decision support."
* ^experimental = false
* $purposeOfUse#MLTRAINING
* $purposeOfUse#TREATDS
* $purposeOfUse#PMTDS

Invariant: aic-ai-device
Description: "When the provision purpose includes an AI purpose of use, an actor that is a Device must conform to the AI Device profile. No purpose, or non-AI purposes, place no constraint on the actor."
Severity: #error
Expression: "purpose.where(memberOf('http://johnmoehrke.github.io/ConsentAboutAI/ValueSet/ai-purposeofuse')).exists() implies actor.reference.resolve().ofType(Device).all(conformsTo('http://hl7.org/fhir/uv/aitransparency/StructureDefinition/AI-Device'))"

Profile: AiConsent
Parent: Consent
Id: ai-consent
Title: "Consent about AI"
Description: """
A Consent profile for recording a patient's decision to permit or deny use of AI.

- The scope is patient-privacy.
- The category indicates Release of Information consent and information disclosure.
- The patient and dateTime are required.
- The performer is the Organization capturing and enforcing the consent.
- The signed consent paperwork, when referenced, is a DocumentReference.
- The root provision carries the type (permit or deny) and the applicable PurposeOfUse code(s), such as MLTRAINING or TREATDS.
- When a specific AI system or model is permitted or denied, the provision.actor.reference identifies that AI as a Device.
- A provision may carry a consent-provision-limit modifierExtension, such as an obligation to de-identify.
"""
// Obligations tying this profile to the Actors: the AI-Consent Author populates conformant Consents; the Access Control processes (enforces) them.
* ^extension[$obligationExt][+].extension[code].valueCode = #SHALL:populate
* ^extension[$obligationExt][=].extension[actor].valueCanonical = Canonical(AiConsentAuthor)
* ^extension[$obligationExt][+].extension[code].valueCode = #SHALL:process
* ^extension[$obligationExt][=].extension[actor].valueCanonical = Canonical(AccessControl)
* scope = http://terminology.hl7.org/CodeSystem/consentscope#patient-privacy
* patient 1..1 MS
* dateTime 1..1 MS
* provision 1..1 MS
* provision obeys aic-ai-device
* provision.type 1..1 MS
* provision.period MS
* provision.purpose 1..* MS
* provision.purpose ^short = "PurposeOfUse code(s) addressed, such as MLTRAINING or TREATDS"
* provision.purpose ^comment = "Any access by the AI, or by an agent feeding the AI, SHALL declare the applicable PurposeOfUse code when accessing data."
* provision.actor MS
* provision.actor ^comment = "When a specific AI system or model is permitted or denied, the actor.reference SHALL identify that AI as a Device, and all data access by the AI SHALL be attributed to that Device."
* provision.modifierExtension contains $limit named limit 0..1
* provision.modifierExtension[limit] ^short = "Limits, such as an obligation to de-identify, placed on a permit provision"
* provision.provision ^slicing.discriminator.type = #value
* provision.provision ^slicing.discriminator.path = "purpose"
* provision.provision ^slicing.rules = #open
* provision.provision contains aiProvision 0..*
* provision.provision obeys aic-ai-device
* provision.provision[aiProvision] ^short = "Provision addressing an AI purpose of use"
* provision.provision[aiProvision].type 1..1 MS
* provision.provision[aiProvision].purpose 1..* MS
* provision.provision[aiProvision].purpose from AiPurposeOfUse (required)
* provision.provision[aiProvision].actor ^slicing.discriminator.type = #type
* provision.provision[aiProvision].actor ^slicing.discriminator.path = "reference.resolve()"
* provision.provision[aiProvision].actor ^slicing.rules = #open
* provision.provision[aiProvision].actor contains aiDevice 0..*
* provision.provision[aiProvision].actor[aiDevice] ^short = "The specific AI system or model being permitted or denied"
* provision.provision[aiProvision].actor[aiDevice].reference only Reference($AIDevice)
* provision.provision[aiProvision].modifierExtension contains $limit named limit 0..1
* provision.provision[aiProvision].modifierExtension[limit] ^short = "Limits, such as an obligation to de-identify, placed on a permit provision"
// The level 2 profiling is replicated at level 3; the publisher recognizes replicated profiling at two levels as applying to infinite levels.
* provision.provision[aiProvision].provision ^slicing.discriminator.type = #value
* provision.provision[aiProvision].provision ^slicing.discriminator.path = "purpose"
* provision.provision[aiProvision].provision ^slicing.rules = #open
* provision.provision[aiProvision].provision contains aiProvision 0..*
* provision.provision[aiProvision].provision obeys aic-ai-device
* provision.provision[aiProvision].provision[aiProvision] ^short = "Provision addressing an AI purpose of use"
* provision.provision[aiProvision].provision[aiProvision].type 1..1 MS
* provision.provision[aiProvision].provision[aiProvision].purpose 1..* MS
* provision.provision[aiProvision].provision[aiProvision].purpose from AiPurposeOfUse (required)
* provision.provision[aiProvision].provision[aiProvision].actor ^slicing.discriminator.type = #type
* provision.provision[aiProvision].provision[aiProvision].actor ^slicing.discriminator.path = "reference.resolve()"
* provision.provision[aiProvision].provision[aiProvision].actor ^slicing.rules = #open
* provision.provision[aiProvision].provision[aiProvision].actor contains aiDevice 0..*
* provision.provision[aiProvision].provision[aiProvision].actor[aiDevice] ^short = "The specific AI system or model being permitted or denied"
* provision.provision[aiProvision].provision[aiProvision].actor[aiDevice].reference only Reference($AIDevice)
* provision.provision[aiProvision].provision[aiProvision].modifierExtension contains $limit named limit 0..1
* provision.provision[aiProvision].provision[aiProvision].modifierExtension[limit] ^short = "Limits, such as an obligation to de-identify, placed on a permit provision"

/* asked about nested context - https://chat.fhir.org/#narrow/channel/179252-IG-creation/topic/extension.20context.20on.20nested.20element/with/616962935 */


Instance: AllowMLtraining
InstanceOf: AiConsent
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
InstanceOf: AiConsent
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


Instance: AllowMLtrainingOnDeIdentifiedData
InstanceOf: AiConsent
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
InstanceOf: AiConsent
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
InstanceOf: AiConsent
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


Instance: AllowPaymentDS
InstanceOf: AiConsent
Title: "Consent for Payment Decision Support"
Description: "Consent for using data for payment decision support purposes."
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
* policy.uri = "http://example.org/consent-policies#payment-ds-consent-policy"
* provision.type = #permit
* provision.purpose[+] = $purposeOfUse#PMTDS


Instance: DenyPaymentDS
InstanceOf: AiConsent
Title: "Consent to disallow Payment Decision Support"
Description: "Consent to disallow using data for payment decision support purposes."
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
* policy.uri = "http://example.org/consent-policies#payment-ds-consent-policy"
* provision.type = #deny
* provision.purpose[+] = $purposeOfUse#PMTDS


Instance: AIdevice
InstanceOf: AI-Device
Title: "AI Device"
Description: """
A Device that indicates an AI system or model, compliant with the [AI Transparency AI-Device profile](https://build.fhir.org/ig/HL7/aitransparency-ig/StructureDefinition-AI-Device.html).
"""
Usage: #example
* identifier.system = "http://example.org/ehr/client-ids"
* identifier.value = "goodhealth"
* manufacturer = "Acme Devices, Inc"
* type = http://terminology.hl7.org/CodeSystem/AIdeviceTypeCS#Artificial-Intelligence
* type.text = "Artificial intelligence device"
* version.value = "10.23-23423"
* contact.system = #url
* contact.value = "http://example.org"


Instance: AllowSpecificAIforSpecificPurpose
InstanceOf: AiConsent
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
* provision.actor[0].role.text = "CDS"

Instance: DenySpecificAIforSpecificPurpose
InstanceOf: AiConsent
Title: "Consent to deny specific AI for a specific purpose"
Description: "Consent to deny the use of a specific AI device for a specific purpose.
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
* provision.type = #deny
* provision.purpose[+] = $purposeOfUse#TREATDS
* provision.actor[0].reference = Reference(AIdevice)
* provision.actor[0].role.text = "CDS"

Instance: AllAiProvisions
InstanceOf: AiConsent
Title: "Consent with all kinds of Provisions"
Description: "Consent that includes provisions using the various AI mechanisms along with normal TPO.

This consent 
1. permits the patient's care team to have full access
2. permits TPO purposes to have access to Normal data, but not sensitive data
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

* provision.type = #permit
  // Permit of all of the purposeOfUse that are addressed positively in this Consent.
* provision.purpose[+] = $purposeOfUse#TREAT
* provision.purpose[+] = $purposeOfUse#HPAYMT
* provision.purpose[+] = $purposeOfUse#HOPERAT
* provision.purpose[+] = $purposeOfUse#MLTRAINING

* provision.provision[aiProvision].type = #deny
    // deny ML training to see sensitive topics
* provision.provision[aiProvision].purpose[+] = $purposeOfUse#MLTRAINING
* provision.provision[aiProvision].securityLabel[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#ETH
* provision.provision[aiProvision].securityLabel[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#BH
* provision.provision[aiProvision].securityLabel[+] = http://terminology.hl7.org/CodeSystem/v3-ActCode#PREGNANT
    // Note this does leave ambiguous any R data that are not these three sensitivity tags.
* provision.provision[aiProvision].provision[aiProvision][0]
      // permit ML to see Normal data that is de-identified
* provision.provision[aiProvision].provision[aiProvision][0].type = #permit
* provision.provision[aiProvision].provision[aiProvision][0].purpose[+] = $purposeOfUse#MLTRAINING
* provision.provision[aiProvision].provision[aiProvision][0].securityLabel[+] = http://terminology.hl7.org/CodeSystem/v3-Confidentiality#N "Normal"
* provision.provision[aiProvision].provision[aiProvision][0].modifierExtension[limit].extension[control].valueCodeableConcept = $obligation#DEID 

* provision.provision[1].type = #deny
    // This deny is simply so we can get to a refined permit for TPO
* provision.provision[1].provision[0].type = #permit
// permit TPO with normal confidentiality and the relevant purposes of use
* provision.provision[1].provision[0].securityLabel[+] = http://terminology.hl7.org/CodeSystem/v3-Confidentiality#N "Normal"
* provision.provision[1].provision[0].purpose[+] = $purposeOfUse#TREAT
* provision.provision[1].provision[0].purpose[+] = $purposeOfUse#HPAYMT
* provision.provision[1].provision[0].purpose[+] = $purposeOfUse#HOPERAT
* provision.provision[1].provision[1].type = #permit
// permit TPO for the careTeam of this patient for sensitive topics
* provision.provision[1].provision[1].securityLabel[+] = http://terminology.hl7.org/CodeSystem/v3-Confidentiality#R
* provision.provision[1].provision[1].purpose[+] = $purposeOfUse#TREAT
* provision.provision[1].provision[1].purpose[+] = $purposeOfUse#HPAYMT
* provision.provision[1].provision[1].purpose[+] = $purposeOfUse#HOPERAT    
* provision.provision[1].provision[1].actor.role = http://terminology.hl7.org/CodeSystem/v3-ParticipationFunction#AUTM  
* provision.provision[1].provision[1].actor.reference.reference = "http://example.org/CareTeam/ex-patient-careteam"

// Note that R4 Consent does not address what rule applies if NONE of the provisions match. (R6 has a default rule at the top level)

Instance: ThreeLevelsDeep
InstanceOf: AiConsent
Title: "Consent with provisions three levels deep"
Description: "Consent that nests provisions three levels deep to assure that the AiConsent profiling applies at the third level.

Provisions
- permit TPO and AI clinical decision support purposes (level 1)
  - deny AI clinical decision support (level 2)
    - permit a specific AI Device for clinical decision support on Normal data, with a limit prohibiting reuse (level 3)
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
* policy.uri = "http://example.org/consent-policies#three-levels-deep"

* provision.type = #permit
  // Permit of all of the purposeOfUse that are addressed positively in this Consent. (level 1)
* provision.purpose[+] = $purposeOfUse#TREAT
* provision.purpose[+] = $purposeOfUse#HPAYMT
* provision.purpose[+] = $purposeOfUse#HOPERAT
* provision.purpose[+] = $purposeOfUse#TREATDS

* provision.provision[aiProvision][0].type = #deny
    // deny AI clinical decision support generally (level 2)
* provision.provision[aiProvision][0].purpose[+] = $purposeOfUse#TREATDS

* provision.provision[aiProvision][0].provision[aiProvision][0].type = #permit
// permit a specific AI Device for clinical decision support on Normal data, prohibiting reuse (level 3)
* provision.provision[aiProvision][0].provision[aiProvision][0].purpose[+] = $purposeOfUse#TREATDS
* provision.provision[aiProvision][0].provision[aiProvision][0].securityLabel[+] = http://terminology.hl7.org/CodeSystem/v3-Confidentiality#N "Normal"
* provision.provision[aiProvision][0].provision[aiProvision][0].actor[0].reference = Reference(AIdevice)
* provision.provision[aiProvision][0].provision[aiProvision][0].actor[0].role.text = "CDS"
* provision.provision[aiProvision][0].provision[aiProvision][0].modifierExtension[limit].extension[control].valueCodeableConcept = $obligation#NOREUSE

